import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WarningScreen extends StatefulWidget {
  const WarningScreen({super.key});

  @override
  State<WarningScreen> createState() => _WarningScreenState();
}

class _WarningScreenState extends State<WarningScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
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
                color: Colors.white,
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
                    const Padding(
                      padding: EdgeInsets.only(top: 10, left: 15, bottom: 18),
                      child: Text(
                        'Warning system',
                        style: TextStyle(
                            fontSize: 15,
                            color: Color.fromRGBO(49, 52, 66, 1),
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
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
                              offset: Offset(0, 1),
                              blurRadius: 8,
                            )
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: size.width * 0.03,
                            ),
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromRGBO(21, 101, 192, 1),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.warning_amber_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
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
                      onTap: () {},
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 29, vertical: 15),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 241, 219, 1),
                          border: Border.all(
                            color: Color.fromRGBO(255, 217, 157, 1),
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: Offset(0, 1),
                              blurRadius: 8,
                            )
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: size.width * 0.03,
                            ),
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromRGBO(248, 199, 88, 1),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.warning_amber_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromRGBO(248, 199, 88, 1),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
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
                      onTap: () {},
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 29,
                        ),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(253, 237, 237, 1),
                          border: Border.all(
                            color: Color.fromRGBO(247, 187, 186, 1),
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: Offset(0, 1),
                              blurRadius: 8,
                            )
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: size.width * 0.03,
                            ),
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromRGBO(238, 101, 102, 1),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.warning_amber_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromRGBO(238, 102, 102, 1),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
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
      ),
    );
  }
}
