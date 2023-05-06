// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sabbeh_clone/shared/helpers/sound_helper.dart';
import 'package:sabbeh_clone/shared/helpers/vibrate_helper.dart';

import '../../ui/cubit/settings_cubits/sound_cubit.dart';
import '../../ui/cubit/settings_cubits/vibration_cubit.dart';


enum methType {
  heavy,
  light,
}

void counterMethods(BuildContext context, int count){

  bool soundState = context.read<SoundCubit>().state;
  bool vibrateState = context.read<VibrationCubit>().state;

  if (count % 1000 == 0 && count > 0){
    if(soundState)playSound(methType.heavy);
    if(vibrateState)vibrate(methType.heavy);
  }
  else if (count % 100 == 0 && count > 0){
    if(soundState)playSound(methType.light);
    if(vibrateState)vibrate(methType.light);
  }

}
