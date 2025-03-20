import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/order.dart';
import 'package:flutter_app/app/networking/profile_api_service.dart';
import '/config/decoders.dart';
import 'package:nylo_framework/nylo_framework.dart';

class OrdersApiService extends NyApiService {
  final _profileApiService = ProfileApiService();

  OrdersApiService({BuildContext? buildContext})
      : super(buildContext, decoders: modelDecoders);

  @override
  String get baseUrl => getEnv('API_BASE_URL');

  Future<Order?> create({required Object data}) async {
    final _profile = await _profileApiService.getProfile();

    return await network(
      request: (request) =>
          request.post("/orders/create?userId=${_profile?.id}", data: data),
    );
  }

  Future<List<Order>?> findAll() async {
    final _profile = await _profileApiService.getProfile();

    return await network(
      request: (request) => request.get("/orders/user/${_profile?.id}"),
    );
  }
}
