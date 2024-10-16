import 'package:Ageo_solutions/lang/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

class WarningHyScreen extends StatefulWidget {
  const WarningHyScreen({super.key});

  @override
  State<WarningHyScreen> createState() => _WarningHyScreenState();
}

class _WarningHyScreenState extends State<WarningHyScreen> {
  // show alert
  Future<void> _showMyDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            LocalData.bottomlabel5.getString(context),
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  LocalData.confirmAlert.getString(context),
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: MediaQuery.sizeOf(context).width * 1,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(237, 146, 39, 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        LocalData.confirm.getString(context),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextButton(
                  child: Text(
                    LocalData.cancel.getString(context),
                    style: const TextStyle(
                      color: Color.fromRGBO(237, 146, 39, 1),
                      fontSize: 18,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          LocalData.title2.getString(context),
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          // TODO: add api
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            height: size.height * 0.3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: InteractiveViewer(
              boundaryMargin: const EdgeInsets.all(20),
              minScale: 0.5,
              maxScale: 2,
              child: Image.asset(
                "assets/images/hy1.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),

          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 15, bottom: 18),
                      child: Text(
                        LocalData.warnSystem.getString(context),
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
                                child: Text(
                                  LocalData.warnL1.getString(context),
                                  style: const TextStyle(
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
                                child: Text(
                                  LocalData.warnL2.getString(context),
                                  style: const TextStyle(
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
                                child: Text(
                                  LocalData.warnL3.getString(context),
                                  style: const TextStyle(
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
