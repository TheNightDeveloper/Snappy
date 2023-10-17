import 'package:flutter/material.dart';
import 'package:user_app/assistant/request_adress.dart';
import 'package:user_app/global/global.dart';
import 'package:user_app/models/prediction.dart';
import 'package:user_app/widgets/location_Prediction.dart';

class SearchLocationScreen extends StatefulWidget {
  @override
  State<SearchLocationScreen> createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  List<PredictionLocation> locationList = [];
  void findPlaceAutoComplete(String input) async {
    String url =
        "https://api.locationiq.com/v1/autocomplete?key=pk.0684764f956449283ad2e19725fb9d1c&q=${input}&accept-language=fa&countrycodes=IR&bounded=1&viewbox=59.364349,36.122030,59.842255,36.459544";
    if (input.length > 1) {
      var respons = await RequestAddress.receiveRequest(url);
      if (respons == "خطا در دریافت اطلاعات") {
        return;
      }

      locationList = (respons as List)
          .map((jsonData) => PredictionLocation.fromJson(jsonData))
          .toList();
      // print(respons);
      setState(() {
        locationList = locationList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: ksecondColor),
        backgroundColor: kmainColor,
        title: Text(
          'جستجوی مقصد',
          style: kmediumTextStyle.copyWith(color: ksecondColor, fontSize: 22),
        ),
        centerTitle: true,
      ),
      backgroundColor: kmainColor,
      body: Column(
        children: [
          Container(
              height: 120,
              decoration: const BoxDecoration(color: ksecondColor, boxShadow: [
                BoxShadow(
                    color: kthirdColor,
                    spreadRadius: 3,
                    blurRadius: 10,
                    offset: Offset(1, 1))
              ]),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                            child: TextField(
                          onChanged: (value) {
                            findPlaceAutoComplete(value);
                          },
                          decoration: const InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: kfourthColor)),
                              hintText: 'مقصد خودرا وارد نمایید',
                              hintTextDirection: TextDirection.rtl),
                          keyboardType: TextInputType.streetAddress,
                          textAlign: TextAlign.right,
                        )),
                        const SizedBox(
                          width: 20,
                        ),
                        const Icon(
                          Icons.adjust_rounded,
                          color: kfourthColor,
                        ),
                        // TextFieldMaker(
                        //   nametextEditingController:
                        //       destinationTextEditingController,
                        //   labelText: '',
                        //   hintText: 'مقصد خود را وارد نمایید',
                        //   textInputType: TextInputType.streetAddress,
                        // )
                        // TextField(
                        //   controller: destinationTextEditingController,

                        // )
                      ],
                    ),
                  ],
                ),
              )),
          const SizedBox(
            height: 10,
          ),
          locationList.length > 1
              ? Expanded(
                  child: ListView.separated(
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return LocationPrediction(
                          predictionLocation: locationList[index],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(
                            height: 1,
                            color: kfourthColor,
                            thickness: 1,
                          ),
                      itemCount: locationList.length))
              : Container()
        ],
      ),
    ));
  }
}
