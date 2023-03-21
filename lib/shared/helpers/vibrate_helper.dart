import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'counter_methods.dart';


void vibrate(methType type) {
  if(type == methType.light)Vibrate.feedback(FeedbackType.heavy);
  if(type == methType.heavy)Vibrate.vibrate();
}

