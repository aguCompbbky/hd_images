import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:hd_images/core/network/dio_client.dart';
import 'package:hd_images/core/theme/theme_cubit.dart';
import 'package:hd_images/features/auth/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:hd_images/features/auth/data/repositories_impl/auth_repository_impl.dart';
import 'package:hd_images/features/auth/domain/repositories/auth_repository.dart';
import 'package:hd_images/features/auth/domain/usecases/google_login_usecase.dart';
import 'package:hd_images/features/auth/domain/usecases/login_usecase.dart';
import 'package:hd_images/features/auth/domain/usecases/register_usecase.dart';
import 'package:hd_images/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:hd_images/features/upscale/data/data_sources/local/tflite_data_source.dart';
import 'package:hd_images/features/upscale/data/repositories_impl/upscale_repository_impl.dart';
import 'package:hd_images/features/upscale/domain/repositories/upscale_repository.dart';
import 'package:hd_images/features/upscale/domain/usecases/upscale_usecase.dart';
import 'package:hd_images/features/upscale/presentation/cubit/upscale_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(DioClient.new);
  sl.registerLazySingleton(() => ThemeCubit(sharedPreferences: sl()));

  // Third Party
  sl.registerLazySingleton(() => FirebaseAuth.instance);


  // Auth Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl(),
    ),
  );

  // Auth Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Auth Usecases
  sl.registerLazySingleton(() => LoginUsecase(sl()));
  sl.registerLazySingleton(() => GoogleLoginUsecase(sl()));
  sl.registerLazySingleton(() => RegisterUsecase(sl()));

  // Auth Cubit
  sl.registerFactory(() => AuthCubit(
    loginUsecase: sl(),
    googleLoginUsecase: sl(),
    registerUsecase: sl(),
  ));

  // Upscale Cubit & Data
  sl.registerLazySingleton<TFLiteDataSource>(TFLiteDataSourceImpl.new);
  sl.registerLazySingleton<UpscaleRepository>(
    () => UpscaleRepositoryImpl(tfliteDataSource: sl()),
  );
  sl.registerLazySingleton(() => UpscaleUsecase(sl()));

  sl.registerFactory(() => UpscaleCubit(upscaleUsecase: sl()));
}
