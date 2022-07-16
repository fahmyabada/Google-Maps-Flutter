import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter_example/data/api/Dio_Helper.dart';
import 'package:google_maps_flutter_example/presentation/GoogleMapScreen.dart';
import 'package:google_maps_flutter_example/presentation/cubit/google_map_cubit.dart';
import 'package:google_maps_flutter_example/presentation/di/injection_container.dart';

void main() async {
  // for example ensure Initialized shared perefence
  WidgetsFlutterBinding.ensureInitialized();

  //for dependency injection
  await init();

  await DioHelper.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocProvider(
          create: (context) => GoogleMapCubit(),
          child: const GoogleMapScreen(),
        ));
  }
}
