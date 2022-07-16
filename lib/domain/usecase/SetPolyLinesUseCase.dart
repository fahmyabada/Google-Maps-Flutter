import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_example/data/model/api_result_model.dart';
import 'package:google_maps_flutter_example/domain/repository/MapRepository.dart';

class SetPolyLinesUseCase {
  final MapRepository mapRepository;

  SetPolyLinesUseCase(this.mapRepository);

  Future<Either<String, APIResultModel>> execute(LatLng l1, LatLng l2) {
    return mapRepository.setPolyLines(l1, l2);
  }
}
