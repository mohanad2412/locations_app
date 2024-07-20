import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  var result = '';
  var result2 = '';
  var resul3 = '';
  var address = ''.obs;
  var secondAdd = ''.obs;
  var distance = 0.0;
  var distance2 = 0.0;
  var distanc3 = 0.0;
  var first = 0.0;
  var second = 0.0;
  final locText1 = TextEditingController();
  final locText2 = TextEditingController();
  final locText3 = TextEditingController();
  var locResult = ''.obs;
  var locResult2 = ''.obs;
  var locResult3 = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location App'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              getLocation();
              Obx(() {
                return Text('$result');
              });
            },
            child: Text('Show Location'),
          ),
          SizedBox(
            height: 20,
          ),
          Obx(() {
            return Text('$address');
          }),
          TextField(
            controller: locText1,
          ),
          TextField(
            controller: locText2,
          ),
          TextField(
            controller: locText3,
          ),
          ElevatedButton(
              onPressed: () async {
                final firstLoc =
                    await locationFromAddress('${locText1.text} cairo');
                distance = Geolocator.distanceBetween(
                    firstLoc[0].latitude, firstLoc[0].longitude, first, second);
                if (locText1.text.isNotEmpty) {
                  locResult.value = ('${distance / 1000} KM');
                }
                final secondLoc =
                    await locationFromAddress('${locText2.text} cairo');
                distance2 = Geolocator.distanceBetween(
                    secondLoc[0].latitude,
                    secondLoc[0].longitude,
                    firstLoc[0].latitude,
                    firstLoc[0].longitude);
                if (locText2.text.isNotEmpty) {
                  locResult2.value = ('${distance2 / 1000} KM');
                }

                final thirdLoc =
                    await locationFromAddress('${locText3.text} cairo');
                distance2 = Geolocator.distanceBetween(
                    secondLoc[0].latitude,
                    secondLoc[0].longitude,
                    thirdLoc[0].latitude,
                    thirdLoc[0].longitude);
                if (locText3.text.isNotEmpty) {
                  locResult3.value = ('${distance2 / 1000} KM');
                }
              },
              child: Text('show direction')),
          Obx(() {
            return Text('$locResult');
          }),
          Obx(() {
            return Text('$locResult2');
          }),
          Obx(() {
            return Text('$locResult3');
          }),
        ],
      ),
    );
  }

  Future<void> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('Error', 'Location services are disabled.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('Error', 'Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar('Error',
          'Location permissions are permanently denied, we cannot request permissions.');
      return;
    }

    final location = await Geolocator.getCurrentPosition();
    result = '${location.latitude} -- ${location.longitude}';
    final addresses =
        await placemarkFromCoordinates(location.latitude, location.longitude);
    address.value = '${addresses[0].locality} -- ${addresses[0].street}';

    first = location.latitude;
    second = location.longitude;

    final location1 = await Geolocator.getCurrentPosition();
    result2 = '${location1.latitude} -- ${location1.longitude}';
    final addresses1 =
        await placemarkFromCoordinates(location1.latitude, location1.longitude);
    address.value = '${addresses1[0].locality} -- ${addresses1[0].street}';

    final location2 = await Geolocator.getCurrentPosition();
    resul3 = '${location2.latitude} -- ${location2.longitude}';
    final addresses2 =
        await placemarkFromCoordinates(location1.latitude, location1.longitude);
    address.value = '${addresses2[0].locality} -- ${addresses2[0].street}';
  }
}
