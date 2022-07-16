import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_example/data/model/api_result_model.dart';

abstract class MapRepository {
  Future<Either<String, APIResultModel>> setPolyLines(LatLng l1, LatLng l2);
}
