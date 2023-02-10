import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:id_driver/logic/booking/bloc/booking_bloc.dart';
import 'package:id_driver/logic/jobs/bloc/jobs_bloc.dart';
import 'package:id_driver/logic/login/bloc/login_bloc.dart';
import 'package:id_driver/logic/monthly_driver_request/bloc/monthly_driver_request_bloc.dart';
import 'package:id_driver/logic/network_connection/bloc/network_connection_bloc.dart';
import 'package:id_driver/logic/news/bloc/news_bloc.dart';
import 'package:id_driver/logic/places_autocomplete/bloc/places_autocomplete_bloc.dart';
import 'package:id_driver/logic/rate_card/bloc/rate_card_bloc.dart';
import 'package:id_driver/logic/registration/bloc/registration_bloc.dart';
import 'package:id_driver/logic/wallet/wallet_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/constants/strings.dart';
import 'core/themes/app_theme.dart';
import 'data/repositories/AuthRepository.dart';
import 'logic/debug/app_bloc_observer.dart';
import 'ui/router/app_router.dart';

void main() async {
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //   systemNavigationBarColor: kPrimaryColor, // navigation bar color
  //   statusBarColor: kPrimaryColor, // status bar color
  // ));

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  Bloc.observer = AppBlocObserver();
  runApp(MultiRepositoryProvider(
    providers: [
      RepositoryProvider<AuthRepository>(create: (context) => AuthRepository()),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BookingBloc(
              authRepository: RepositoryProvider.of<AuthRepository>(context)),
        ),
        BlocProvider(
          create: (context) => PlacesAutocompleteBloc(
              authRepository: RepositoryProvider.of<AuthRepository>(context)),
        ),
        BlocProvider(
          create: (context) => RegistrationBloc(
              authenticationRepository:
                  RepositoryProvider.of<AuthRepository>(context)),
        ),
        BlocProvider(
          create: (context) => MonthlyDriverRequestBloc(
              authenticationRepository:
                  RepositoryProvider.of<AuthRepository>(context)),
        ),
        BlocProvider(
          create: (context) => WalletBloc(
              authRepository: RepositoryProvider.of<AuthRepository>(context)),
        ),
        BlocProvider(
          create: (context) => NewsBloc(
              authRepository: RepositoryProvider.of<AuthRepository>(context)),
        ),
        BlocProvider(
          create: (context) => RateCardBloc(
              authRepository: RepositoryProvider.of<AuthRepository>(context)),
        ),
        BlocProvider(
          create: (context) => JobsBloc(
              authRepository: RepositoryProvider.of<AuthRepository>(context)),
        ),
        BlocProvider(
          create: (context) => LoginBloc(
              authenticationRepository:
                  RepositoryProvider.of<AuthRepository>(context)),
        ),
        // BlocProvider(
        //   create: (context) => NetworkConnectionBloc(),
        // ),
      ],
      child: App(),
    ),
  ));
}

class App extends StatelessWidget {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Future<void> _getSessionData() async {
    //   final SharedPreferences prefs = await _prefs;
    //   bool? isLogin=prefs.getBool("isLoggedIn");
    //   String? userDetails=prefs.getString("UserSession");
    //
    //
    //   if(isLogin!){
    //     Map<String, dynamic> user = jsonDecode(userDetails!);
    //
    //     UserModel userModel=UserModel.fromJson(user);
    //
    //
    //     Navigator.of(context).pushNamed(AppRouter.dashboard);
    //
    //
    //   }
    // }
    //
    // _getSessionData();

    // initializeDateFormatting("en", "");

    return MaterialApp(
      title: Strings.appTitle,
      theme: AppTheme.theme(),
      darkTheme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRouter.splash,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
