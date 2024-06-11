import 'dart:math';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'livestreaming_join.dart';

class LivePage extends StatefulWidget {
  final String liveID;
  final bool isHost;
  final Map<String, dynamic> user;

  const LivePage({
    Key? key,
    required this.liveID,
    this.isHost = false,
    required this.user,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => LivePageState();
}

class LivePageState extends State<LivePage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltLiveStreaming(
        appID: 1712256207,
        appSign: 'b738ff0ade6412250ea3b05997c5d5eb053b65255fb56cfd97363b4d9486c823',
        userID: widget.user['uid'],
        userName: widget.user['username'] ?? 'Guest',   
        liveID: widget.liveID,
        events: ZegoUIKitPrebuiltLiveStreamingEvents(
          onEnded: (
            ZegoLiveStreamingEndEvent event,
            VoidCallback defaultAction,
          ) async {
            if (ZegoLiveStreamingEndReason.hostEnd == event.reason) {
              if (event.isFromMinimizing) {
                ZegoUIKitPrebuiltLiveStreamingController().minimize.hide();
              } else {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LiveStreamingJoin(user: widget.user,)));
              }
            } else {
              if(widget.isHost) {
                try{
                  await firestore.collection("user").doc(widget.user['uid']).update({
                    "isLive": false
                  });
                  sendNotification();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: const Text('Tidak Bisa Mengakhiri Live'))
                  );
                }  
              }
              defaultAction.call();
            }
          },
        ),
        config: widget.isHost
            ? ZegoUIKitPrebuiltLiveStreamingConfig.host()
            : ZegoUIKitPrebuiltLiveStreamingConfig.audience()
          ..preview.showPreviewForHost = false
          ..inRoomMessage.notifyUserJoin = true
          ..inRoomMessage.notifyUserLeave = true
          ..innerText.userEnter = widget.isHost ? "started live" : 'joined'
          ..innerText.userLeave = widget.isHost ? "ended live" : 'left'
      ),
    );
  }

  void sendNotification() async {
    String randomStr;
    const String _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    Random _rnd = Random();

    randomStr = String.fromCharCodes(Iterable.generate( 20,
      (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length)),
    ));

    try {
      await firestore.collection("notification").doc(randomStr).set({
        "name": widget.user['name'],
        "message": "Live Streaming Has Ended!",
        "profile": widget.user['profile'] != null
                    ? widget.user['profile'] != "" 
                      ? widget.user['profile']
                      : "https://ui-avatars.com/api/?name=${widget.user['name']}"
                    : "https://ui-avatars.com/api/?name=${widget.user['name']}",
        "createdAt": DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Tidak Dapat Mengirimkan Notifikasi'))
      );
    }
  }
}