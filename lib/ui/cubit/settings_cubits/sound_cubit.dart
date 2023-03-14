import 'package:bloc/bloc.dart';


class SoundCubit extends Cubit<bool>{
  SoundCubit(): super(true);

  @override
  bool toggleSound(){
    bool value = !state;
    emit(value);
    return value;
  }
}
