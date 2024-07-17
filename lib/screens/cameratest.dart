import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:Ageo_solutions/core/api_client.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

enum CameraSelected {
  all,
  camera1,
  camera2,
  camera3,
  camera4,
  camera5,
}

extension CameraSelectedExtension on CameraSelected {
  String get label {
    switch (this) {
      case CameraSelected.all:
        return 'All';
      case CameraSelected.camera1:
        return 'Camera 1';
      case CameraSelected.camera2:
        return 'Camera 2';
      case CameraSelected.camera3:
        return 'Camera 3';
      case CameraSelected.camera4:
        return 'Camera 4';
      case CameraSelected.camera5:
        return 'Camera 5';
      default:
        return '';
    }
  }
}

class CameraScreenTest extends StatefulWidget {
  const CameraScreenTest({super.key});

  @override
  State<CameraScreenTest> createState() => _CameraScreenTestState();
}

class _CameraScreenTestState extends State<CameraScreenTest> {
  CameraSelected _selectedCamera = CameraSelected.camera1;
  late VideoPlayerController _controller;

  Stream<dynamic> fetchCamera(CameraSelected selectedCamera) async* {
    final apiClient = ApiClient();

    // fetch api
    Stream<dynamic> response = const Stream.empty();
    switch (selectedCamera) {
      case CameraSelected.all:
        yield* apiClient.getCamera1();
        yield* apiClient.getCamera2();
        yield* apiClient.getCamera3();
        yield* apiClient.getCamera4();
        yield* apiClient.getCamera5();
        break;
      case CameraSelected.camera1:
        response = apiClient.getCamera1();
        break;
      case CameraSelected.camera2:
        response = apiClient.getCamera2();
        break;
      case CameraSelected.camera3:
        response = apiClient.getCamera3();
        break;
      case CameraSelected.camera4:
        response = apiClient.getCamera4();
        break;
      case CameraSelected.camera5:
        response = apiClient.getCamera5();
        break;
    }
    yield* response;
  }

  // save stream data to file
  Future<File> saveStreamData(Uint8List uint8List) async {
    String tempDir = (await getTemporaryDirectory()).path;
    File file = File('$tempDir/temp_video.mp4');
    await file.writeAsBytes(uint8List);
    return file;
  }

  // play video
  void playVideo(Uint8List uint8List) async {
    File videoFile = await saveStreamData(uint8List);
    VideoPlayerController controller = VideoPlayerController.file(videoFile);
    await controller.initialize();
    controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.45),
                  offset: const Offset(0, 1),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
              child: DropdownMenu(
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
                selectedTrailingIcon: const Icon(Icons.expand_less),
                trailingIcon: const Icon(Icons.expand_more),
                menuStyle: MenuStyle(
                  maximumSize:
                      const WidgetStatePropertyAll(Size.fromHeight(150)),
                  surfaceTintColor: const WidgetStatePropertyAll(
                      Color.fromARGB(255, 255, 255, 255)),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                inputDecorationTheme: InputDecorationTheme(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 10,
                  ),
                  fillColor: const Color.fromARGB(255, 255, 255, 255),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.lightBlueAccent,
                    ),
                  ),
                ),
                initialSelection: _selectedCamera.name,
                onSelected: (value) {
                  setState(() {
                    _selectedCamera =
                        CameraSelected.values.byName(value as String);
                  });
                },
                dropdownMenuEntries: CameraSelected.values
                    .map(
                      (e) => DropdownMenuEntry(value: e.name, label: e.label),
                    )
                    .toList(),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<dynamic>(
                stream: fetchCamera(_selectedCamera),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.connectionState == ConnectionState.done ||
                      snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasError) {
                      final error = snapshot.error;
                      return Center(
                        child: Text('$error'),
                      );
                    } else if (snapshot.hasData) {
                      final response = snapshot.data!;
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(-1, 1),
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: _selectedCamera == CameraSelected.all
                                ? _buildAllCameras(context)
                                : [
                                    if (_selectedCamera ==
                                        CameraSelected.camera1)
                                      _buildCamera(context, 1),
                                    if (_selectedCamera ==
                                        CameraSelected.camera2)
                                      _buildCamera(context, 2),
                                    if (_selectedCamera ==
                                        CameraSelected.camera3)
                                      _buildCamera(context, 3),
                                    if (_selectedCamera ==
                                        CameraSelected.camera4)
                                      _buildCamera(context, 4),
                                    if (_selectedCamera ==
                                        CameraSelected.camera5)
                                      _buildCamera(context, 5),
                                  ],
                          ),
                        ),
                      );
                    }
                  }
                  return Container();
                }),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAllCameras(BuildContext context) {
    return List.generate(5, (index) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        width: MediaQuery.sizeOf(context).width * 1,
        height: MediaQuery.sizeOf(context).height * 0.4,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 1),
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
            ),
          ],
        ),
        child: StreamBuilder<dynamic>(
          stream: fetchCamera(CameraSelected.values[index + 1]),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.done ||
                snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasError) {
                final error = snapshot.error;
                return Center(
                  child: Text('$error'),
                );
              } else if (snapshot.hasData) {
                final response = snapshot.data!;
                return FutureBuilder(
                  future: saveStreamData(response),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      File videoFile = snapshot.data!;
                      VideoPlayerController controller =
                          VideoPlayerController.file(videoFile);
                      return VideoPlayer(controller);
                    } else {
                      return const Center(
                        child: Text('failed to load data'),
                      );
                    }
                  },
                );
              }
            }
            return Container();
          },
        ),
      );
    });
  }

  Widget _buildCamera(BuildContext context, int cameraNumber) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: MediaQuery.sizeOf(context).width * 1,
      height: MediaQuery.sizeOf(context).height * 0.4,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 1),
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
          ),
        ],
      ),
      child: StreamBuilder<dynamic>(
        stream: fetchCamera(CameraSelected.values[cameraNumber]),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done ||
              snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasError) {
              final error = snapshot.error;
              return Center(
                child: Text('$error'),
              );
            } else if (snapshot.hasData) {
              final response = snapshot.data!;
              return FutureBuilder(
                future: saveStreamData(response),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    File videoFile = snapshot.data!;
                    VideoPlayerController controller =
                        VideoPlayerController.file(videoFile);
                    return VideoPlayer(controller);
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              );
            }
          }
          return Container();
        },
      ),
    );
  }
}
