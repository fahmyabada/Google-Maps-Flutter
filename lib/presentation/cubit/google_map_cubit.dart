import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_example/data/model/api_result_model.dart';
import 'package:google_maps_flutter_example/domain/usecase/SetPolyLinesUseCase.dart';
import 'package:google_maps_flutter_example/presentation/di/injection_container.dart';
import 'package:google_maps_flutter_example/presentation/services/current_location_service.dart';
import 'package:location/location.dart';

part 'google_map_state.dart';

class GoogleMapCubit extends Cubit<GoogleMapState> {
  GoogleMapCubit() : super(GoogleMapInitial());

  var updateAllDataUseCase = getIt<SetPolyLinesUseCase>();

  static GoogleMapCubit get(context) => BlocProvider.of(context);

  APIResultModel? routeCoordinates;

  Future<APIResultModel> getRouteCoordinates(LatLng l1, LatLng l2) {
    emit(GoogleMapInitial());
    return updateAllDataUseCase.execute(l1, l2).then((value) {
      return value.fold((failure) {
        GoogleMapErrorState(failure);
        return routeCoordinates = APIResultModel(message: failure,success: false,data: null);
      }, (data) {
        GoogleMapSuccessState(data);
        return routeCoordinates = data;
      });
    });
  }

  LocationData? currentLocation;
  List<LocationData> locations = [];
  CurrentLocationService currentLocationService = CurrentLocationService();
  late StreamSubscription<LocationData> currentLocationStream;

  Future<bool> startService(BuildContext context) async {
    print('startService******* ${currentLocationService.serviceEnabled}');
    if(!currentLocationService.serviceEnabled) {
      return await currentLocationService.startService(context);
    }else {
      return true;
    }


  }

  closeService() => currentLocationService.dispose();

  updateUserLocation(LocationData? currentLocation){
    if(currentLocation != null){
        locations.add(currentLocation);
      this.currentLocation = currentLocation;
      emit(CurrentLocationState(currentLocation));
    }
  }

}
