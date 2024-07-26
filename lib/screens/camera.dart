import 'dart:io';
import 'dart:typed_data';

import 'package:Ageo_solutions/core/api_client.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

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

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraSelected _selectedCamera = CameraSelected.all;

  // convert stream data into file
  Future<File> _saveStreamData(Uint8List streamData) async {
    String tempPath = (await getTemporaryDirectory()).path;
    File file = File('$tempPath/temp_video.mp4');
    await file.writeAsBytes(streamData);
    return file;
  }

  // create video player
  void playVideo(Uint8List streamData) async {
    File videoFile = await _saveStreamData(streamData);
    // VideoPlayerController controller = VideoPlayerController.file(videoFile);
    // await controller.initialize();
    // controller.play();
  }

  // fetch api
  Stream<Uint8List> fetchCamera(CameraSelected selectedCamera) async* {
    final apiClient = ApiClient();
    Stream<Uint8List> response = const Stream.empty();

    try {
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
    } catch (e) {
      print("Error in fetchCamera: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 245, 1),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
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
                  maximumSize: WidgetStatePropertyAll(Size.fromHeight(150)),
                  surfaceTintColor: const WidgetStatePropertyAll(
                      Color.fromARGB(255, 255, 255, 255)),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                inputDecorationTheme: InputDecorationTheme(
                  fillColor: const Color.fromRGBO(245, 245, 245, 1),
                  filled: true,
                  border: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 0,
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
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
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
                          if (_selectedCamera == CameraSelected.camera1)
                            _buildCamera1(context),
                          if (_selectedCamera == CameraSelected.camera2)
                            _buildCamera2(context),
                          if (_selectedCamera == CameraSelected.camera3)
                            _buildCamera3(context),
                          if (_selectedCamera == CameraSelected.camera4)
                            _buildCamera4(context),
                          if (_selectedCamera == CameraSelected.camera5)
                            _buildCamera5(context),
                        ],
                ),
              ),
            ),
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
      );
    });
  }

  Widget _buildCamera1(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: MediaQuery.sizeOf(context).width * 1,
      height: MediaQuery.sizeOf(context).height * 0.4,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 103, 21, 21),
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
    );
  }

  Widget _buildCamera2(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: MediaQuery.sizeOf(context).width * 1,
      height: MediaQuery.sizeOf(context).height * 0.4,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 21, 103, 21),
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
    );
  }

  Widget _buildCamera3(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: MediaQuery.sizeOf(context).width * 1,
      height: MediaQuery.sizeOf(context).height * 0.4,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 103, 21, 61),
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
    );
  }

  Widget _buildCamera4(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: MediaQuery.sizeOf(context).width * 1,
      height: MediaQuery.sizeOf(context).height * 0.4,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 77, 103, 21),
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
    );
  }

  Widget _buildCamera5(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: MediaQuery.sizeOf(context).width * 1,
      height: MediaQuery.sizeOf(context).height * 0.4,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 36, 21, 103),
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
    );
  }
}
