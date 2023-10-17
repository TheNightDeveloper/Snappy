import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import 'package:user_app/global/global.dart';
import 'package:user_app/models/user_data.dart';

// ignore: must_be_immutable
class SelectDriver extends StatefulWidget {
  SelectDriver({super.key, required this.amount, this.tripRef});
  final int amount;
  DatabaseReference? tripRef;

  @override
  State<SelectDriver> createState() => _SelectDriverState();
}

class _SelectDriverState extends State<SelectDriver> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: ksecondColor,
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            setState(() {});
            widget.tripRef!.remove();

            Navigator.pop(context);
          },
        ),
        backgroundColor: kmainColor,
        title: const Text(
          'راننده خود را انتخاب کنید',
          style: kmediumTextStyle,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemBuilder: (context, index) => InkWell(
                onTap: () {
                  
                    Provider.of<UserData>(context,listen: false).getSelectedDriverID(
                        Provider.of<UserData>(context,listen: false).driverInfo[index]["id"]);
                  
                  Navigator.pop(context, true);
                },
                child: Card(
                  color: kmainColor,
                  elevation: 3,
                  shadowColor: kmainColor,
                  margin:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  child: SizedBox(
                    height: 60,
                    child: ListTile(
                      leading: Image.asset('img/car1.png'),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            Provider.of<UserData>(context).driverInfo[index]
                                ['name'],
                            style:
                                kmediumTextStyle.copyWith(color: ksecondColor),
                          ),
                          Text(
                            Provider.of<UserData>(context).driverInfo[index]
                                    ['Car Datails']['Car Model'] +
                                " " +
                                Provider.of<UserData>(context).driverInfo[index]
                                    ['Car Datails']['Car Color'] +
                                " " +
                                Provider.of<UserData>(context).driverInfo[index]
                                    ['Car Datails']['Car Number'],
                            style:
                                kmediumTextStyle.copyWith(color: ksecondColor),
                          )
                        ],
                      ),
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SmoothStarRating(
                            rating: 3,
                            starCount: 5,
                            color: Color.fromARGB(202, 255, 255, 0),
                            borderColor: const Color.fromARGB(130, 255, 255, 0),
                            size: 20,
                          ),
                          Text(
                            'هزینه سفر: ${widget.amount} تومان ',
                            style:
                                kmediumTextStyle.copyWith(color: ksecondColor),
                            textDirection: TextDirection.rtl,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          itemCount: Provider.of<UserData>(context, listen: false)
              .onlineDrivers
              .length),
    ));
  }
}
