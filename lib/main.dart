import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabbar_scroll/enum_tab.dart';
import 'package:tabbar_scroll/no_glow_behavior.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.blue),
          home: child,
        );
      },
      child: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;
  late ScrollController scrollController;

  void changeTabIndex(int index) {
    tabController.animateTo(index);
  }

  double _getItHeight(int index) {
    return EnumTab.values[index].height;
  }

  double _getItSumHeight(int index) {

    double sum = 0.0;
    for (int i = 0; i < index; i++) {
      sum += EnumTab.values[i].height;
    }
    return sum;
  }

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    tabController = TabController(
      length: EnumTab.values.length,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final firstPoint = _getItHeight(0) / 3;
    final secondPoint = _getItHeight(0) + _getItHeight(1) / 5;
    final thirdPoint = _getItHeight(0) + _getItHeight(1) + _getItHeight(2) / 3;
    final fourthPoint = _getItHeight(0) + _getItHeight(1) + _getItHeight(2) + _getItHeight(3) / 3;

    List<Widget> loadTabs() {
      return List.generate(
        EnumTab.values.length,
        (index) => Tab(
          child: Text(
            EnumTab.values[index].ko,
            style: TextStyle(
              fontSize: 15.h,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    final tiles = List.generate(
      EnumTab.values.length,
      (index) {
        return Container(
          height: EnumTab.values[index].height,
          color: Colors.accents[index],
        );
      },
    );

    return NotificationListener<ScrollNotification>(
      onNotification: (onScroll) {
        final pixels = onScroll.metrics.pixels;

        if (pixels < firstPoint && tabController.index != 0) {
          changeTabIndex(0);
        } else if (pixels >= firstPoint && pixels < secondPoint && tabController.index != 1) {
          changeTabIndex(1);
        } else if (pixels >= secondPoint && pixels < thirdPoint && tabController.index != 2) {
          changeTabIndex(2);
        } else if (pixels >= thirdPoint && pixels < fourthPoint && tabController.index != 3) {
          changeTabIndex(3);
        } else if ((pixels >= fourthPoint || onScroll.metrics.atEdge) && tabController.index != 4) {
          changeTabIndex(4);
        }

        return false;
      },
      child: ScrollConfiguration(
        behavior: NoGlowBehavior(),
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            bottom: TabBar(
              controller: tabController,
              onTap: (index) {
                scrollController.animateTo(
                  _getItSumHeight(index),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.linear,
                );
              },
              tabs: loadTabs(),
            ),
          ),
          body: ListView(controller: scrollController, children: tiles),
        ),
      ),
    );
  }
}
