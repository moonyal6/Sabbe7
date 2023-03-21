import 'package:bloc/bloc.dart';
import 'package:sabbeh_clone/shared/helpers/cache_helper.dart';


class SoundCubit extends Cubit<bool>{
  SoundCubit(): super(CacheHelper.getBool(key: 'sound'));

  @override
  void toggleSound(){
    bool value = !state;
    emit(value);
    CacheHelper.saveData(key: 'sound', value: value);
  }
}
