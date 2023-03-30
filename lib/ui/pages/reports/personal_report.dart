import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:language_builder/language_builder.dart';
import 'package:provider/provider.dart';
import 'package:sabbeh_clone/shared/constants/constants.dart';

import '../../components/app_page/app_page.dart';
import '../../components/app_page/app_page_components/card/card_components/card_report_tile.dart';
import '../../components/app_page/app_page_components/card/page_card.dart';
import '../../components/app_page/app_page_components/header/page_header.dart';
import '../../cubit/counters_cubits/default_counters_cubits/counter_cubit1.dart';
import '../../cubit/counters_cubits/default_counters_cubits/counter_cubit2.dart';
import '../../cubit/counters_cubits/default_counters_cubits/counter_cubit3.dart';
import '../../cubit/counters_cubits/default_counters_cubits/counter_cubit4.dart';
import '../../cubit/counters_cubits/default_counters_cubits/counter_cubit5.dart';
import '../../cubit/counters_cubits/default_counters_cubits/counter_cubit6.dart';


class PersonalReportScreen extends StatelessWidget {
  static const String route = 'personal report';

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> _pageText = LanguageBuilder.texts!['@reports']['@local_report'];

    return AppPage(
      title: _pageText['local_report'],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PageCard(
            padding: EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 26
            ),
            children: [
              CardReportTile(
                counterText: _pageText['@counters'][cnt1_key],
                countText: context.read<CounterCubit1>().state.toString(),
              ),
              CardReportTile(
                counterText: _pageText['@counters'][cnt2_key],
                countText: context.read<CounterCubit2>().state.toString(),
              ),
              CardReportTile(
                counterText: _pageText['@counters'][cnt3_key],
                countText: context.read<CounterCubit3>().state.toString(),
              ),
              CardReportTile(
                counterText: _pageText['@counters'][cnt4_key],
                countText: context.read<CounterCubit4>().state.toString(),
              ),
              CardReportTile(
                counterText: _pageText['@counters'][cnt5_key],
                countText: context.read<CounterCubit5>().state.toString(),
              ),
              CardReportTile(
                counterText: _pageText['@counters'][cnt6_key],
                countText: context.read<CounterCubit6>().state.toString(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
