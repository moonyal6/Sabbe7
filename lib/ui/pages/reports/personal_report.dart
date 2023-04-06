import 'package:flutter/material.dart';
import 'package:language_builder/language_builder.dart';
import 'package:sabbeh_clone/ui/cubit/counters_cubits/counters_provider.dart';

import '../../components/app_page/app_page.dart';
import '../../components/app_page/app_page_components/card/card_components/card_report_tile.dart';
import '../../components/app_page/app_page_components/card/page_card.dart';


class PersonalReportScreen extends StatelessWidget {
  static const String route = 'personal report';

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> _pageText = LanguageBuilder.texts!['@reports']['@local_report'];

    List<Widget> getCounters(){
      List<Widget> counterList = [];
      for(Map counter in CountersProvider.get(context, listen: false).countersMap.values){
        counterList.add(
            CardReportTile(
              counterText: counter['name'],
              countText: counter['count'].toString(),
            )
        );
      }
      return counterList;
    }

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
            children: getCounters(),
            // [
            //   CardReportTile(
            //     counterText: _pageText['@counters'][cnt1_key],
            //     countText: CountersProvider.get(context).cnt1['count'].toString(),
            //   ),
            //   CardReportTile(
            //     counterText: CountersProvider.get(context).cnt2['name'],
            //     countText: CountersProvider.get(context).cnt2['count'].toString(),
            //   ),
            //   CardReportTile(
            //     counterText: CountersProvider.get(context).cnt3['name'],
            //     countText: CountersProvider.get(context).cnt3['count'].toString(),
            //   ),
            //   // CardReportTile(
            //   //   counterText: _pageText['@counters'][cnt4_key],
            //   //   countText: context.read<CounterCubit4>().state.toString(),
            //   // ),
            //   // CardReportTile(
            //   //   counterText: _pageText['@counters'][cnt5_key],
            //   //   countText: context.read<CounterCubit5>().state.toString(),
            //   // ),
            //   // CardReportTile(
            //   //   counterText: _pageText['@counters'][cnt6_key],
            //   //   countText: context.read<CounterCubit6>().state.toString(),
            //   // ),
            // ],
          ),
        ],
      ),
    );
  }
}
