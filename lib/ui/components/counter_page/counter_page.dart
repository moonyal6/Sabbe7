import 'package:flutter/material.dart';
import 'package:language_builder/language_builder.dart';
import '../../cubit/counters_cubits/counters_provider.dart';
import '../../../shared/constants/style_constants/images_constants.dart';
import '../../../shared/constants/style_constants/text_style_constants.dart';
import '../../../shared/constants/text_constants/arabic_text_constants.dart';
import '../../components/counter_page/sabbeh_button.dart';


class CounterPage extends StatelessWidget {
  CounterPage({required this.counterKey});

  final String counterKey;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> _pageText = LanguageBuilder.texts!['@counters'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Container(
        child: SabbehButton(() {
          CountersProvider.get(context, listen: false)
              .increment(context, counterKey: counterKey);
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
                      Text(ar['@reports']['@local_report']['@counters'][counterKey],
                        style: kCounterName,
                      ),
                      Text(CountersProvider.get(context).countersMap[counterKey]['name'],
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            letterSpacing: 1.5
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                  Text(CountersProvider.get(context).countersMap[counterKey]['count'].toString(),
                    style: const TextStyle(
                      fontSize: 50,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Image.asset(kSabbehButtonImage,
                scale: 3.5,
                color: Colors.white,
              ),
              SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
//TODO: add an animation function.
}
