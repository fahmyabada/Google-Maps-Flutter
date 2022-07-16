import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter_example/data/api/network_info.dart';
import 'package:google_maps_flutter_example/data/repository/MapRemoteDataSource.dart';
import 'package:google_maps_flutter_example/data/repository/MapRepositoryImpl.dart';
import 'package:google_maps_flutter_example/domain/repository/MapRepository.dart';
import 'package:google_maps_flutter_example/domain/usecase/SetPolyLinesUseCase.dart';
import 'package:google_maps_flutter_example/presentation/cubit/google_map_cubit.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  //! Features - Number Trivia
  // Bloc
  getIt.registerFactory(() => GoogleMapCubit());

  // Use cases
  getIt.registerLazySingleton(() => SetPolyLinesUseCase(getIt()));

  // Repository
  getIt.registerLazySingleton<MapRepository>(
    () => MapRepositoryImpl(
      getIt(),
      getIt(),
    ),
  );


  // Data sources
  getIt.registerLazySingleton<MapRemoteDataSource>(
      () => MapRemoteDataSourceImpl());

  //! Core
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));

  getIt.registerLazySingleton(() => InternetConnectionChecker());
}
