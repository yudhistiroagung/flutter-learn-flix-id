import 'dart:io';

import 'package:flix_id/domain/entities/result.dart';
import 'package:flix_id/domain/entities/user.dart';
import 'package:flix_id/domain/usecases/get_logged_in_user/get_logged_in_user.dart';
import 'package:flix_id/domain/usecases/login/login.dart';
import 'package:flix_id/domain/usecases/logout/logout.dart';
import 'package:flix_id/domain/usecases/register/register.dart';
import 'package:flix_id/domain/usecases/register/register_params.dart';
import 'package:flix_id/domain/usecases/top_up/top_up.dart';
import 'package:flix_id/domain/usecases/top_up/top_up_params.dart';
import 'package:flix_id/domain/usecases/upload_profile_picture/upload_profile_picture.dart';
import 'package:flix_id/domain/usecases/upload_profile_picture/upload_profile_picture_params.dart';
import 'package:flix_id/presentation/providers/movie/now_playing_provider.dart';
import 'package:flix_id/presentation/providers/movie/upcoming_provider.dart';
import 'package:flix_id/presentation/providers/transaction_data/transaction_data_provider.dart';
import 'package:flix_id/presentation/providers/usecases/get_logged_in_user_provider.dart';
import 'package:flix_id/presentation/providers/usecases/login_provider.dart';
import 'package:flix_id/presentation/providers/usecases/logout_provider.dart';
import 'package:flix_id/presentation/providers/usecases/register_provider.dart';
import 'package:flix_id/presentation/providers/usecases/top_up_provider.dart';
import 'package:flix_id/presentation/providers/usecases/upload_profile_picture_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_data_provider.g.dart';

@Riverpod(keepAlive: true)
class UserData extends _$UserData {
  @override
  Future<User?> build() async {
    GetLoggedInUser getLoggedInUser = ref.read(getLoggedInUserProvider);
    final result = await getLoggedInUser(null);

    switch (result) {
      case Success(value: final user):
        _getMovies();
        return user;

      case Failed(message: _):
        return null;
    }
  }

  void login({required String email, required String password}) async {
    Login login = ref.read(loginProvider);

    final result = await login(LoginParams(email: email, password: password));

    switch (result) {
      case Success(value: final user):
        _getMovies();
        state = AsyncData(user);
      case Failed(:final message):
        state = AsyncError(FlutterError(message), StackTrace.current);
        state = const AsyncData(null);
    }
  }

  void register(
      {required String name,
      required String email,
      required String password,
      String? photoUrl}) async {
    state = const AsyncLoading();

    Register register = ref.read(registerProvider);

    final result = await register(RegisterParams(
        name: name, email: email, password: password, photoUrl: photoUrl));

    switch (result) {
      case Success(value: final user):
        _getMovies();
        state = AsyncData(user);
      case Failed(:final message):
        state = AsyncError(FlutterError(message), StackTrace.current);
        state = const AsyncData(null);
    }
  }

  void refreshUserData() async {
    GetLoggedInUser getLoggedInUser = ref.read(getLoggedInUserProvider);

    final result = await getLoggedInUser(null);

    if (result case Success(value: final user)) {
      state = AsyncData(user);
    }
  }

  void logout() async {
    Logout logout = ref.read(logoutProvider);

    final result = await logout(null);

    switch (result) {
      case Success(value: _):
        state = const AsyncData(null);
      case Failed(:final message):
        state = AsyncError(FlutterError(message), StackTrace.current);
        state = AsyncData(state.valueOrNull);
    }
  }

  void topUp(int amount) async {
    TopUp topUp = ref.read(topUpProvider);

    String? userId = state.value?.uid;

    if (userId == null) {
      state =
          AsyncError(FlutterError("No user in current stae"), StackTrace.empty);
      state = AsyncData(state.valueOrNull);
      return;
    }

    final result = await topUp(TopUpParams(amount: amount, uid: userId));

    if (result.isSuccess) {
      refreshUserData();
      ref.read(transactionDataProvider.notifier).refreshTransaction();
    }
  }

  void uploadProfilePcture(File imageFile) async {
    UploadProfilePicture uploadProfilePicture =
        ref.read(uploadProfilePictureProvider);

    User? user = state.value;
    if (user == null) {
      state =
          AsyncError(FlutterError("No user in current stae"), StackTrace.empty);
      state = AsyncData(state.valueOrNull);
      return;
    }

    final result = await uploadProfilePicture(
        UploadProfilePictureParams(imageFile: imageFile, user: user));

    if (result case Success(value: final user)) {
      state = AsyncData(user);
    }
  }

  void _getMovies() {
    ref.read(nowPlayingProvider.notifier).getMovies();
    ref.read(upcomingProviderProvider.notifier).getMovies();
  }
}
