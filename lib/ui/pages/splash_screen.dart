
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/counters_cubits/counter_cubit1.dart';
import '../cubit/counters_cubits/counter_cubit2.dart';
import '../cubit/counters_cubits/counter_cubit3.dart';
import 'counters/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const String route = 'splash';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    print('init state');
    _initialSetup(context);
  }

  void _initialSetup(BuildContext context) async{
    await timer();

  }

  Future<void> timer() async{
    final stopwatch = Stopwatch();
    stopwatch.start();
    await _loadData();
    stopwatch.stop();

    int time = stopwatch.elapsedMilliseconds;
    print('timer: $time');
    if (time < 2000){
      Timer(Duration(milliseconds: 2000 - time),
              () => Navigator.pushNamed(context, HomePage.route),
      );
    }
    else {
      Navigator.pushNamed(context, HomePage.route);
    }

    // true
    // Timer(Duration(seconds: 3),
    //         ()=>_loadData()
    // );
  }

  Future<void> _loadData() async{
    // context.read<AuthCubit>().initState();
    context.read<CounterCubit1>().initState(context);
    context.read<CounterCubit2>().initState(context);
    context.read<CounterCubit3>().initState(context);

    // await context.read<SharedPrefCubit>().loadCounter();
    // print(context.read<SharedPrefCubit>().counter);
  }


  @override
  Widget build(BuildContext context) {
    return Center(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              color: Colors.black,
              child: Image.asset(
                  'assets/images/sabbeh_splash_logo.png',
                  scale: 5,
              ),
            ),
          ),
        ),
    );
  }
}
