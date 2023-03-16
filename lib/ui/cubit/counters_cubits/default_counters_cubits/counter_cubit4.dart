import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sabbeh_clone/shared/constants/constants.dart';
import '../../../../shared/helpers/cache_helper.dart';
import '../counters_cubit.dart';
import '../counter_mixin.dart';

const _cntKey = cnt4_key;
class CounterCubit4 extends CountersCubit with CounterMixin{
  CounterCubit4(): super(CacheHelper.getInteger(key: _cntKey));

  static CounterCubit4 get(context) => BlocProvider.of(context);

  void addCount(BuildContext context) {
    emit(state + 1);
    increment(context,
        count: state,
        counterKey: _cntKey
    );
  }
}