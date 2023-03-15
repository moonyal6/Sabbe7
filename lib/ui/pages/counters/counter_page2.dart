import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sabbeh_clone/main.dart';


import '../../../shared/constants/style_constants/images_constants.dart';
import '../../../shared/constants/style_constants/text_style_constants.dart';
import '../../../shared/constants/text_constants/turkish_text_constants.dart';
import '../../components/counter_page/sabbeh_button.dart';
import '../../cubit/counters_cubits/default_counters_cubits/counter_cubit2.dart';


class CounterPage2 extends StatelessWidget {
  static String route = 'counter_2';

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> _pageText = appLang['@counters'];

    return SafeArea(
        child: Container(
          child: SabbehButton(() {
            context.read<CounterCubit2>().addCount(context);
          },
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
                        const Text('الحمد لله',
                          style: kCounterName,
                        ),
                        Text(_pageText['counter_2'],
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              letterSpacing: 1.5
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                    BlocBuilder<CounterCubit2, int>(
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
                // SabbehButton(() {                          ////Add Count
                //   context.read<CounterCubit2>().addCount(context);
                // }),
                SizedBox(width: MediaQuery.of(context).size.width),
                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child: Container(
                //     padding: EdgeInsets.fromLTRB(10, 8, 10, 0),
                //     height: 40,
                //     //color: Colors.blueGrey.shade900,
                //     child: Row(
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       children: [],
                //     ),
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
