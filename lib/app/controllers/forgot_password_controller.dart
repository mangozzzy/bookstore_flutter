import 'package:flutter_app/app/networking/password_api_service.dart';
import 'package:nylo_framework/nylo_framework.dart';

import '/app/controllers/controller.dart';
import 'package:flutter/widgets.dart';

class ForgotPasswordController extends Controller {
  final _passwordApiService = PasswordApiService();

  @override
  construct(BuildContext context) {
    super.construct(context);
  }

  Future<void> sendEmail({
    required String email,
  }) async {
    await _passwordApiService.search(email: email);
    routeTo(
      "/password-verification",
      queryParameters: {"email": email},
    );
  }
}
