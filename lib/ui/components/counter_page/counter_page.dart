// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sabbeh_clone/ui/components/counter_page/sabbeh_button.dart';
// import 'package:sabbeh_clone/ui/cubit/counters_cubits/counters_cubit.dart';
//
// import '../../../shared/constants/style_constants/images_constants.dart';
// import '../../../shared/constants/style_constants/text_style_constants.dart';
//
// class CounterPage extends StatelessWidget {
//   CounterPage({required this.counterCubit, required this.pageText});
//
//   final counterCubit;
//   final Map<String, dynamic> pageText;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: SabbehButton(() {
//         counterCubit.addCount(context);
//       },
//         child: Container(
//           height: double.infinity,
//           width: double.infinity,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   //TODO: add text that appears evrey 100 count and disappears with the count
//                   SizedBox(height: 100),
//                   Column(
//                     children: [
//                       const Text('سبحان الله',
//                         style: kCounterName,
//                       ),
//                       Text(pageText['counter_1'],
//                         style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             fontSize: 18,
//                             letterSpacing: 1.5
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                     ],
//                   ),
//                   BlocBuilder<counterCubit, int>(
//                       builder: (context, count) => Text('$count',
//                         style: const TextStyle(
//                           // fontFamily: 'GE_SS_Two_Bold',
//                           fontSize: 50,
//                           color: Colors.white,
//                         ),
//                       )
//                   ),
//                 ],
//               ),
//               Image.asset(kSabbehButtonImage,
//                 scale: 3.5,
//                 color: Colors.white,
//               ),
//               SizedBox(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
