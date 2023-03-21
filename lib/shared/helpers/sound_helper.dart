import 'package:audioplayers/audioplayers.dart';
import 'counter_methods.dart';

final player = AudioPlayer();

playSound(methType type) async{
  //todo fix sound issue
  if(type == methType.heavy) {
    await player.setSource(AssetSource('sounds/pop2.wav'));
    await player.resume();
  };
  if(type == methType.light) {
    await player.setSource(AssetSource('sounds/pop1.wav'));
    await player.resume();
  };
}