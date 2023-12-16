import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';


class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  void getGeocoding() async {
    try {
      List<Location> locations = await locationFromAddress('東京都中央区銀座七丁目4番12号 銀座メディカルビル 2F',localeIdentifier: 'ja_JP');
      for (Location location in locations) {
        final List<Placemark> placeMarks = await placemarkFromCoordinates(
            location.latitude, location.longitude, localeIdentifier: 'ja_JP');
        for(Placemark placeMark in placeMarks) {
          print(placeMark);
        }
        print(location);
      }
    } on NoResultFoundException {
      print("No result found for address: ");
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(child:GestureDetector(
      onTapDown: (details) => getGeocoding(),
      onTapCancel: () => print('close page'),
      child: const Tooltip(
        message: 'onHover',
        child: Icon(
          Icons.circle,
          size: 80,
          color: Colors.white,
        ),
      ),
    ),);
  }
}
