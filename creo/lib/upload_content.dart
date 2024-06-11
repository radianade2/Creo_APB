import 'dart:io';
import 'package:flutter/material.dart';
import 'profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart';

class UploadContentScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  const UploadContentScreen({super.key, required this.user});

  @override
  State<UploadContentScreen> createState() => _UploadContentScreenState();
}

class _UploadContentScreenState extends State<UploadContentScreen> {
  final _titleController = TextEditingController();
  final _detailsController = TextEditingController();
  final _sylabusController = TextEditingController();
  final _targetController = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage firestorage = FirebaseStorage.instance;

  late VideoPlayerController _videoPlayerController;
  File? _videoFile;
  File? _coverImage;

  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen())
            );
          },
        ),
        title: Center(child: Text("Upload Content")),
        actions: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.15,
          )
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Title',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _titleController,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: 'Judul konten yang akan anda upload',
                  hintStyle: TextStyle(color: Color(0xFFADB5BD)),
                  fillColor: Colors.grey.withOpacity(0.1),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.all(16.0),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Details',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _detailsController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Detail umum mengenai konten yang akan anda upload',
                  hintStyle: TextStyle(color: Color(0xFFADB5BD)),
                  fillColor: Colors.grey.withOpacity(0.1),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.all(16.0),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Sylabus',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _sylabusController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText:
                      'Poin poin materi yang akan anda sampaikan pada konten',
                  hintStyle: TextStyle(color: Color(0xFFADB5BD)),
                  fillColor: Colors.grey.withOpacity(0.1),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.all(16.0),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Target Participants',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _targetController,
                decoration: InputDecoration(
                  hintText:
                      'Target utama untuk siapa konten ini ditujukan',
                  hintStyle: TextStyle(color: Color(0xFFADB5BD)),
                  fillColor: Colors.grey.withOpacity(0.1),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.all(16.0),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Cover Content',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: _pickCoverImage,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.withOpacity(0.1),
                  ),
                  child: _coverImage == null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.file_upload_outlined,
                              size: 65,
                            )
                          ],
                        )
                      : Image.file(
                          _coverImage!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Upload Content',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  pickVideo();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.withOpacity(0.1),
                  ),
                  child: _videoFile == null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.file_upload_outlined,
                              size: 65,
                            )
                          ],
                        )
                      : AspectRatio(
                          aspectRatio:
                              _videoPlayerController.value.aspectRatio,
                          child: VideoPlayer(_videoPlayerController),
                        ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: _videoFile == null && _coverImage == null
                    ? null
                    : () async {
                        setState(() {
                          _isUploading = true;
                        });

                        String videoName = _videoFile!.path.split('/').last;
                        String coverName = _coverImage!.path.split('/').last;
                        String uid = auth.currentUser!.uid;
                        try {
                          await firestorage
                              .ref('content/$uid/video/$videoName')
                              .putFile(_videoFile!);
                          await firestorage
                              .ref('content/$uid/cover/$coverName')
                              .putFile(_coverImage!);
                          TaskSnapshot snapVideo = await firestorage
                              .ref('content/$uid/video/$videoName')
                              .putFile(_videoFile!)
                              .whenComplete(() => null);
                          TaskSnapshot snapCover = await firestorage
                              .ref('content/$uid/cover/$coverName')
                              .putFile(_coverImage!)
                              .whenComplete(() => null);
                          String videoUrl =
                              await snapVideo.ref.getDownloadURL();
                          String coverUrl =
                              await snapCover.ref.getDownloadURL();
                          print('Berhasil mengunggah video');
                          await FirebaseFirestore.instance
                              .collection('content')
                              .add({
                            'uploader_name': widget.user['name'],
                            'uploader_uid': widget.user['uid'],
                            'uploader_profile': widget.user['profile'],
                            'title': _titleController.text,
                            'details': _detailsController.text,
                            'sylabus': _sylabusController.text,
                            'target': _targetController.text,
                            'video_url': videoUrl,
                            'cover_url': coverUrl
                          });
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ProfileScreen()),
                          );
                        } on FirebaseException catch (e) {
                          print('Gagal mengunggah video: $e');
                        } finally {
                          setState(() {
                            _isUploading = false;
                          });
                        }
                      },
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.deepPurple,
                    ),
                    minimumSize: MaterialStateProperty.all<Size>(
                      Size(MediaQuery.of(context).size.width, 40),
                    )),
                child: _isUploading
                    ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        'Upload',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  void pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.video);

    if (result != null) {
      setState(() {
        _videoFile = File(result.files.single.path!);
        _videoPlayerController = VideoPlayerController.file(_videoFile!)
          ..initialize().then((_) {
            setState(() {});
          });
      });
    } else {
      print("Tidak ada video yang diupload");
    }
  }

  Future<void> _pickCoverImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _coverImage = File(pickedFile.path);
      });
    }
  }
}
