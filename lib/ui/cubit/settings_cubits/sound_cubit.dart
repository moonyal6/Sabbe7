import 'package:bloc/bloc.dart';
import 'package:sabbeh_clone/shared/helpers/cache_helper.dart';

import '../../../shared/constants/cache_constants.dart';


class SoundCubit extends Cubit<bool>{
  SoundCubit(): super(CacheHelper.getBool(key: CacheKeys.sound));

  @override
  void toggleSound(){
    bool value = !state;
    emit(value);
    CacheHelper.saveData(key: CacheKeys.sound, value: value);
  }
}
