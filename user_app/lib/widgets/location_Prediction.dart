import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/global/global.dart';

import 'package:user_app/models/prediction.dart';
import 'package:user_app/models/user_data.dart';

class LocationPrediction extends StatelessWidget {
  LocationPrediction({this.predictionLocation});

  final PredictionLocation? predictionLocation;
  // String getLocationCordinate() {
  //
  // }
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: kthirdColor),
        onPressed: () {
          // print(predictionLocation!.lat!);
          // print(predictionLocation!.lon!);
          Provider.of<UserData>(context, listen: false).updateUserDestination(
              predictionLocation!.lat!, predictionLocation!.lon!);
          Navigator.pop(context,'Destination Applied');
        },
        child: Row(
          children: [
            Expanded(
                child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text(
                  predictionLocation!.displayName!,
                  style: kmediumTextStyle.copyWith(color: kfourthColor),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(
                  height: 7,
                ),
                Text(
                  predictionLocation!.displayAddrr!,
                  style: kmediumTextStyle.copyWith(
                      fontSize: 11, color: kfourthColor),
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.right,
                ),
                const SizedBox(
                  height: 7,
                ),
              ],
            )),
            const SizedBox(
              width: 5,
            ),
            const Icon(
              Icons.add_location,
              color: ksecondColor,
            )
          ],
        ));
  }
}
