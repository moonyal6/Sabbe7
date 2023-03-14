import 'package:bloc/bloc.dart';


class VibrationCubit extends Cubit<bool>{
  VibrationCubit(): super(true);

  @override
  void toggleVibration(){
    emit(!state);
  }
}
