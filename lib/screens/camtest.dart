import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Camtest extends StatefulWidget {
  const Camtest({super.key});

  @override
  State<Camtest> createState() => _CamtestState();
}

class _CamtestState extends State<Camtest> {
  Uint8List? _videoData;
  VideoPlayerController? _controller;
  bool _isConnected = false;
  final channel = WebSocketChannel.connect(
      Uri.parse("ws://api.ageo.vn:2000/api/stream/9091/103/0"));

  @override
  void initState() {
    super.initState();
    streamListener();
  }

  void streamListener() {
    channel.stream.listen(
      (message) {
        if (message is Uint8List) {
          setState(() {
            _videoData = message;
          });
          _initializeVideoPlayer();
        } else {
          print('Received non-Uint8List message: $message');
        }
      },
      onError: (error) {
        print('Error in stream: $error');
      },
      onDone: () {
        print('Stream closed');
      },
    );
  }

  Future<void> _initializeVideoPlayer() async {
    if (_videoData != null) {
      try {
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/temp_video.mp4');
        await file.writeAsBytes(_videoData!);
        print('Video file written to ${file.path}');

        _controller = VideoPlayerController.file(file);

        await _controller!.initialize();
        print('VideoPlayerController initialized');
        setState(() {});
        _controller?.play();
      } catch (e) {
        print('Erro: $e');
      }
    } else {
      print('Stream data is null');
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Stream'),
      ),
      body: Center(
        child: _videoData == null
            ? const Text('Waiting for video stream...')
            : _isConnected
                ? StreamBuilder(
                    stream: channel.stream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.connectionState ==
                          ConnectionState.active) {
                        return _controller != null &&
                                _controller!.value.isInitialized
                            ? AspectRatio(
                                aspectRatio: _controller!.value.aspectRatio,
                                child: VideoPlayer(_controller!),
                              )
                            : const CircularProgressIndicator();
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        return const Center(
                          child: Text('Connection closed'),
                        );
                      } else {
                        return const Center(
                          child: Text('Error occurred'),
                        );
                      }
                    },
                  )
                : const CircularProgressIndicator(),
      ),
    );
  }
}
