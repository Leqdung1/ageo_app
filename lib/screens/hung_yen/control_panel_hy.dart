import 'package:Ageo_solutions/components/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localization/flutter_localization.dart';

class ControlPanelHyScreen extends StatefulWidget {
  const ControlPanelHyScreen({super.key});

  @override
  State<ControlPanelHyScreen> createState() => _ControlPanelHyScreenState();
}

/// [AnimationController]s can be created with `vsync: this` because of
/// [TickerProviderStateMixin].
class _ControlPanelHyScreenState extends State<ControlPanelHyScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          LocalData.title2.getString(context),
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontSize: 20,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
            ),
            child: TabBar(
              controller: _tabController,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.normal,
              ),
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: const Color.fromRGBO(0, 65, 130, 1),
              labelColor: Theme.of(context).textTheme.bodyLarge?.color,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(
                  text: LocalData.overView.getString(context),
                ),
                Tab(
                  text: LocalData.news.getString(context),
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          overViewTab(),
          newsTab(),
        ],
      ),
    );
  }

  Widget overViewTab() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: MediaQuery.sizeOf(context).height * 0.5,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.25),
            offset: const Offset(0, 1),
            blurRadius: 4,
          ),
        ],
      ),
      child: InteractiveViewer(
        boundaryMargin: const EdgeInsets.all(20),
        minScale: 0.25,
        maxScale: 3,
        child: Column(
          children: [
            Expanded(
              child: Image.asset(
                "assets/images/Group 33409 (1).png",
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Image.asset(
                "assets/images/hy1.jpg",
              ),
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.1,
            ),
          ],
        ),
      ),
    );
  }

  Widget newsTab() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8), topRight: Radius.circular(8)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.25),
              offset: const Offset(0, 1),
              blurRadius: 4,
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Padding(
              //   padding: const EdgeInsets.only(top: 10, left: 15, bottom: 18),
              //   child: Text(
              //     LocalData.infoTitle.getString(context),
              //     style: TextStyle(
              //         fontSize: 15,
              //         color: Theme.of(context).textTheme.bodyLarge?.color,
              //         fontWeight: FontWeight.w600),
              //   ),
              // ),
              const SizedBox(
                height: 25,
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 29,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 241, 219, 1),
                  border: Border.all(
                    color: const Color.fromRGBO(255, 217, 157, 1),
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      offset: const Offset(0, 1),
                      blurRadius: 8,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 10),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              LocalData.nameProject.getString(context),
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Color.fromRGBO(111, 64, 36, 1),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            LocalData.nameProject1.getString(context),
                            style: const TextStyle(
                                fontSize: 12,
                                color: Color.fromRGBO(111, 64, 36, 1),
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: MediaQuery.sizeOf(context).width * 0.15),
                color: const Color.fromRGBO(255, 217, 157, 1),
                height: 16,
                width: 2,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 29),
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 241, 219, 1),
                    border: Border.all(
                      color: const Color.fromRGBO(255, 217, 157, 1),
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        offset: const Offset(0, 1),
                        blurRadius: 8,
                      )
                    ]),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, top: 6),
                            child: Text(
                              LocalData.namePackage.getString(context),
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Color.fromRGBO(111, 64, 36, 1),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, bottom: 6),
                            child: Text(
                              LocalData.namePackage1.getString(context),
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Color.fromRGBO(111, 64, 36, 1),
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: MediaQuery.sizeOf(context).width * 0.15),
                color: const Color.fromRGBO(255, 217, 157, 1),
                height: 16,
                width: 2,
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 29,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 241, 219, 1),
                  border: Border.all(
                    color: const Color.fromRGBO(255, 217, 157, 1),
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      offset: const Offset(0, 1),
                      blurRadius: 8,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 10),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              LocalData.location.getString(context),
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Color.fromRGBO(111, 64, 36, 1),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            LocalData.location1.getString(context),
                            style: const TextStyle(
                                fontSize: 12,
                                color: Color.fromRGBO(111, 64, 36, 1),
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: MediaQuery.sizeOf(context).width * 0.15),
                color: const Color.fromRGBO(255, 217, 157, 1),
                height: 16,
                width: 2,
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 29,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 241, 219, 1),
                  border: Border.all(
                    color: const Color.fromRGBO(255, 217, 157, 1),
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      offset: const Offset(0, 1),
                      blurRadius: 8,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 10),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              LocalData.content.getString(context),
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Color.fromRGBO(111, 64, 36, 1),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            LocalData.content1.getString(context),
                            style: const TextStyle(
                                fontSize: 12,
                                color: Color.fromRGBO(111, 64, 36, 1),
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 120,
              )
            ],
          ),
        ),
      ),
    );
  }
}
