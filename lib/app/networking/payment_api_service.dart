import 'package:flutter/material.dart';
import 'package:flutter_app/app/networking/profile_api_service.dart';
import '/config/decoders.dart';
import 'package:nylo_framework/nylo_framework.dart';

class PaymentApiService extends NyApiService {
  final _profileApiService = ProfileApiService();

  PaymentApiService({BuildContext? buildContext})
      : super(buildContext, decoders: modelDecoders);

  @override
  String get baseUrl => getEnv('API_BASE_URL');

  Future<dynamic> payProcess({
    required int orderId,
    required String method,
  }) async {
    final _profile = await _profileApiService.getProfile();

    return await network(
      request: (request) => request.post(
          "/payments/pay_process?orderId=${orderId}&method=${method}&userId=${_profile?.id}"),
    );
  }
}
