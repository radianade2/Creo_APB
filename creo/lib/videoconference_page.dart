import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

class VideoConferencePage extends StatelessWidget {
  final String conferenceID;
  final Map<String, dynamic>? user;

  const VideoConferencePage({
    Key? key,
    required this.conferenceID,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
    
      child: ZegoUIKitPrebuiltVideoConference(
        appID: 1398795098,
        appSign: "34aae8f65648f3742f820dbf0f8c2b19e90588558a470800778e4b9fcf3403dc",
        userID: this.user!['uid'],
        userName: this.user!['username'],
        conferenceID: conferenceID,
        config: ZegoUIKitPrebuiltVideoConferenceConfig(),
      ),

    );
  }
}
