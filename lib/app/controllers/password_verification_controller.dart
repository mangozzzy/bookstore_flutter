import 'package:flutter_app/app/models/verify_code.dart';
import 'package:flutter_app/app/networking/password_api_service.dart';

import '/app/controllers/controller.dart';
import 'package:flutter/widgets.dart';

class PasswordVerificationController extends Controller {
  final _passwordApiService = PasswordApiService();

  @override
  construct(BuildContext context) {
    super.construct(context);
  }

  Future<VerifyCode?> sendAuthenticationCode({
    required String email,
    required String authenticationCode,
  }) async {
    final res = await _passwordApiService.verifyCode(
      email: email,
      authenticationCode: authenticationCode,
    );

    return res;
  }
}
