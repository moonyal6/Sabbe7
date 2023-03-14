import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../main.dart';
import '../../cubit/firebase_cubits/firestore/firestore_cubit.dart';
import '../../providers/lang_provider.dart';



class GlobalReportScreen extends StatefulWidget {
  static const String route = 'global report';

  @override
  State<GlobalReportScreen> createState() => _GlobalReportScreenState();
}

class _GlobalReportScreenState extends State<GlobalReportScreen> {
  final _docRef = FirebaseFirestore.instance.collection("global_counter").doc("total_count");

  // Map? cnt;
  int? cnt0;
  int? cnt1;
  int? cnt2;
  int? cnt3;

  getCountersStream() {
    _docRef.snapshots().listen((docSnapshot) {
      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data()!;

        // You can then retrieve the value from the Map like this:

        // cnt0 = data['ttl_cnt'];
        // cnt1 = data['ttl_cnt1'];
        // cnt2 = data['ttl_cnt2'];
        // cnt3 = data['ttl_cnt3'];
        // print('cnt0: $cnt0');
        // print('cnt1: $cnt1');
        // print('cnt2: $cnt2');
        // print('cnt3: $cnt3');
        setState((){});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> _pageText = appLang;

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
            Text(_pageText['@drawer']['global_report'],
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w300
              ),
            ),
            StreamBuilder(
              stream: context.read<FirestoreCubit>().globalCounterStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading");
                  }
                  var count = snapshot.data['total_counts'];
                  print('Count: $count');
                  return Text('${count}',
                    style: const TextStyle(
                      fontSize: 70,
                      // fontFamily: 'GE_SS_Two_Bold',
                    ),
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
    );
  }
}
