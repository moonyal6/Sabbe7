import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:language_builder/language_builder.dart';

import '../../../shared/constants/constants.dart';
import '../../components/app_page/app_page.dart';
import '../../components/app_page/app_page_components/card/card_components/card_report_tile.dart';
import '../../components/app_page/app_page_components/card/page_card.dart';
import '../../components/app_page/app_page_components/header/page_header.dart';
import '../../cubit/firebase_cubits/firestore_cubit.dart';



class GlobalReportScreen extends StatefulWidget {
  static const String route = 'global report';

  @override
  State<GlobalReportScreen> createState() => _GlobalReportScreenState();
}

class _GlobalReportScreenState extends State<GlobalReportScreen> {

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> _pageText = LanguageBuilder.texts!['@reports']['@local_report'];

    return AppPage(
      title: LanguageBuilder.texts!['@drawer']['global_report'],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder(
              stream: context.read<FirestoreCubit>().globalCounterStream(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');}
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Loading");}
                var data = snapshot.data;
                return Column(
                  children: [
                    Text('${data['total_counts']}',
                      style: const TextStyle(
                        fontSize: 70,
                        // fontFamily: 'GE_SS_Two_Bold',
                      ),
                    ),
                    SizedBox(height: 20),
                    PageCard(
                      padding: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 26
                      ),
                      children: [
                        CardReportTile(
                          counterText: _pageText['@counters'][cnt1_key],
                          countText: data[cnt1_key].toString(),
                        ),
                        CardReportTile(
                          counterText: _pageText['@counters'][cnt2_key],
                          countText: data[cnt2_key].toString(),
                        ),
                        CardReportTile(
                          counterText: _pageText['@counters'][cnt3_key],
                          countText: data[cnt3_key].toString(),
                        ),
                        CardReportTile(
                          counterText: _pageText['@counters'][cnt4_key],
                          countText: data[cnt4_key].toString(),
                        ),
                        CardReportTile(
                          counterText: _pageText['@counters'][cnt5_key],
                          countText: data[cnt5_key].toString(),
                        ),
                        CardReportTile(
                          counterText: _pageText['@counters'][cnt6_key],
                          countText: data[cnt6_key].toString(),
                        ),
                      ],
                    ),
                  ],
                );
              }
          ),
        ],
      ),
    );
  }
}
