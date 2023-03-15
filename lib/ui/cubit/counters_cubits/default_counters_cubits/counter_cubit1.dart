import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../counters_cubit.dart';
import '../counter_mixin.dart';

const _cntName = 'counter_1';
class CounterCubit1 extends CountersCubit with CounterMixin {
  CounterCubit1(): super(0);

  static CounterCubit1 get(context) => BlocProvider.of(context);

  Future<void> initState(BuildContext context) async{
    int initCnt = await readLocalCount(context, _cntName);
    emit(state + initCnt);
  }

  void addCount(BuildContext context) {
    emit(state + 1);
    increment(context,
        count: state,
        counterKey: _cntName
    );
  }

  void resetCount(BuildContext context){
    emit(state - state);
    reset(context, _cntName);
  }
}