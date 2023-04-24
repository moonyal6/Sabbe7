import 'package:flutter/material.dart';
import 'package:sabbeh_clone/ui/cubit/firebase_cubits/auth/auth_cubit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../components/counter_page/counter_page.dart';
import '../components/counter_page/counter_pages_drawer.dart';
import '../cubit/counters_cubits/counters_provider.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static String route = 'home page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final innerController = PageController(viewportFraction: 0.8, keepPage: true);
  final controller = PageController(viewportFraction: 0.8, keepPage: true);

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    AuthCubit.get(context).getUserData(uId: AuthCubit.get(context).currentUser?.id);
    // print(getCounterPages());
  }

  List<Widget> getCounterPages(){
    List<Widget> countersPagesList = [];
    for (String counter in CountersProvider.get(context).countersMap.keys){
      countersPagesList.add(
        CounterPage(
          counterKey: counter,
        )
      );
    }
    return countersPagesList;
  }


  List<Widget> getCounterPagesADD(){
    List<Widget> countersPagesList = [];
    for (String counter in CountersProvider.get(context).countersMap.keys){
      countersPagesList.add(
          CounterPage(
            counterKey: counter,
          )
      );
    }
    return countersPagesList;
  }


  @override
  Widget build(BuildContext context) {
    return
      // PageView(
      // controller: controller,
      // children: [
        // Center(
        //   child: ElevatedButton(
        //     child: Text('Add Counter'),
        //     onPressed: (){},
        //   ),
        // ),
        DefaultTabController(
          length: getCounterPages().length,
          child: Scaffold(
            drawerEnableOpenDragGesture: false,
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: Colors.black,
            ),
            drawer: CounterPageDrawer(),
            backgroundColor: Colors.black,
            body: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                PageView(
                  // padEnds: false,
                  controller: innerController,
                  children: getCounterPages(),
                ),
                Positioned(
                  bottom: 75,
                  child: SmoothPageIndicator(
                    controller: innerController,

                    count: getCounterPages().length,
                    effect: WormEffect(
                      activeDotColor: Colors.white,
                      dotHeight: 10,
                      dotWidth: 10,
                    ),
                  ),
                )
              ],
            ),
          ),
        // ),

    //   ],
    );
  }
}
