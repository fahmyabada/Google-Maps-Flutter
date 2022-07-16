import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter_example/data/api/Dio_Helper.dart';
import 'package:google_maps_flutter_example/data/model/api_result_model.dart';

import '../Utils/Constant.dart';

abstract class MapRemoteDataSource {
  Future<Either<String, APIResultModel>> setPolyLines(dynamic parameters);
}

class MapRemoteDataSourceImpl implements MapRemoteDataSource {
  @override
  Future<Either<String, APIResultModel>> setPolyLines(
      dynamic parameters) async {
    try {
      return await DioHelper.postData(
              url: '/maps/api/directions/json', query: parameters)
          .then((value) async {
        if (value.statusCode == 200) {
          try {
            final responseBody = value.data;
            return Right(APIResultModel(
              success: value.statusCode == 200,
              message: responseBody['status'] ?? responseBody['error_message'],
              data:  responseBody,
            ));
          } catch (error) {
            print('Error in getting result from response:\n $error');
            return const Left("cannot init result api");
          }
        } else {
          return Left(serverFailureMessage);
        }
      });
    } on Exception {
      return Left(serverFailureMessage);
    }
  }
}
