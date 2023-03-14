import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'counter_methods.dart';


void vibrate(methType type) {
  if(type == methType.light)Vibrate.vibrate();
  if(type == methType.heavy)Vibrate.feedback(FeedbackType.heavy);
}

