import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/core/network/api_client.dart';
import 'package:flutter_boilerplate/core/network/network_info.dart';
import 'package:flutter_boilerplate/core/services/storage_service.dart';
import 'package:flutter_boilerplate/data/repositories/auth_repository_impl.dart';
import 'package:flutter_boilerplate/domain/repositories/auth_repository.dart';
import 'package:flutter_boilerplate/domain/usecases/auth/login_usecase.dart';
import 'package:flutter_boilerplate/presentation/viewmodels/auth/login_viewmodel.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  getIt.registerSingleton<Dio>(Dio());
  getIt.registerSingleton<Connectivity>(Connectivity());

  // Core
  getIt.registerSingleton<NetworkInfo>(
    NetworkInfoImpl(getIt<Connectivity>()),
  );

  getIt.registerSingleton<StorageService>(
    SharedPrefsStorageService(getIt<SharedPreferences>()),
  );

  getIt.registerSingleton<ApiClient>(
    ApiClient(
      dio: getIt<Dio>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  // Repositories
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(
      apiClient: getIt<ApiClient>(),
      networkInfo: getIt<NetworkInfo>(),
      storageService: getIt<StorageService>(),
    ),
  );

  // Use cases
  getIt.registerSingleton<LoginUseCase>(
    LoginUseCase(getIt<AuthRepository>()),
  );

  // ViewModels
  getIt.registerFactory<LoginViewModel>(
    () => LoginViewModel(loginUseCase: getIt<LoginUseCase>()),
  );
}
