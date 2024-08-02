import 'package:Ageo_solutions/components/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

class ControlPanelScreen extends StatefulWidget {
  const ControlPanelScreen({super.key});

  @override
  State<ControlPanelScreen> createState() => _ControlPanelScreenState();
}

/// [AnimationController]s can be created with `vsync: this` because of
/// [TickerProviderStateMixin].
class _ControlPanelScreenState extends State<ControlPanelScreen>
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
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: AppBar(
        title: Text(
          LocalData.title1.getString(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: "Overview",
            ),
            Tab(
              text: "News",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Overview Tab
          overViewTab(),
          // News Tab
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
        color: Colors.green,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.25),
            offset: const Offset(0, 1),
            blurRadius: 4,
          ),
        ],
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
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 15, bottom: 18),
                child: Text(
                  LocalData.infoTitle.getString(context),
                  style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontWeight: FontWeight.w600),
                ),
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
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              '03/05/2017',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromRGBO(111, 64, 36, 1),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            LocalData.infoDetails1.getString(context),
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
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 10, top: 6),
                            child: Text(
                              '06/2020',
                              style: TextStyle(
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
                              LocalData.infoDetails2.getString(context),
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
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              '12/11/2021',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromRGBO(111, 64, 36, 1),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            LocalData.infoDetails3.getString(context),
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
                margin: const EdgeInsets.only(left: 29, top: 18, right: 29),
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(230, 250, 232, 1),
                    border: Border.all(
                      color: const Color.fromRGBO(154, 232, 162, 1),
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
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 10, top: 6),
                            child: Text(
                              '23/11/2021',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromRGBO(26, 79, 27, 1),
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
                              LocalData.infoDetails4.getString(context),
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Color.fromRGBO(91, 149, 95, 1),
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
                color: const Color.fromRGBO(154, 232, 162, 1),
                height: 16,
                width: 2,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 29),
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(230, 250, 232, 1),
                    border: Border.all(
                      color: const Color.fromRGBO(154, 232, 162, 1),
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
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 10, top: 6),
                            child: Text(
                              '23/11/2021',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromRGBO(26, 79, 27, 1),
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
                              LocalData.infoDetails5.getString(context),
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Color.fromRGBO(91, 149, 95, 1),
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
                margin: const EdgeInsets.only(left: 29, top: 18, right: 29),
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(233, 249, 251, 1),
                    border: Border.all(
                      color: const Color.fromRGBO(185, 235, 245, 1),
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
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 10, top: 6),
                            child: Text(
                              '04/03/2022',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromRGBO(1, 59, 111, 1),
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
                              LocalData.infoDetails6.getString(context),
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Color.fromRGBO(69, 136, 167, 1),
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
                color: const Color.fromRGBO(185, 235, 245, 1),
                height: 16,
                width: 2,
              ),
              Container(
                margin: const EdgeInsets.only(left: 29, right: 29),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(233, 249, 251, 1),
                  border: Border.all(
                    color: const Color.fromRGBO(185, 235, 245, 1),
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
                    Column(
                      children: [
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 10, top: 6),
                            child: Text(
                              '17/07/2022',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromRGBO(1, 59, 111, 1),
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
                              LocalData.infoDetails7.getString(context),
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Color.fromRGBO(69, 136, 167, 1),
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
                color: const Color.fromRGBO(185, 235, 245, 1),
                height: 16,
                width: 2,
              ),
              Container(
                margin: const EdgeInsets.only(left: 29, right: 29),
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(233, 249, 251, 1),
                    border: Border.all(
                      color: const Color.fromRGBO(185, 235, 245, 1),
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
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 10, top: 6),
                            child: Text(
                              '29/08/2022',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromRGBO(1, 59, 111, 1),
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
                              LocalData.infoDetails8.getString(context),
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Color.fromRGBO(69, 136, 167, 1),
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
                color: const Color.fromRGBO(185, 235, 245, 1),
                height: 16,
                width: 2,
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 29,
                ),
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(233, 249, 251, 1),
                    border: Border.all(
                      color: const Color.fromRGBO(185, 235, 245, 1),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 10),
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              '14/01/2023',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromRGBO(1, 59, 111, 1),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            LocalData.infoDetails9.getString(context),
                            style: const TextStyle(
                                fontSize: 12,
                                color: Color.fromRGBO(69, 136, 167, 1),
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 29, vertical: 18),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(253, 237, 237, 1),
                  border: Border.all(
                    color: const Color.fromRGBO(247, 187, 186, 1),
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
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              '29/06/2023 02:00 AM',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromRGBO(66, 0, 0, 1),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            LocalData.infoDetails10.getString(context),
                            style: const TextStyle(
                                fontSize: 12,
                                color: Color.fromRGBO(97, 45, 43, 1),
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
