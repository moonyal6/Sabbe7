import 'package:flutter/material.dart';
import 'package:language_builder/language_builder.dart';
import '../../../data/controllers/counters_controller.dart';
import '../../../shared/constants/style_constants/images_constants.dart';
import '../../../shared/constants/style_constants/text_style_constants.dart';
import '../../../shared/constants/text_constants/arabic_text_constants.dart';
import '../../components/counter_page/sabbeh_button.dart';


class CounterPage extends StatelessWidget {
  CounterPage({required this.counterKey});

  final String counterKey;



  int count = 0;
  @override
  Widget build(BuildContext context) {
    int? controllerCount = CountersController.get(context)
        .sessionCounters[counterKey];
    print('Counter Page build called');

    final bool isDefaultCounter = CountersController.get(context, listen: false)
        .countersMap[counterKey]['default'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Container(
        child: SabbehButton(() {
          print('count before: ${count}');
          count = count + 1;
          print('count after: ${count}');
          CountersController.get(context, listen: false).incrementSessionMap(
              counterKey);
            CountersController.get(context, listen: false).increment(context,
                counterKey: counterKey, isDefault: isDefaultCounter);
            print('controllerCount: ${controllerCount}');

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
                      Text( isDefaultCounter
                          ? ar['@reports']['@local_report']['@counters'][counterKey]
                          : CountersController.get(context).countersMap[counterKey]['name'],
                        style: kCounterName,
                      ),
                      Text(LanguageBuilder.getCurrentLang() == 'العربية'
                          || !isDefaultCounter ? ''
                          :CountersController.get(context).countersMap[counterKey]['name'],
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            letterSpacing: 1.5
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                  Text('${controllerCount ?? 0}',
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
}
