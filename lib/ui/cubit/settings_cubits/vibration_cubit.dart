import 'package:bloc/bloc.dart';

import '../../../shared/constants/cache_constants.dart';
import '../../../shared/helpers/cache_helper.dart';


class VibrationCubit extends Cubit<bool>{
  VibrationCubit(): super(CacheHelper.getBool(key: CacheKeys.vibration));

  @override
  void toggleVibration(){
    bool value = !state;
    emit(value);
    CacheHelper.saveData(key: CacheKeys.vibration, value: value);
  }
}
