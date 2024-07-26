import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Camtest extends StatefulWidget {
  const Camtest({super.key});

  @override
  State<Camtest> createState() => _CamtestState();
}

class _CamtestState extends State<Camtest> {
  static const String url = "ws://api.ageo.vn:2000/api/stream/9091/103/0";
 // late VideoPlayerController _controller;
  Uint8List? _videoData;
  bool _isConnected = false;
  final channel = WebSocketChannel.connect(Uri.parse(url));

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
        } else {
          print('Message is not Uint8List');
        }
      },
    );
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Stream'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 50.0,
              ),
              _videoData != null
                  ? StreamBuilder(
                      stream: channel.stream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator();
                        }

                        if (snapshot.connectionState == ConnectionState.done) {
                          return const Center(
                            child: Text("Connection Closed !"),
                          );
                        }

                        return Image.memory(
                          Uint8List.fromList(
                            base64Decode(
                              (snapshot.data.toString()),
                            ),
                          ),
                          gaplessPlayback: true,
                        );
                      },
                    )
                  : const Text("Initiate Connection")
            ],
          ),
        ),
      ),
    );
  }
}
