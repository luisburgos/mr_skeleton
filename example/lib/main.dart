import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mr_skeleton/mr_skeleton.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:resonant_ui/resonant_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const SkeletonPage(),
    );
  }
}

class SkeletonPage extends StatelessWidget {
  final bool isDebug;

  const SkeletonPage({
    Key? key,
    this.isDebug = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SkeletonDemoStateController(isDebug: isDebug));

    return Obx(() {
      final controller = SkeletonDemoStateController.to;
      final isLeftExpanded = controller.isLeftSideMenuExpanded();
      final isRightExpanded = controller.isRightSideMenuExpanded();

      /// TODO: Add validation that expanded left width can be provided as null
      final expandedLeftWidth = controller.expandedLeftWidth();
      final collapsedLeftWidth = controller.collapsedLeftWidth();
      final expandedRightWidth = controller.expandedRightWidth();

      final isDesktop = controller.isDesktop();

      return MRSkeleton(
        isLeftExpanded: isLeftExpanded,
        isRightExpanded: isRightExpanded,
        expandedLeftWidth: expandedLeftWidth,
        collapsedLeftWidth: collapsedLeftWidth,
        expandedRightWidth: expandedRightWidth,
        onDesktopBreakpointChanged: (isDesktop) {
          controller.isDesktop(isDesktop);
        },
        left: _LeftWidget(
          isCollapsed: !isLeftExpanded,
        ),
        top: const TopBar(
          children: [
            _CircularLetter(
              letter: '1',
              color: Colors.purple,
            ),
            _CircularLetter(
              letter: '2',
              color: Colors.orange,
            ),
            Spacer(),
            _CircularLetter(
              letter: '3',
              color: Colors.yellow,
            ),
          ],
        ),
        right: const _RightWidget(),
        body: _SkeletonDemoInteractionBox(
          isDesktop: isDesktop,
        ),
        mobileBuilder: (child) {
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: child,
              ),
            ),
            appBar: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              title: const Text(
                'App Bar',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              leading: const _CircularLetter(
                letter: 'W',
                color: Colors.pink,
              ),
              backgroundColor: Colors.transparent,
              actions: const [
                _CircularLetter(
                  letter: '1',
                  color: Colors.purple,
                  padding: EdgeInsets.all(8),
                ),
                _CircularLetter(
                  letter: '2',
                  color: Colors.orange,
                  padding: EdgeInsets.all(8),
                ),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.call),
                  label: 'Calls',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.camera),
                  label: 'Camera',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat),
                  label: 'Chats',
                ),
              ],
            ),
          );
        },
      );
    });
  }
}

/// TODO: Change controllers when width is Mobile.
class _SkeletonDemoInteractionBox extends StatelessWidget {
  final bool isDesktop;

  const _SkeletonDemoInteractionBox({Key? key, required this.isDesktop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var children = !isDesktop
        ? [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                  'You are on a non-desktop version, expand your screen size or change to a web browser'),
            ),
          ]
        : [
            Obx(() {
              return SwitchListTile(
                title: const Text('Left expanded'),
                value: SkeletonDemoStateController.to.isLeftSideMenuExpanded(),
                onChanged: (newValue) {
                  SkeletonDemoStateController.to
                      .isLeftSideMenuExpanded(newValue);
                },
              );
            }),
            const Divider(),
            Obx(() {
              return SwitchListTile(
                title: const Text('Right expanded'),
                value: SkeletonDemoStateController.to.isRightSideMenuExpanded(),
                onChanged: (newValue) {
                  SkeletonDemoStateController.to
                      .isRightSideMenuExpanded(newValue);
                },
              );
            }),
            const Divider(),
            Obx(() {
              return Column(
                children: [
                  SwitchListTile(
                    title: const Text('Collapsed Left Width'),
                    value: SkeletonDemoStateController.to
                        .enableCollapsedLeftWidthEdition(),
                    onChanged: (newValue) {
                      SkeletonDemoStateController.to
                          .enableCollapsedLeftWidthEdition(newValue);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SfSlider(
                      value:
                          SkeletonDemoStateController.to.collapsedLeftWidth(),
                      min: 60,
                      max: 300,
                      interval: 40,
                      showTicks: true,
                      showLabels: true,
                      enableTooltip: true,
                      onChanged: SkeletonDemoStateController.to
                              .enableCollapsedLeftWidthEdition()
                          ? (newValue) {
                              SkeletonDemoStateController.to
                                  .collapsedLeftWidth(newValue);
                            }
                          : null,
                    ),
                  )
                ],
              );
            }),
            const Divider(),
            Obx(() {
              return Column(
                children: [
                  SwitchListTile(
                    title: const Text('Expanded Left Width'),
                    value: SkeletonDemoStateController.to
                        .enableExpandedLeftWidthEdition(),
                    onChanged: (newValue) {
                      SkeletonDemoStateController.to
                          .enableExpandedLeftWidthEdition(newValue);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SfSlider(
                      value: SkeletonDemoStateController.to.expandedLeftWidth(),
                      min: 60,
                      max: 300,
                      interval: 40,
                      showTicks: true,
                      showLabels: true,
                      enableTooltip: true,
                      onChanged: SkeletonDemoStateController.to
                              .enableExpandedLeftWidthEdition()
                          ? (newValue) {
                              SkeletonDemoStateController.to
                                  .expandedLeftWidth(newValue);
                            }
                          : null,
                    ),
                  )
                ],
              );
            }),
            const Divider(),
            Obx(() {
              return Column(
                children: [
                  SwitchListTile(
                    title: const Text('Expanded Right Width'),
                    value: SkeletonDemoStateController.to
                        .enableExpandedRightWidthEdition(),
                    onChanged: (newValue) {
                      SkeletonDemoStateController.to
                          .enableExpandedRightWidthEdition(newValue);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SfSlider(
                      value:
                          SkeletonDemoStateController.to.expandedRightWidth(),
                      min: 60,
                      max: 460,
                      interval: 40,
                      showTicks: true,
                      showLabels: true,
                      enableTooltip: true,
                      onChanged: SkeletonDemoStateController.to
                              .enableExpandedRightWidthEdition()
                          ? (newValue) {
                              SkeletonDemoStateController.to
                                  .expandedRightWidth(newValue);
                            }
                          : null,
                    ),
                  )
                ],
              );
            }),
          ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: ConstrainedRoundedCard(
            title: 'Skeleton demo',
            children: children,
          ),
        ),
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  final List<Widget> children;

  const TopBar({Key? key, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColorDebuggable(
      color: Colors.amber.shade300,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade300,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: children,
        ),
      ),
    );
  }
}

class _LeftWidget extends StatelessWidget {
  final bool isCollapsed;

  const _LeftWidget({
    Key? key,
    this.isCollapsed = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColorDebuggable.amber(
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: Colors.grey.shade300,
              width: 0.5,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: isCollapsed
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade300,
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _CircularLetter(
                    letter: 'L',
                    color: Colors.cyanAccent,
                  ),
                  if (!isCollapsed) const Spacer(),
                ],
              ),
            ),
            const _CircularLetter(
              letter: 'A',
              color: Colors.red,
            ),
            const _CircularLetter(
              letter: 'B',
              color: Colors.green,
            ),
            const Spacer(),
            const _CircularLetter(
              letter: 'C',
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}

class _RightWidget extends StatelessWidget {
  const _RightWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColorDebuggable.amber(
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: Colors.grey.shade300,
              width: 0.5,
            ),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade300,
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                children: const [
                  _CircularLetter(
                    letter: 'W',
                    color: Colors.pink,
                  ),
                  Spacer(),
                ],
              ),
            ),
            const Expanded(
              child: Center(
                child: Text('Right'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircularLetter extends StatelessWidget {
  final Function()? onTap;
  final EdgeInsets? padding;
  final String letter;
  final Color? color;

  const _CircularLetter({
    Key? key,
    this.onTap,
    this.padding,
    required this.letter,
    this.color = Colors.transparent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColorDebuggable.blue(
      child: Container(
        padding: padding ?? const EdgeInsets.all(6),
        child: ClipOval(
          child: Material(
            color: color, // Button color
            child: InkWell(
              splashColor: Colors.blueGrey.shade100, // Splash color
              onTap: onTap,
              child: SizedBox(
                width: 40,
                height: 40,
                child: Center(
                  child: Text(letter),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SkeletonDemoStateController extends GetxController {
  final bool isDebug;

  SkeletonDemoStateController({
    this.isDebug = false,
  });

  var isLayoutDebug = false.obs;
  var enableCollapsedLeftWidthEdition = false.obs;
  var enableExpandedLeftWidthEdition = false.obs;
  var enableExpandedRightWidthEdition = false.obs;

  static SkeletonDemoStateController get to => Get.find();

  @override
  void onReady() {
    isLayoutDebug(isDebug);
    super.onReady();
  }

  var currentIndex = 0.obs;

  var isLeftSideMenuExpanded = true.obs;
  var isRightSideMenuExpanded = true.obs;
  var isDesktop = true.obs;

  var collapsedLeftWidth = 60.0.obs;
  var expandedLeftWidth = 180.0.obs;
  var expandedRightWidth = 300.0.obs;

  Rx<Color> color = Colors.black.obs;

  String get currentRoute => Get.currentRoute;

  void toggleLeftSide() {
    print('toggleLeftSide');
    isLeftSideMenuExpanded.toggle();
  }

  void toggleRightSide() {
    print('toggleRightSide');
    isRightSideMenuExpanded.toggle();
  }

  void reset(Color? newColor) {
    color(newColor ?? Colors.black);
    isLeftSideMenuExpanded(true);
    isRightSideMenuExpanded(true);
  }

  void changePage(int? index) {
    currentIndex.value = index ?? 0;
    print('changePage: $index');

    /// TODO: Notify current index changed.
  }
}

class ColorDebuggable extends StatelessWidget {
  final Widget child;
  final Color color;

  const ColorDebuggable({
    Key? key,
    required this.color,
    required this.child,
  }) : super(key: key);

  ColorDebuggable.amber({
    Key? key,
    required this.child,
  })  : color = Colors.amber.shade200,
        super(key: key);

  ColorDebuggable.blue({
    Key? key,
    required this.child,
  })  : color = Colors.blue.shade200,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final controller = Get.find<SkeletonDemoStateController>();

      return Container(
        color: controller.isLayoutDebug() ? color : Colors.transparent,
        child: child,
      );
    });
  }
}
