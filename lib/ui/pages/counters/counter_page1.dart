import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sabbeh_clone/main.dart';
import 'package:sabbeh_clone/shared/constants/constants.dart';

import '../../../shared/constants/style_constants/images_constants.dart';
import '../../../shared/constants/style_constants/text_style_constants.dart';
import '../../../shared/constants/text_constants/arabic_text_constants.dart';
import '../../components/counter_page/sabbeh_button.dart';
import '../../cubit/counters_cubits/default_counters_cubits/counter_cubit1.dart';


class CounterPage1 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> _pageText = appLang['@counters'];
    return Container(
      child: SabbehButton(() {
        context.read<CounterCubit1>().addCount(context);
      },
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  //TODO: add text that appears evrey 100 count and disappears with the count
                  SizedBox(height: 100),
                  Column(
                    children: [
                      Text(ar['@reports']['@local_report']['@counters'][cnt1_key],
                        style: kCounterName,
                      ),
                      Text(_pageText[cnt1_key],
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            letterSpacing: 1.5
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                  BlocBuilder<CounterCubit1, int>(
                    builder: (context, count) => Text('$count',
                      style: const TextStyle(
                        // fontFamily: 'GE_SS_Two_Bold',
                        fontSize: 50,
                        color: Colors.white,
                      ),
                    )
                  ),
                ],
              ),
              Image.asset(kSabbehButtonImage,
                scale: 3.5,
                color: Colors.white,
              ),
              // SabbehButton(() {
              //   context.read<CounterCubit1>().addCount(context);
              // }),

              // TabPageSelector(
              //   controller: ,
              // )
              SizedBox(),
              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child: Container(
              // padding: EdgeInsets.fromLTRB(10, 8, 10, 0),
              // height: 40,
              // //color: Colors.blueGrey.shade900,
              // child: Row(
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [],
              // ),
              //   ),
              // ),
            ],

          ),
        ),
      ),
    );
  }
  //TODO: add an animation function.
}
