import 'package:flutter/material.dart';
import '../../../data/controllers/counters_controller.dart';
import '../../../shared/constants/style_constants/images_constants.dart';
import '../../../shared/constants/style_constants/text_style_constants.dart';
import '../../../shared/constants/text_constants/arabic_text_constants.dart';
import '../../components/counter_page/sabbeh_button.dart';


class CounterPage extends StatelessWidget {
  CounterPage({required this.counterKey});

  final String counterKey;


  @override
  Widget build(BuildContext context) {
    final bool isDefaultCounter = CountersController.get(context, listen: false)
        .countersMap[counterKey]['default'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Container(
        child: SabbehButton(() {
          CountersController.get(context, listen: false)
              .increment(context, counterKey: counterKey, isDefault: isDefaultCounter);
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
                      Text( isDefaultCounter
                          ? CountersController.get(context).countersMap[counterKey]['name']
                          : '',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            letterSpacing: 1.5
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                  Text(CountersController.get(context).countersMap[counterKey]['count'].toString(),
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
