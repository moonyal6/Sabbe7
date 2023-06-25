import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sabbeh_clone/data/controllers/settings_controller.dart';
import 'package:sabbeh_clone/shared/constants/constants.dart';
import 'package:sabbeh_clone/shared/helpers/background_helper.dart';
import 'package:sabbeh_clone/shared/helpers/notice_helper.dart';
import 'package:flutter/services.dart';
import 'package:sabbeh_clone/ui/cubit/firebase_cubits/auth/auth_cubit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../data/controllers/notification_controller.dart';
import '../../data/controllers/settings_controller.dart';
import '../../shared/helpers/cache_helper.dart';
import '../components/counter_page/counter_page.dart';
import '../components/counter_page/counter_pages_drawer.dart';
import '../../data/controllers/counters_controller.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static String route = 'home page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = PageController();
  String currentCounterKey = cnt1_key;
  int currentIndex = 0;

  @override
  void initState() {

    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    AuthCubit.get(context).getUserData(uId: AuthCubit.get(context).currentUser?.id);

    // NotificationController.startListeningNotificationEvents();
    // rescheduleNotifications();



  }

  void rescheduleNotifications()async{
    final bool isEnabled = SettingsController.get(context).notifications;
    // await NotificationController.cancelNotifications();
    // isEnabled ? NotificationController.scheduleNewNotification() : null;
  }




  List<Widget> getCounterPages(){
    print('looping');
    List<CounterPage> countersPagesList = [];
    for (String counter in CountersController.get(context).countersMap.keys){
      countersPagesList.add(
        CounterPage(
          counterKey: counter,
        )
      );
      // CountersController.get(context, listen: false).sessionCounters[counter] = 0;
    }
    print('done looping');
    countersPagesList.forEach((element) {print(element.counterKey);});
    return countersPagesList;
  }

  void onDataChange(int index) {
    setState(() => currentCounterKey = 'counter_${index + 1}');
    currentIndex = index;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> countersPagesList = getCounterPages();

    if(!countersPagesList.contains(currentCounterKey)){
      currentCounterKey = cnt1_key;
      currentIndex = 0;
    }

    return
        DefaultTabController(
          length: countersPagesList.length,
          child: Scaffold(
            drawerEnableOpenDragGesture: false,
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: Colors.black,
              actions: [
                Container(
                  padding: EdgeInsets.only(right: 20, top: 10),
                  child: Text(CountersController.get(context)
                      .countersMap[currentCounterKey]['count'].toString(),
                    style: TextStyle(
                      fontSize: 24
                    ),
                  ),
                )
              ],
            ),
            drawer: CounterPageDrawer(),
            backgroundColor: Colors.black,
            body: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                PageView(
                  // padEnds: false,
                  controller: controller,
                  children: countersPagesList,
                  onPageChanged: (index){
                    onDataChange(index);
                  },
                ),
                Positioned(
                  bottom: 75,
                  child: SmoothPageIndicator(
                    controller: controller,
                    count: countersPagesList.length,
                    effect: WormEffect(
                      activeDotColor: Colors.white,
                      dotHeight: 10,
                      dotWidth: 10,
                    ),
                  ),
                ),
                Positioned(
                  child: IconButton(
                    icon: Icon(
                      Icons.replay,
                      size: 32,
                    ),
                    onPressed: () {
                      CountersController.get(context, listen: false).resetSessionMap(currentCounterKey);
                    },
                  ),
                  right: 20,
                  bottom: 10,
                ),
              ],
            ),
          ),
    );
  }
}

