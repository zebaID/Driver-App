import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:id_driver/core/constants/constants.dart';
import 'package:id_driver/core/constants/size_config.dart';
import 'package:id_driver/core/global_widgets/custom_drawer.dart';
import 'package:id_driver/data/data_providers/data_provider.dart';
import 'package:id_driver/logic/login/bloc/login_bloc.dart';
import 'package:id_driver/logic/login/model/driver_details_model.dart';
import 'package:id_driver/logic/network_connection/bloc/network_connection_bloc.dart';
import 'package:id_driver/ui/router/app_router.dart';
import 'package:id_driver/ui/screens/home_screen/home_screen.dart';
import 'package:id_driver/ui/screens/job_portal/job_portal.dart';
import 'package:id_driver/ui/screens/my_bookings/my_bookings.dart';
import 'package:id_driver/ui/screens/rate_card/rate_card.dart';
import 'package:id_driver/ui/screens/trip_invites/trip_invites.dart';
import 'package:id_driver/ui/screens/terms/terms.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DashboardState();
  }
}

class _DashboardState extends State<Dashboard> {
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  String operationCity = "";

  static final List<Widget> _screens = <Widget>[
    const HomeScreen(),
    const TripInvites(),
    JobPortal()
  ];
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // getCustomerDetails();

    super.initState();
    // WidgetsBinding.instance.addObserver(this);

    // initConnectivity();
    // context.read<NetworkConnectionBloc>().add(CheckConnection());
  }

  void getCustomerDetails() async {
    final customerDetails = await DataProvider().getSessionData();
    final jsonCustomer = jsonDecode(customerDetails!);
    print("UserDetails $customerDetails");

    operationCity = jsonCustomer[0]['conUsers']['operationCity'];
  }

  @override
  void dispose() {
    // _connectivitySubscription.cancel();
    // WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   switch (state) {
  //     case AppLifecycleState.resumed:
  //       // onResumed();
  //       print("state Resumed");
  //       initState();
  //       break;
  //     case AppLifecycleState.inactive:
  //       // onPaused();
  //       print("Paused");
  //       break;
  //     case AppLifecycleState.paused:
  //       // onInactive();
  //       print("OnInactive");
  //       break;
  //     case AppLifecycleState.detached:
  //       // onDetached();
  //       print("detached");
  //       break;
  //   }
  // }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print('Couldn\'t check connectivity status error:' + e.details);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectivityResult = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    // context.read<NetworkConnectionBloc>().add(CheckConnection());
    context.read<LoginBloc>().add(GetDriverDetails());

    return WillPopScope(
      onWillPop: () async {
        if (_key.currentState!.isDrawerOpen) {
          Navigator.of(context).pop();
          return false;
        } else if (_selectedIndex == 1 || _selectedIndex == 2) {
          setState(() {
            _selectedIndex = 0;
          });
          return false;
        } else {
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Are you sure?'),
              content: const Text('Do you want to exit an App'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () => {
                    if (Platform.isAndroid)
                      {SystemNavigator.pop()}
                    else if (Platform.isIOS)
                      {exit(0)}
                  },
                  child: const Text('Yes'),
                ),
              ],
            ),
          );
          return false;
        }
      },
      child: Scaffold(
        key: _key,

        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        // floatingActionButton: _selectedIndex == 0
        //     ? FloatingActionButton.extended(
        //         onPressed: () {
        //           // Add your onPressed code here!
        //           Navigator.pushNamed(context, AppRouter.bookDriver);
        //         },
        //         label: const Text('Book Driver'),
        //         icon: const Icon(Icons.add),
        //         backgroundColor: kPrimaryColor,
        //       )
        //     : null,
        drawer: CustomDrawer(),
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu_rounded),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          iconTheme: const IconThemeData(color: kWhiteColor),
          title: Text(_selectedIndex == 1
              ? "Trip Invites"
              : _selectedIndex == 2
                  ? "Job Portal"
                  : "Home"),
          actions: [
            BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                print("Driver Details ${state.driverDetailsModel}");
                late DriverDetailsModel driverDetailsModel;
                if (state.driverDetailsModel.isNotEmpty) {
                  driverDetailsModel = DriverDetailsModel.fromJson(
                      jsonDecode(state.driverDetailsModel)[0]);

                  return Center(
                      child: Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 8.0, 18.0, 8.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 20,
                        ),
                        Text(
                          driverDetailsModel == null ||
                                  driverDetailsModel.conUsers == null
                              ? ""
                              : driverDetailsModel.conUsers!.operationCity!,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ));
                } else {
                  return Center(
                      child: Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 8.0, 18.0, 8.0),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 20,
                        ),
                        Text(
                          "Operational City \nnot found",
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.lightGreenAccent),
                        ),
                      ],
                    ),
                  ));
                }
              },
            )
          ],
          backgroundColor: kPrimaryColor,
        ),
        body: Center(
          child: _screens.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
                backgroundColor: Colors.white),
            // BottomNavigationBarItem(
            //     icon: Icon(Icons.home_repair_service_rounded),
            //     label: "Rate Card",
            //     backgroundColor: Colors.white),
            BottomNavigationBarItem(
                icon: Icon(Icons.fact_check_rounded),
                label: "Trip Invites",
                backgroundColor: Colors.white),
            BottomNavigationBarItem(
                icon: Icon(Icons.featured_play_list_rounded),
                label: "Job Portal",
                backgroundColor: Colors.white),
          ],
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          selectedItemColor: kPrimaryColor,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          iconSize: getProportionateScreenHeight(30),
          onTap: _onItemTapped,
          elevation: 5,
          unselectedLabelStyle: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => {
                  if (Platform.isAndroid)
                    {SystemNavigator.pop()}
                  else if (Platform.isIOS)
                    {exit(0)}
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }
}
