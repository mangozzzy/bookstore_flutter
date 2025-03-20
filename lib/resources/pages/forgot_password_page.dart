import 'package:flutter/material.dart';
import 'package:flutter_app/app/controllers/forgot_password_controller.dart';
import 'package:gap/gap.dart';
import 'package:nylo_framework/nylo_framework.dart';

class ForgotPasswordPage extends NyStatefulWidget {
  static RouteView path = ("/forgot-password", (_) => ForgotPasswordPage());

  ForgotPasswordPage({super.key})
      : super(child: () => _ForgotPasswordPageState());
}

class _ForgotPasswordPageState extends NyPage<ForgotPasswordPage> {
  final _emailField = TextEditingController();
  final _controller = ForgotPasswordController();

  @override
  get init => () {};

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("email"),
              NyTextField(
                controller: _emailField,
              ),
              Gap(20),
              ElevatedButton(
                onPressed: () async  {
                  await _controller.sendEmail(email: _emailField.text);
                  },
                child: Text("Send"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
