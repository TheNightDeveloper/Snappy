import 'package:user_app/global/global.dart';
import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {
  final String msg;

  ProgressDialog(this.msg);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: kthirdColor,
      child: Container(
        decoration: BoxDecoration(
            color: ksecondColor, borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CircularProgressIndicator(
                color: kfourthColor,
                // valueColor: AlwaysStoppedAnimation<Color>(Colors.yellowAccent),
              ),
              Text(
                msg,
                style: kmediumTextStyle.copyWith(color: kfourthColor),
              )
            ],
          ),
        ),
      ),
    );
  }
}
