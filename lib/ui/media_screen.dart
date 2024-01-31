import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class MediaScreen extends StatefulWidget {
  const MediaScreen({super.key});

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  final storageRef = FirebaseStorage.instance.ref();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final Stream<QuerySnapshot> _thumbnailStream =
      FirebaseFirestore.instance.collection('media').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Media')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 32),
          const Center(child: Icon(Icons.image, size: 48)),
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () async {
                            await pickUploadMedia(1);
                          },
                          icon: const Icon(Icons.image, size: 48),
                        ),
                        IconButton(
                          onPressed: () async {
                            await pickUploadMedia(2);
                          },
                          icon: const Icon(Icons.camera, size: 48),
                        ),
                        IconButton(
                          onPressed: () async {
                            await pickUploadMedia(3);
                          },
                          icon: const Icon(Icons.play_circle, size: 48),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: const Text('Pick Media'),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: _thumbnailStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading");
              }

              return Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    var url = snapshot.data!.docs[index]['thumbnail'];
                    var type = snapshot.data!.docs[index]['type'];
                    if (type == 3) {
                      return Container(
                        color: Colors.grey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.play_arrow),
                            ElevatedButton(
                              onPressed: () {
                                showDialog(context: context, builder: (context) {
                                  return _MediaVideoPlayer(url: url);
                                });
                              },
                              child: const Text('Play'),
                            )
                          ],
                        ),
                      );
                    } else {
                      return Image.network(url);
                    }
                  },
                  itemCount: snapshot.data?.docs.length,
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Future<void> pickUploadMedia(int type) async {
    final ImagePicker picker = ImagePicker();
    late XFile? image;
    if (type == 1) {
      image = await picker.pickImage(source: ImageSource.gallery);
    } else if (type == 2) {
      image = await picker.pickImage(source: ImageSource.camera);
    } else {
      image = await picker.pickVideo(source: ImageSource.gallery);
    }
    if (image != null) {
      try {
        var imageRef = storageRef.child(image.name);
        await imageRef.putFile(File(image.path));
        var downloadUrl = await imageRef.getDownloadURL();
        var collection = firestore.collection('media');
        await collection.add({'thumbnail': downloadUrl, 'type': type});
        if (mounted) {
          Navigator.pop(context);
        }
      } on FirebaseException catch (e) {
        print('error upload media ${e.toString()}');
      }
    }
  }
}

class _MediaVideoPlayer extends StatefulWidget {
  final String url;

  const _MediaVideoPlayer({required this.url});

  @override
  _MediaVideoPlayerState createState() => _MediaVideoPlayerState();
}

class _MediaVideoPlayerState extends State<_MediaVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.url),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize();
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20),
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  VideoPlayer(_controller),
                  ClosedCaption(text: _controller.value.caption.text),
                  VideoProgressIndicator(_controller, allowScrubbing: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
