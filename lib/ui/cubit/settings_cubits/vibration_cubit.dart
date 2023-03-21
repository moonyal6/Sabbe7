import 'package:bloc/bloc.dart';

import '../../../shared/helpers/cache_helper.dart';


class VibrationCubit extends Cubit<bool>{
  VibrationCubit(): super(CacheHelper.getBool(key: 'vibration'));

  @override
  void toggleVibration(){
    bool value = !state;
    emit(value);
    CacheHelper.saveData(key: 'vibration', value: value);
  }
}
