import 'package:flutter/material.dart';
import 'video_player_page.dart';

class ContentInfoPage extends StatefulWidget {
  // final Map<String, dynamic> user;
  final Map<String, dynamic> contentt;
  const ContentInfoPage({super.key, required this.contentt});

  @override
  State<ContentInfoPage> createState() => _ContentInfoPageState();
}

class _ContentInfoPageState extends State<ContentInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    widget.contentt["uploader_profile"] != null
                      ? widget.contentt["uploader_profile"] != ""
                          ? widget.contentt["uploader_profile"]
                          : "https://ui-avatars.com/api/?name=${widget.contentt['uploader_name']}"
                      : "https://ui-avatars.com/api/?name=${widget.contentt['uploader_name']}",
                    width: 90.0,
                    height: 90.0,
                    fit: BoxFit.cover,
                  )
                ),
                SizedBox(height: 5,),
                Text(widget.contentt["uploader_name"], style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                SizedBox(height: 15,),
                Container(
                  padding: EdgeInsets.all(16),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.contentt['title'],
                        style: TextStyle(
                        color: Color(0xFF191919),
                          fontSize: 18,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 15,),
                      Text(
                        'Details',
                        style: TextStyle(
                        color: Color(0xFF191919),
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text(
                        widget.contentt['details'],
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 13,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        "What You'll Learn",
                        style: TextStyle(
                        color: Color(0xFF191919),
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text(
                        widget.contentt['sylabus'],
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 13,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        "Target Participants",
                        style: TextStyle(
                        color: Color(0xFF191919),
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text(
                        widget.contentt['target'],
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 13,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VideoPlayerScreen(url: widget.contentt['video_url'])),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Stack(
                      children : [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            widget.contentt['cover_url'],
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.3,
                            fit: BoxFit.cover,
                          ),
                          
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black.withOpacity(0.25)
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.075),
                            child: Icon(
                              Icons.play_arrow_rounded, size: 100, color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15,),
                GestureDetector(
                  onTap: () {
                    
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color(0xFF7028E4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Done",
                          style: TextStyle(
                          color: Color(0xFFF8F9FA),
                            fontSize: 14,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                            ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ),
    );
  }
}