import 'dart:async';

import 'package:Ageo_solutions/components/localization.dart';
import 'package:Ageo_solutions/core/api_client.dart';
import 'package:Ageo_solutions/models/warn_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';

class WarningScreen extends StatefulWidget {
  const WarningScreen({super.key});

  @override
  State<WarningScreen> createState() => _WarningScreenState();
}

/// [AnimationController]s can be created with `vsync: this` because of
/// [TickerProviderStateMixin].
class _WarningScreenState extends State<WarningScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  late List<warnData> _items = [];
  bool _customTileExpanded = false;
  final apiClient = ApiClient();

  // fetch api
  Future<List<warnData>> fetchWarnData() async {
    try {
      final response = await apiClient.getDeviceData();

      if (response['success']) {
        List<warnData> data = (response['data'] as List)
            .map((data) => warnData.fromJson(data))
            .toList();

        setState(() {
          _items = data;
        });
        return data;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }

  // show alert
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            'AlertDialog Title',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'This is a demo alert dialog.',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                Text(
                  'Would you like to approve of this message?',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Ok',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchWarnData();
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
          LocalData.title1.getString(context),
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
          tableTab(),
        ],
      ),
    );
  }

  Widget overViewTab() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          height: MediaQuery.sizeOf(context).height * 0.3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: InteractiveViewer(
            boundaryMargin: const EdgeInsets.all(20),
            minScale: 0.5,
            maxScale: 2,
            child: Image.asset(
              "assets/images/dalat.PNG",
              fit: BoxFit.contain,
            ),
          ),
        ),

        // List info
        Expanded(
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
                    padding:
                        const EdgeInsets.only(top: 10, left: 15, bottom: 18),
                    child: Text(
                      'Warning system',
                      style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showMyDialog();
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 29,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(233, 249, 251, 1),
                        border: Border.all(
                          color: const Color.fromRGBO(285, 235, 245, 1),
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: const Offset(0, 1),
                            blurRadius: 8,
                          )
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 15),
                            height: 35,
                            width: 35,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromRGBO(21, 101, 192, 1),
                            ),
                            child: const Align(
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            child: TextButton(
                              onPressed: () {
                                _showMyDialog();
                              },
                              child: const Text(
                                'Warning level 1',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color.fromRGBO(1, 59, 111, 1),
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showMyDialog();
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 29, vertical: 15),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(255, 241, 219, 1),
                        border: Border.all(
                          color: const Color.fromRGBO(255, 217, 157, 1),
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: const Offset(0, 1),
                            blurRadius: 8,
                          )
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 15),
                            height: 35,
                            width: 35,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromRGBO(248, 199, 88, 1),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromRGBO(248, 199, 88, 1),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            child: TextButton(
                              onPressed: () {
                                _showMyDialog();
                              },
                              child: const Text(
                                'Warning level 2',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color.fromRGBO(111, 64, 36, 1),
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showMyDialog();
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 29,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(253, 237, 237, 1),
                        border: Border.all(
                          color: const Color.fromRGBO(247, 187, 186, 1),
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: const Offset(0, 1),
                            blurRadius: 8,
                          )
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 15),
                            height: 35,
                            width: 35,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromRGBO(238, 101, 102, 1),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromRGBO(238, 102, 102, 1),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: TextButton(
                              onPressed: () {
                                _showMyDialog();
                              },
                              child: const Text(
                                'Warning level 3',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color.fromRGBO(66, 0, 0, 1),
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget tableTab() {
    var title = TextStyle(
      fontSize: 15,
      color: Theme.of(context).textTheme.bodyLarge?.color,
    );
    var subTitle = const TextStyle(
      fontSize: 12,
      color: Colors.grey,
    );
    if (_items.isEmpty) {
      return const Center(
        child: Text(
          'Không có dữ liệu',
          style: TextStyle(color: Colors.black),
        ),
      );
    }

    return ListView.builder(
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        return Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 8,
          ),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
            ),
            child: ExpansionTile(
              leading: Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: item.status == 1 ? Colors.green : Colors.red,
                ),
              ),
              title: item.title == 'Water Level 01'
                  ? Text(
                      LocalData.waterLevel1.getString(context),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    )
                  : item.title == 'Water Level 02'
                      ? Text(
                          LocalData.waterLevel2.getString(context),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        )
                      : item.title == 'GNSS 01'
                          ? Text(
                              LocalData.gnss1.getString(context),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color,
                              ),
                            )
                          : item.title == 'GNSS 02'
                              ? Text(
                                  LocalData.gnss2.getString(context),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color,
                                  ),
                                )
                              : item.title == 'GNSS 03'
                                  ? Text(
                                      LocalData.gnss3.getString(context),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.color,
                                      ),
                                    )
                                  : item.title == 'Camera 01'
                                      ? Text(
                                          'Camera 01',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.color,
                                          ),
                                        )
                                      : item.title == 'Camera 02'
                                          ? Text(
                                              'Camera 02',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge
                                                    ?.color,
                                              ),
                                            )
                                          : item.title == 'Camera 03'
                                              ? Text(
                                                  'Camera 03',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.color,
                                                  ),
                                                )
                                              : item.title == 'Camera 04'
                                                  ? Text(
                                                      'Camera 04',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15,
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge
                                                            ?.color,
                                                      ),
                                                    )
                                                  : item.title == 'Camera 05'
                                                      ? Text(
                                                          'Camera 05',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15,
                                                            color: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyLarge
                                                                ?.color,
                                                          ),
                                                        )
                                                      : item.title ==
                                                              'Warning sensor 01'
                                                          ? Text(
                                                              LocalData.warn1
                                                                  .getString(
                                                                      context),
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 15,
                                                                color: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyLarge
                                                                    ?.color,
                                                              ),
                                                            )
                                                          : item.title ==
                                                                  'Warning sensor 02'
                                                              ? Text(
                                                                  LocalData
                                                                      .warn2
                                                                      .getString(
                                                                          context),
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        15,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodyLarge
                                                                        ?.color,
                                                                  ),
                                                                )
                                                              : item.title ==
                                                                      'Rain gauge'
                                                                  ? Text(
                                                                      LocalData
                                                                          .mua
                                                                          .getString(
                                                                              context),
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            15,
                                                                        color: Theme.of(context)
                                                                            .textTheme
                                                                            .bodyLarge
                                                                            ?.color,
                                                                      ),
                                                                    )
                                                                  : item.title ==
                                                                          'Piezometer 01'
                                                                      ? Text(
                                                                          LocalData
                                                                              .piez1
                                                                              .getString(context),
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize:
                                                                                15,
                                                                            color:
                                                                                Theme.of(context).textTheme.bodyLarge?.color,
                                                                          ),
                                                                        )
                                                                      : item.title ==
                                                                              'Piezometer 02'
                                                                          ? Text(
                                                                              LocalData.piez2.getString(context),
                                                                              style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 15,
                                                                                color: Theme.of(context).textTheme.bodyLarge?.color,
                                                                              ),
                                                                            )
                                                                          : item.title == 'Piezometer 03'
                                                                              ? Text(
                                                                                  LocalData.piez3.getString(context),
                                                                                  style: TextStyle(
                                                                                    fontWeight: FontWeight.bold,
                                                                                    fontSize: 15,
                                                                                    color: Theme.of(context).textTheme.bodyLarge?.color,
                                                                                  ),
                                                                                )
                                                                              : item.title == 'Inclinometer 01'
                                                                                  ? Text(
                                                                                      LocalData.inclino1.getString(context),
                                                                                      style: TextStyle(
                                                                                        fontWeight: FontWeight.bold,
                                                                                        fontSize: 15,
                                                                                        color: Theme.of(context).textTheme.bodyLarge?.color,
                                                                                      ),
                                                                                    )
                                                                                  : item.title == 'Inclinometer 02'
                                                                                      ? Text(
                                                                                          LocalData.inclino2.getString(context),
                                                                                          style: TextStyle(
                                                                                            fontWeight: FontWeight.bold,
                                                                                            fontSize: 15,
                                                                                            color: Theme.of(context).textTheme.bodyLarge?.color,
                                                                                          ),
                                                                                        )
                                                                                      : Text(
                                                                                          LocalData.inclino3.getString(context),
                                                                                          style: TextStyle(
                                                                                            fontWeight: FontWeight.bold,
                                                                                            fontSize: 15,
                                                                                            color: Theme.of(context).textTheme.bodyLarge?.color,
                                                                                          ),
                                                                                        ),
              subtitle: Text(
                DateFormat('dd/MM/yyyy – HH:mm').format(item.time),
                style: title,
              ),
              trailing: Icon(
                _customTileExpanded
                    ? Icons.arrow_drop_up
                    : Icons.arrow_drop_down,
                color: Theme.of(context).iconTheme.color,
              ),
              onExpansionChanged: (bool expanded) {
                setState(() {
                  _customTileExpanded = expanded;
                });
              },
              children: [
                ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocalData.code.getString(context),
                        style: subTitle,
                      ),
                      Text(
                        item.code,
                        style: title,
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocalData.lat.getString(context),
                        style: subTitle,
                      ),
                      Text(
                        '${item.lat}',
                        style: title,
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocalData.lng.getString(context),
                        style: subTitle,
                      ),
                      Text('${item.lng}', style: title),
                    ],
                  ),
                ),
                ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'V1',
                        style: subTitle,
                      ),
                      Text(
                        '${item.v1}',
                        style: title,
                      ),
                    ],
                  ),
                ),
                ListTile(
                    title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(
                        'V2',
                        style: subTitle,
                      ),
                      Text(
                        '${item.v2}',
                        style: title,
                      ),
                    ])),
                ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'V3',
                        style: subTitle,
                      ),
                      Text(
                        '${item.v3}',
                        style: title,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
