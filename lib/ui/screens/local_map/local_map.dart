import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:id_driver/core/constants/constants.dart';

class LocalMap extends StatefulWidget {
  const LocalMap({Key? key}) : super(key: key);

  @override
  State<LocalMap> createState() => _LocalMapState();
}

class _LocalMapState extends State<LocalMap> {
  final Set<Marker> _markers = {};
  final Set<Polygon> _polyline = {};

  late GoogleMapController controller;

  List<LatLng> latlngSegment1 = [
    LatLng(18.7088953770213, 73.69055755186461), //Somatane Phata
    LatLng(18.76067643393916, 73.86969809814575), //Chakan
    LatLng(18.671772405005605, 74.09730772852234), //Koregaon Bhima
    LatLng(18.495937722812435, 74.11364544847619),
    LatLng(18.351263314584564, 74.03249424619392), //Saswad
    LatLng(18.2416094989836, 73.90848946721373), //Kapurhol
    LatLng(18.56318961833014, 73.60520868454657), //Baramati
    LatLng(18.7088953770213, 73.69055755186461),
  ];
  // List<LatLng> latlngSegment2 = [
  //   LatLng(18.351263314584564, 74.03249424619392), //Saswad
  //   LatLng(18.2416094989836, 73.90848946721373), //Kapurhol
  //   LatLng(18.560585912539217, 73.60383539360961), //Baramati
  //   LatLng(18.7088953770213, 73.69055755186461),
  // ];
  static LatLng _lat1 = LatLng(18.035606, 73.562381);
  static LatLng _lat2 = LatLng(18.070632, 73.693071);
  static LatLng _lat3 = LatLng(17.970387, 73.693621);
  static LatLng _lat4 = LatLng(17.858433, 73.575691);
  static LatLng _lat5 = LatLng(17.948029, 73.472936);
  static LatLng _lat6 = LatLng(18.069280, 73.455844);
  LatLng _lastMapPosition = _lat1;

  @override
  void initState() {
    super.initState();
    //line segment 1
    // latlngSegment1.add(_lat1);
    // latlngSegment1.add(_lat2);
    // latlngSegment1.add(_lat3);
    // latlngSegment1.add(_lat4);

    //line segment 2
    // latlngSegment2.add(_lat4);
    // latlngSegment2.add(_lat5);
    // latlngSegment2.add(_lat6);
    // latlngSegment2.add(_lat1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text("Local Map"),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: GoogleMap(
        //that needs a list<Polyline>
        polygons: _polyline,
        markers: <Marker>{
          Marker(
            markerId: MarkerId(_lastMapPosition.toString()),
            position: latlngSegment1[0],
            infoWindow: const InfoWindow(
              title: 'Somatane Phata',
              // snippet: 'This is a snippet',
            ),
          ),
          Marker(
            markerId: MarkerId(_lastMapPosition.toString()),
            position: latlngSegment1[1],
            infoWindow: const InfoWindow(
              title: 'Chakan',
              // snippet: 'This is a snippet',
            ),
          ),
          Marker(
            markerId: MarkerId(_lastMapPosition.toString()),
            position: latlngSegment1[2],
            infoWindow: const InfoWindow(
              title: 'Koregaon Bhima',
              // snippet: 'This is a snippet',
            ),
          ),
          Marker(
            markerId: MarkerId(_lastMapPosition.toString()),
            position: latlngSegment1[3],
            infoWindow: const InfoWindow(
              title: 'Urali Kanchan',
              // snippet: 'This is a snippet',
            ),
          ),
          Marker(
            markerId: MarkerId(_lastMapPosition.toString()),
            position: latlngSegment1[4],
            infoWindow: const InfoWindow(
              title: 'Saswad',
              // snippet: 'This is a snippet',
            ),
          ),
          Marker(
            markerId: MarkerId(_lastMapPosition.toString()),
            position: latlngSegment1[5],
            infoWindow: const InfoWindow(
              title: 'Kapurhol',
              // snippet: 'This is a snippet',
            ),
          ),
          Marker(
            markerId: MarkerId(_lastMapPosition.toString()),
            position: latlngSegment1[6],
            infoWindow: const InfoWindow(
              title: 'Baramati',
              // snippet: 'This is a snippet',
            ),
          ),
          // Marker(
          //   markerId: MarkerId(_lastMapPosition.toString()),
          //   position: latlngSegment1[7],
          //   infoWindow: const InfoWindow(
          //     title: 'Somatane Phata',
          //     snippet: 'This is a snippet',
          //   ),
          // ),
        },
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(18.520430, 73.856743),
          zoom: 9.0,
        ),
        mapType: MapType.normal,
      ),
    );
  }

  void _onMapCreated(GoogleMapController controllerParam) {
    setState(() {
      controller = controllerParam;
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),
        //_lastMapPosition is any coordinate which should be your default
        //position when map opens up
        position: LatLng(18.520430, 73.856743),
        infoWindow: InfoWindow(
          title: 'Awesome Polyline tutorial',
          snippet: 'This is a snippet',
        ),
      ));

      // _markers.add();

      _polyline.add(Polygon(
        polygonId: PolygonId('line1'),
        visible: true,
        fillColor: Colors.grey.withOpacity(0.5),
        //latlng is List<LatLng>
        points: latlngSegment1,
        strokeWidth: 1,
      ));

      //different sections of polyline can have different colors
      // _polyline.add(Polyline(
      //   polylineId: PolylineId('line2'),
      //   visible: true,
      //   //latlng is List<LatLng>
      //   points: latlngSegment2,
      //   width: 2,
      //   color: Colors.red,
      // ));
    });
  }
}
