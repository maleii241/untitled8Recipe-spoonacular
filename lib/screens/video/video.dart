import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled8/screens/video/video_screen.dart';
import 'package:untitled8/screens/video/services/api_service.dart';
import 'package:kf_drawer/kf_drawer.dart';

import 'constants.dart';
import 'models/channel_model.dart';
import 'models/video_model.dart';

class Notifications extends KFDrawerContent {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  Channel _channel;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _initChannel();
  }
  _initChannel() async {
    Channel channel = await APIService.instance
        .fetchChannel(channelId: 'UC3KKTJ-z5RmBqNtleRBl7fQ');
    setState(() {
      _channel = channel;
    });
  }


  _buildVideo(Video video) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VideoScreen(id: video.id),
        ),
      ),
      child: Container(
        height: 150,
        margin: EdgeInsets.only(right: 16, left: 16, bottom: 16, top: 3),
        decoration: BoxDecoration(
          color:   Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
          boxShadow: [kBoxShadow],
        ),

        padding: EdgeInsets.all(16),
        width: 220,
        child: Row(
          children: <Widget>[
            Image(
              width: 150.0,
              image: NetworkImage(video.thumbnailUrl),
            ),
            SizedBox(width: 15.0),
            Expanded(
              child: Text(
                video.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _loadMoreVideos() async {
    _isLoading = true;
    SpinKitCircle(
      color: Colors.red,
      size: 50,
    );
    List<Video> moreVideos = await APIService.instance
        .fetchVideosFromPlaylist(playlistId: _channel.uploadPlaylistId);
    List<Video> allVideos = _channel.videos..addAll(moreVideos);
    setState(() {
      _channel.videos = allVideos;
    });
    _isLoading = false;
  }





  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);



    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.brown.withOpacity(0.3),
        centerTitle: true,
        title: Text('RecipeApp Video',
          style: GoogleFonts.lobster(
              textStyle: TextStyle(color: Colors.red, fontSize: 30)),
        ),

      ),

    body: Stack(
    children: <Widget>[
    Container(
    height: double.infinity,
    width: double.infinity,
    decoration: BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(
                "https://i.pinimg.com/originals/06/4c/00/064c008a1d7426e62dc1d1677882353c.gif"))),
    child: _channel != null
          ? NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollDetails) {
          if (!_isLoading &&
              _channel.videos.length != int.parse(_channel.videoCount) &&
              scrollDetails.metrics.pixels ==
                  scrollDetails.metrics.maxScrollExtent) {
            _loadMoreVideos();
          }
          return false;
        },
        child: ListView.builder(
          itemCount: _channel.videos.length,
          itemBuilder: (BuildContext context, int index) {

            Video video = _channel.videos[index];
            return _buildVideo(video);
          },
        ),
      )
          : Center(

        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).primaryColor,
          ),
        ),



      ),
    )]));
  }
}