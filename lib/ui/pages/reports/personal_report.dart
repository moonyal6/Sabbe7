import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../data/controllers/counters_controllers/counters_controller.dart';
import '../../../main.dart';
import '../../../shared/constants/style_constants/text_style_constants.dart';
import '../../cubit/counters_cubits/default_counters_cubits/counter_cubit1.dart';
import '../../cubit/counters_cubits/default_counters_cubits/counter_cubit2.dart';
import '../../cubit/counters_cubits/default_counters_cubits/counter_cubit3.dart';


class PersonalReportScreen extends StatelessWidget {
  static const String route = 'personal report';

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> _pageText = appLang['@reports']['@local_report'];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color(0xFF101010),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Colors.white,
                          width: 0.3
                      )
                  )
              ),
              child: Text(_pageText['local_report'],
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w300
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 2,
                      color: Colors.grey.shade500
                  )
              ),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(_pageText['@counters']['counter_1'],
                        style: kReport,
                      ),
                      Text(_pageText['@counters']['counter_2'],
                        style: kReport,
                      ),
                      Text(_pageText['@counters']['counter_3'],
                        style: kReport,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Text(
                      context.read<CounterCubit1>().state.toString(),
                      style: kReport,
                     ),
                     Text(
                       context.read<CounterCubit2>().state.toString(),
                       style: kReport,
                     ),
                     Text(
                       context.read<CounterCubit3>().state.toString(),
                       style: kReport,
                     ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(),
          ],
        ),
      ),
    );
  }
}

class ReportText extends StatelessWidget {
  ReportText({required this.text, this.provider});

  final String text;
  final provider;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text,
          style: kReport,
        ),
        Text('$provider',
          style: kReport,
        ),
      ],
    );
  }
}
