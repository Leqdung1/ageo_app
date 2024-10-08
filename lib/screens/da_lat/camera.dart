import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

enum CameraSelected {
  camera1,
  camera2,
  camera3,
  camera4,
  camera5,
}

extension CameraSelectedExtension on CameraSelected {
  String get label {
    switch (this) {
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
  // ignore: library_private_types_in_public_api
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraSelected _selectedCamera = CameraSelected.camera1;
  late VlcPlayerController _vlcPlayerController;

  String _getCamUrl(CameraSelected camera) {
    switch (camera) {
      case CameraSelected.camera1:
        return 'rtsp://rtsp:Ageo2023\$@117.2.137.16:9091/Streaming/Channels/103';
      case CameraSelected.camera2:
        return 'rtsp://rtsp:Ageo2023\$@117.2.137.16:9092/Streaming/Channels/102';
      case CameraSelected.camera3:
        return 'rtsp://rtsp:Ageo2023\$@117.2.137.16:9093/Streaming/Channels/102';
      case CameraSelected.camera4:
        return 'rtsp://rtsp:Ageo2023\$@117.2.137.16:9094/Streaming/Channels/102';
      case CameraSelected.camera5:
        return 'rtsp://rtsp:Ageo2023\$@117.2.137.16:9095/Streaming/Channels/102';
      default:
        return '';
    }
  }

  void fetchCamera() {
    _vlcPlayerController = VlcPlayerController.network(
      _getCamUrl(_selectedCamera),
      hwAcc: HwAcc.full,
      autoPlay: true,
      options: VlcPlayerOptions(),
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchCamera();
  }

  @override
  void dispose() {
    _vlcPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 15,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            dropDown(),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.02,
            ),
            viewCamera(),
          ],
        ),
      ),
    );
  }

  Widget dropDown() {
    return Container(
      margin: const EdgeInsets.all(15),
      // drop down menu
      child: DropdownMenu(
        textStyle: TextStyle(
          color: Theme.of(context).textTheme.bodyLarge?.color,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        selectedTrailingIcon: Icon(
          Icons.expand_less,
          color: Theme.of(context).iconTheme.color,
        ),
        trailingIcon: Icon(
          Icons.expand_more,
          color: Theme.of(context).iconTheme.color,
        ),
        menuStyle: MenuStyle(
          maximumSize: const WidgetStatePropertyAll(
            Size.fromHeight(160),
          ),
          surfaceTintColor: const WidgetStatePropertyAll(
            Colors.white,
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Theme.of(context).colorScheme.primary,
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
        initialSelection: _selectedCamera.label,
        onSelected: (value) {
          setState(() {
            _selectedCamera =
                CameraSelected.values.firstWhere((e) => e.label == value);

            _vlcPlayerController
                .setMediaFromNetwork(_getCamUrl(_selectedCamera));
          });
        },
        dropdownMenuEntries: CameraSelected.values
            .map(
              (e) => DropdownMenuEntry(
                value: e.label,
                labelWidget: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Text(
                    e.label,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
                label: e.label,
              ),
            )
            .toList(),
      ),
    );
  }

  Widget viewCamera() {
    return Center(
      child: VlcPlayer(
        controller: _vlcPlayerController,
        aspectRatio: 16 / 9,
        placeholder: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Color.fromRGBO(237, 146, 39, 1),
          ),
        ),
      ),
    );
  }
}
