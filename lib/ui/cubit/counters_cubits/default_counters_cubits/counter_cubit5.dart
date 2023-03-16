import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sabbeh_clone/shared/constants/constants.dart';
import '../../../../shared/helpers/cache_helper.dart';
import '../counters_cubit.dart';
import '../counter_mixin.dart';

const _cntKey = cnt5_key;
class CounterCubit5 extends CountersCubit with CounterMixin{
  CounterCubit5(): super(CacheHelper.getInteger(key: _cntKey));

  static CounterCubit5 get(context) => BlocProvider.of(context);

  void addCount(BuildContext context) {
    emit(state + 1);
    increment(context,
        count: state,
        counterKey: _cntKey
    );
  }
}