import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/comment.dart';
import 'package:flutter_app/app/models/profile.dart';
import 'package:flutter_app/app/networking/comment_api_service.dart';
import 'package:flutter_app/app/networking/profile_api_service.dart';
import 'package:nylo_framework/nylo_framework.dart';

class ProfilePage extends NyStatefulWidget {
  static RouteView path = ("/profile", (_) => ProfilePage());

  ProfilePage({super.key}) : super(child: () => _ProfilePageState());
}

class _ProfilePageState extends NyPage<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String _selectedGender = '남성';
  final List<String> _selectedInterests = [];
  final List<String> _availableInterests = [
    '과학',
    '소설',
    '인문',
    '에세이',
    '역사',
    '예술',
    '경제'
  ];

  final _apiService = ProfileApiService();
  final _commentApiService = CommentApiService();

  late Profile? _profile;
  late List<Comment>? _comments;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  get init => () async {
        _profile = await _apiService.getProfile();
        _comments = await _commentApiService.getMyComments();
        // 초기 데이터 설정
        _nameController.text = _profile?.name ?? "";
        _emailController.text = _profile?.email ?? "";
        _phoneController.text = _profile?.phoneNumber ?? "";
        _birthController.text = _profile?.birthDate ?? "";
        _addressController.text = _profile?.address ?? "";
        _selectedInterests.addAll(['과학', '소설']); // 초기 관심사
      };

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("회원정보관리"),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: Text("저장", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildProfileImage(),
              SizedBox(height: 24),
              _buildBasicInfoSection(),
              SizedBox(height: 24),
              _buildInterestsSection(),
              SizedBox(height: 24),
              _buildActionButtons(),
              SizedBox(height: 24),
              _buildCommentSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage("https://via.placeholder.com/100"),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 18,
              child: IconButton(
                icon: Icon(Icons.camera_alt, size: 18, color: Colors.white),
                onPressed: () {
                  // 프로필 이미지 변경 로직
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("기본 정보",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: '이름',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text("성별: "),
                Radio(
                  value: '남성',
                  groupValue: _selectedGender,
                  onChanged: (value) =>
                      setState(() => _selectedGender = value!),
                ),
                Text('남성'),
                Radio(
                  value: '여성',
                  groupValue: _selectedGender,
                  onChanged: (value) =>
                      setState(() => _selectedGender = value!),
                ),
                Text('여성'),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              controller: _birthController,
              decoration: InputDecoration(
                labelText: '생년월일',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: '전화번호',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: '이메일',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: '주소',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInterestsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("관심 분야",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: _availableInterests.map((interest) {
                final isSelected = _selectedInterests.contains(interest);
                return FilterChip(
                  label: Text(interest),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedInterests.add(interest);
                      } else {
                        _selectedInterests.remove(interest);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/order-history');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text('구매내역 관리'),
          ),
        ),
        SizedBox(height: 8),
        ElevatedButton(
          onPressed: () => _showMyComments(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text('내 댓글 관리'),
          ),
        ),
        SizedBox(height: 8),
        OutlinedButton(
          onPressed: () {
            // 로그아웃 로직
            routeTo('/login');
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text('로그아웃'),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.blue,
          ),
        ),
        SizedBox(height: 8),
        OutlinedButton(
          onPressed: () => _showDeleteAccountDialog(),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text('회원 탈퇴'),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
          ),
        ),
      ],
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('회원 탈퇴'),
        content: Text('정말로 탈퇴하시겠습니까? 이 작업은 되돌릴 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              // 회원 탈퇴 로직 구현
              await _apiService.deleteUser();
              routeTo('/login');
            },
            child: Text('탈퇴', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showMyComments() {
    // 댓글 관리 페이지로 이동하거나 모달 표시
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommentManagementPage(),
      ),
    );
  }

  void _saveProfile() {
    // 프로필 저장 로직
    showToast(
      title: "알림",
      description: "회원정보가 저장되었습니다.",
    );
  }

  Widget _buildCommentSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("최근 댓글",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _comments?.length,
              itemBuilder: (context, index) {
                final _comment = _comments?[index];
                return ListTile(
                  title: Text('댓글 내용 ${_comment?.content}'),
                  subtitle: Text('게시글: 제목 ${_comment?.book?.title}'),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    routeTo('/book-detail', queryParameters: {'id': _comment?.book?.bookId.toString()});
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// 댓글 관리 페이지
class CommentManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내 댓글 관리'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: 10, // 예시 데이터
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text('댓글 내용 ${index + 1}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('게시글: 제목 ${index + 1}'),
                  Text('작성일: 2024-03-${index + 1}'),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  // 해당 댓글이 있는 게시글로 이동
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
