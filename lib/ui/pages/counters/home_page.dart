import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../components/counter_pages_drawer.dart';
import 'counter_page1.dart';
import 'counter_page2.dart';
import 'counter_page3.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static String route = 'home page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = PageController(viewportFraction: 0.8, keepPage: true);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawerEnableOpenDragGesture: false,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.black,
        ),
        drawer: CounterPageDrawer(),
        backgroundColor: Colors.black,
        body:
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                PageView(
                  // padEnds: false,
                  controller: controller,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: CounterPage1(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: CounterPage2(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: CounterPage3(),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 75,
                  child: SmoothPageIndicator(
                      controller: controller,
                      count: 3,
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
    );
  }
}
