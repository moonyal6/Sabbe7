import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:language_builder/language_builder.dart';
import 'package:sabbeh_clone/ui/components/app_pages_components/header/page_header.dart';

import '../../../main.dart';
import '../../../shared/constants/constants.dart';
import '../../../shared/constants/style_constants/text_style_constants.dart';
import '../../components/app_pages_components/card/page_card.dart';
import '../../cubit/firebase_cubits/firestore/firestore_cubit.dart';



class GlobalReportScreen extends StatefulWidget {
  static const String route = 'global report';

  @override
  State<GlobalReportScreen> createState() => _GlobalReportScreenState();
}

class _GlobalReportScreenState extends State<GlobalReportScreen> {

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> _pageText = LanguageBuilder.texts!['@reports']['@local_report'];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PageHeader(title: LanguageBuilder.texts!['@drawer']['global_report']),
              Center(
                child: Column(

                  children: [
                    const SizedBox(),
                    // Text(_pageText['@drawer']['global_report'],
                    //   style: TextStyle(
                    //       fontSize: 35,
                    //       fontWeight: FontWeight.w300
                    //   ),
                    // ),
                    StreamBuilder(
                      stream: context.read<FirestoreCubit>().globalCounterStream(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Something went wrong');
                          }

                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Text("Loading");
                          }
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
                                children: [
                                  Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        // crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(_pageText['@counters'][cnt1_key],
                                            style: kReport,
                                          ),
                                          Text(_pageText['@counters'][cnt2_key],
                                            style: kReport,
                                          ),
                                          Text(_pageText['@counters'][cnt3_key],
                                            style: kReport,
                                          ),
                                          Text(_pageText['@counters'][cnt4_key],
                                            style: kReport,
                                          ),
                                          Text(_pageText['@counters'][cnt5_key],
                                            style: kReport,
                                          ),
                                          Text(_pageText['@counters'][cnt6_key],
                                            style: kReport,
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            data[cnt1_key].toString(),
                                            style: kReport,
                                          ),
                                          Text(
                                            data[cnt2_key].toString(),
                                            style: kReport,
                                          ),
                                          Text(
                                            data[cnt3_key].toString(),
                                            style: kReport,
                                          ),
                                          Text(
                                            data[cnt4_key].toString(),
                                            style: kReport,
                                          ),
                                          Text(
                                            data[cnt5_key].toString(),
                                            style: kReport,
                                          ),
                                          Text(
                                            data[cnt6_key].toString(),
                                            style: kReport,
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          );
                        }
                    ),

                    // Container(
                    //   padding: const EdgeInsets.all(15),
                    //   margin: const EdgeInsets.symmetric(horizontal: 40),
                    //   decoration: BoxDecoration(
                    //       border: Border.all(
                    //           width: 2,
                    //           color: Colors.grey.shade500
                    //       )
                    //   ),
                    //   child: Row(
                    //     // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //
                    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //     children: [
                    //       Column(
                    //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //         crossAxisAlignment: CrossAxisAlignment.end,
                    //         children: const [
                    //           Text('سبحان الله',
                    //             style: kReport,
                    //           ),
                    //           Text('الحمد لله',
                    //             style: kReport,
                    //           ),
                    //           Text('لا اله الا الله',
                    //             style: kReport,
                    //           ),
                    //         ],
                    //       ),
                    //       Column(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           Text('$cnt1',
                    //             style: kReport,
                    //           ),
                    //           Text('$cnt2',
                    //             style: kReport,
                    //           ),
                    //           Text('$cnt3',
                    //             style: kReport,
                    //           ),
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
              SizedBox(),
              // SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
