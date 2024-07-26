import 'package:flutter/material.dart';

class WarningScreen extends StatefulWidget {
  const WarningScreen({super.key});

  @override
  State<WarningScreen> createState() => _WarningScreenState();
}

class _WarningScreenState extends State<WarningScreen> {
  // show alert
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

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
      ),
    );
  }
}
