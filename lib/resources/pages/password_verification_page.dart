import 'package:flutter/material.dart';
import 'package:flutter_app/app/controllers/password_verification_controller.dart';
import 'package:gap/gap.dart';
import 'package:nylo_framework/nylo_framework.dart';

class PasswordVerificationPage extends NyStatefulWidget {
  static RouteView path =
      ("/password-verification", (_) => PasswordVerificationPage());

  PasswordVerificationPage({super.key})
      : super(child: () => _PasswordVerificationPageState());
}

class _PasswordVerificationPageState extends NyPage<PasswordVerificationPage> {
  final _authenticationField = TextEditingController();
  final _controller = PasswordVerificationController();

  String password = "";

  @override
  get init => () {};

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Password Verification")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Input code sended to ${queryParameters()['email']}",
              ),
              NyTextField(
                controller: _authenticationField,
              ),
              ElevatedButton(
                onPressed: () async {
                  final res = await _controller.sendAuthenticationCode(
                    email: queryParameters()['email'],
                    authenticationCode: _authenticationField.text,
                  );

                  setState(() {
                    password = res?.password ?? "";
                  });
                },
                child: Text("Submit"),
              ),
              Gap(20),
              Text("Your password is ${password} ")
            ],
          ),
        ),
      ),
    );
  }
}
