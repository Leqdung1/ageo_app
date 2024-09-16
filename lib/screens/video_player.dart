import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VideoStreamPage extends StatefulWidget {
  @override
  _VideoStreamPageState createState() => _VideoStreamPageState();
}

class _VideoStreamPageState extends State<VideoStreamPage> {
  WebSocketChannel? _channel;
  RTCPeerConnection? _peerConnection;
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _initializeRenderer();
    _connectToWebSocket();
  }

  @override
  void dispose() {
    _remoteRenderer.dispose();
    _channel?.sink.close();
    _peerConnection?.close();
    super.dispose();
  }

  Future<void> _initializeRenderer() async {
    await _remoteRenderer.initialize();
  }

  void _connectToWebSocket() {
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://api.ageo.vn:2000/api/stream/9091/103/0'),
    );

    _channel!.stream.listen(
      (message) {
        if (message is String) {
          _handleSignalingMessage(jsonDecode(message));
        } else if (message is Uint8List) {
          _handleBinaryData(message);
        } else {
          print('Unknown message type received');
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

  void _handleBinaryData(Uint8List data) {
    print('Received binary data of length: ${data.length}');
    // Handle the binary media stream data here
  }

  Future<void> _handleSignalingMessage(Map<String, dynamic> message) async {
    if (message.containsKey('sdp')) {
      var sessionDescription = RTCSessionDescription(
        message['sdp'],
        message['type'],
      );
      await _peerConnection?.setRemoteDescription(sessionDescription);

      if (sessionDescription.type == 'offer') {
        var answer = await _peerConnection!.createAnswer();
        await _peerConnection!.setLocalDescription(answer);
        _sendSignalingMessage({
          'sdp': answer.sdp,
          'type': answer.type,
        });
      }
    } else if (message.containsKey('candidate')) {
      var candidate = RTCIceCandidate(
        message['candidate'],
        message['sdpMid'],
        message['sdpMLineIndex'],
      );
      await _peerConnection?.addCandidate(candidate);
    }
  }

  void _sendSignalingMessage(Map<String, dynamic> message) {
    _channel!.sink.add(jsonEncode(message));
  }

  Future<void> _createPeerConnection() async {
    var configuration = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ],
    };
    _peerConnection?.onIceConnectionState = (RTCIceConnectionState state) {
      print('ICE connection state: $state');
    };

    _peerConnection?.onConnectionState = (RTCPeerConnectionState state) {
      print('Peer connection state: $state');
    };

    _peerConnection = await createPeerConnection(configuration);

    _peerConnection?.onTrack = (RTCTrackEvent event) {
      if (event.track.kind == 'video') {
        setState(() {
          _remoteRenderer.srcObject = event.streams.first;
        });
      }
    };

    _peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
      _sendSignalingMessage({
        'candidate': candidate.candidate,
        'sdpMid': candidate.sdpMid,
        'sdpMLineIndex': candidate.sdpMLineIndex,
      });
    };

    var offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);
    _sendSignalingMessage({
      'sdp': offer.sdp,
      'type': offer.type,
    });

    setState(() {
      _isConnected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Real-time Video Stream'),
      ),
      body: Center(
        child: _isConnected
            ? RTCVideoView(_remoteRenderer)
            : CircularProgressIndicator(),
      ),
    );
  }
}
