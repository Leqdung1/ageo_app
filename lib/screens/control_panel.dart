import 'package:flutter/material.dart';

class ControlPanelScreen extends StatefulWidget {
  const ControlPanelScreen({super.key});

  @override
  State<ControlPanelScreen> createState() => _ControlPanelScreenState();
}

class _ControlPanelScreenState extends State<ControlPanelScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      body: Column(
        children: [
          // TODO: add api
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            height: size.height * 0.3,
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
                        'Informations',
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
                      child: const Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 6, horizontal: 10),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    '03/05/2017',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Color.fromRGBO(111, 64, 36, 1),
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Slope failure near Khe Sanh, ward 10, DaLat, after a heavy rain',
                                  style: TextStyle(
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
                      child: const Column(
                        children: [
                          Column(
                            children: [
                              Align(
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
                              SizedBox(
                                height: 5,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10, bottom: 6),
                                  child: Text(
                                    'Slope failure at Pham Hong Thai str, ward 10, Da Lat',
                                    style: TextStyle(
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
                      child: const Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 6, horizontal: 10),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    '12/11/2021',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Color.fromRGBO(111, 64, 36, 1),
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Slope failure behind the Hoang Long hotel, Nhat Huy hotel, Thao Quyen hotel, Hoang Lan hotel at Khe Sanh str, ward 10, DaLat, in a sunny day',
                                  style: TextStyle(
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
                      margin:
                          const EdgeInsets.only(left: 29, top: 18, right: 29),
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
                      child: const Column(
                        children: [
                          Column(
                            children: [
                              Align(
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
                              SizedBox(
                                height: 5,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10, bottom: 6),
                                  child: Text(
                                    'Geometric monitoring the hotel',
                                    style: TextStyle(
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
                      child: const Column(
                        children: [
                          Column(
                            children: [
                              Align(
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
                              SizedBox(
                                height: 5,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10, bottom: 6),
                                  child: Text(
                                    'Commencement the rehabilitation project',
                                    style: TextStyle(
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
                      margin:
                          const EdgeInsets.only(left: 29, top: 18, right: 29),
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
                      child: const Column(
                        children: [
                          Column(
                            children: [
                              Align(
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
                              SizedBox(
                                height: 5,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10, bottom: 6),
                                  child: Text(
                                    'Installation of the GNSS sensors on the hotel',
                                    style: TextStyle(
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
                      child: const Column(
                        children: [
                          Column(
                            children: [
                              Align(
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
                              SizedBox(
                                height: 5,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10, bottom: 6),
                                  child: Text(
                                    'Installtion of the rain gauge',
                                    style: TextStyle(
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
                      child: const Column(
                        children: [
                          Column(
                            children: [
                              Align(
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
                              SizedBox(
                                height: 5,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10, bottom: 6),
                                  child: Text(
                                    'Installtion of the warning equiptments',
                                    style: TextStyle(
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
                      child: const Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 6, horizontal: 10),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    '14/01/2023',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Color.fromRGBO(1, 59, 111, 1),
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Completed the installation and monitoring of monitoring equipment on the embankment, the blocks are currently stable.',
                                  style: TextStyle(
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
                      margin: const EdgeInsets.symmetric(
                          horizontal: 29, vertical: 18),
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
                      child: const Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 6, horizontal: 10),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    '29/06/2023 02:00 AM',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Color.fromRGBO(66, 0, 0, 1),
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'A landslide on an under-construction project at 15/2 Yen The, Ward 10, Da Lat City destroyed the structure on the slope and at the foot of the slope as well as killing two people.',
                                  style: TextStyle(
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
          ),
        ],
      ),
    );
  }
}
