part of 'google_map_cubit.dart';

@immutable
abstract class GoogleMapState {}

class GoogleMapInitial extends GoogleMapState {}

class GoogleMapLoadingState extends GoogleMapState {}

class GoogleMapSuccessState extends GoogleMapState {
  final APIResultModel? test;

  GoogleMapSuccessState(this.test);
}


class GoogleMapErrorState extends GoogleMapState {
  final String message;

  GoogleMapErrorState(this.message);
}

class CurrentLocationState extends GoogleMapState {
  final LocationData? data;

  CurrentLocationState(this.data);
}

