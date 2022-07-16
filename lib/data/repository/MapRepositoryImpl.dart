import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter_example/data/api/network_info.dart';
import 'package:google_maps_flutter_example/data/model/api_result_model.dart';
import 'package:google_maps_flutter_example/data/repository/MapRemoteDataSource.dart';
import 'package:google_maps_flutter_example/domain/repository/MapRepository.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';

class MapRepositoryImpl extends MapRepository {
  final MapRemoteDataSource mapRemoteDataSource;
  final NetworkInfo networkInfo;

  MapRepositoryImpl(this.mapRemoteDataSource, this.networkInfo);

  @override
  Future<Either<String, APIResultModel>> setPolyLines(
      LatLng l1, LatLng l2) async {
    if (await networkInfo.isConnected) {
      try {
        final body = {
          'origin': '${l1.latitude},${l1.longitude}',
          'destination': '${l2.latitude},${l2.longitude}',
          'key': 'AIzaSyAERKSFYMxdSR6mrMmgyesmQOr8miAFd4c',
        };

        return await mapRemoteDataSource.setPolyLines(body).then((value) {
          return value.fold((failure1) => Left(failure1.toString()),
              (data1) async {
            return Right(data1);
          });
        });
      } on Exception catch (error) {
        return Left(error.toString());
      }
    } else {
      return const Left("فشل في الاتصال");
    }
  }
}
