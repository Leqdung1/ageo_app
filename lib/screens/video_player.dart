import 'dart:io';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:typed_data';
import 'package:video_player/video_player.dart';

class VideoStreamPage extends StatefulWidget {
  @override
  _VideoStreamPageState createState() => _VideoStreamPageState();
}

class _VideoStreamPageState extends State<VideoStreamPage> {
  WebSocketChannel? _channel;
  bool _isConnected = false;
  late String _hlsUrl;
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _connectToWebSocket();
  }

  @override
  void dispose() {
    _channel?.sink.close();
    _videoController?.dispose();
    super.dispose();
  }

  void _connectToWebSocket() {
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://api.ageo.vn:2000/api/stream/9091/103/0'),
    );

    _channel!.stream.listen(
      (message) {
        if (message is Uint8List) {
          _processRawStreamData(message);
        } else {
          print('Received non-binary message.');
        }
      },
      onError: (error) {
        print('WebSocket Error: $error');
      },
      onDone: () {
        print('WebSocket connection closed.');
      },
    );
  }

  void _processRawStreamData(Uint8List data) {
    print('Received binary data of length: ${data.length}');
    _pipeToFFmpeg(data);
  }

  void _pipeToFFmpeg(Uint8List rawData) async {
    try {
      // Get the temporary directory
      Directory tempDir = await getTemporaryDirectory();
      String tempFilePath = '${tempDir.path}/input.ts';
      File tempFile = File(tempFilePath);

      // Write raw data to file
      await tempFile.writeAsBytes(rawData);

      // Use FFmpeg to convert the file
      FFmpegKit.execute(
              '-i $tempFilePath -hls_time 2 -hls_list_size 0 -f hls /storage/emulated/0/Movies/output.m3u8')
          .then((session) {
        session.getReturnCode().then((returnCode) {
          if (ReturnCode.isSuccess(returnCode)) {
            print('FFmpeg processing completed.');
            setState(() {
              _hlsUrl = '/storage/emulated/0/Movies/output.m3u8';
              _isConnected = true;
              _initializeVideoPlayer();
            });
          } else {
            print('FFmpeg processing failed.');
          }
        });
      });
    } catch (e) {
      print('Error while processing video: $e');
    }
  }

  void _initializeVideoPlayer() {
    _videoController = VideoPlayerController.file(File(_hlsUrl))
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Stream via FFmpeg'),
      ),
      body: Center(
        child: _isConnected
            ? _videoController != null && _videoController!.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: VideoPlayer(_videoController!),
                  )
                : CircularProgressIndicator()
            : CircularProgressIndicator(),
      ),
    );
  }
}
