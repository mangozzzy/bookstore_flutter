import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/cart.dart';
import 'package:flutter_app/app/networking/profile_api_service.dart';
import '/config/decoders.dart';
import 'package:nylo_framework/nylo_framework.dart';

class CartApiService extends NyApiService {
  final _profileApiService = ProfileApiService();
  CartApiService({BuildContext? buildContext})
      : super(buildContext, decoders: modelDecoders);

  @override
  String get baseUrl => getEnv('API_BASE_URL');

  Future<Cart?> add({
    required int bookId,
    required int quantity,
  }) async {
    final _profile = await _profileApiService.getProfile();
    return await network<Cart>(
      request: (request) => request.post(
          "/api/cart/add?userId=${_profile!.id}&bookId=${bookId}&quantity=${quantity}"),
    );
  }

  Future<Cart?> remove({
    required int bookId,
  }) async {
    final _profile = await _profileApiService.getProfile();
    return await network<Cart>(
      request: (request) => request.delete(
        "/api/cart/remove/${bookId}?userId=${_profile!.id}",
      ),
    );
  }

  Future<Cart?> getItems() async {
    final _profile = await _profileApiService.getProfile();
    return await network<Cart>(
      request: (request) => request.get("/api/cart/${_profile!.id}"),
    );
  }
}
