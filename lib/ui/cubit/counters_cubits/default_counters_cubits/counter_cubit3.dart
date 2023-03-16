import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sabbeh_clone/shared/constants/constants.dart';
import '../../../../shared/helpers/cache_helper.dart';
import '../counters_cubit.dart';
import '../counter_mixin.dart';

const _cntKey = cnt3_key;
class CounterCubit3 extends CountersCubit with CounterMixin{
  CounterCubit3(): super(CacheHelper.getInteger(key: _cntKey));

  static CounterCubit3 get(context) => BlocProvider.of(context);

  void addCount(BuildContext context) {
    emit(state + 100);
    increment(context,
        count: state,
        counterKey: _cntKey
    );
  }
}