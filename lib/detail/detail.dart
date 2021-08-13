import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class DetailPic extends StatelessWidget {
  String pic;
  String photo;
  DetailPic({ required this.pic, required this.photo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(230.0),
          child: AppBar(
            title: Text(photo),
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back)),
            flexibleSpace: Container(
              height: 260,
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: CachedNetworkImage(
                      imageUrl: pic,
                      fit: BoxFit.fill,
                      placeholder: (context, url) => Shimmer.fromColors(
                          child: Center(child: Text('Loading')),
                          baseColor: Colors.red,
                          highlightColor: Colors.yellow),
                      errorWidget: (context, url, error) =>
                          new Icon(Icons.error),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 10)),
            Center(
              child: Text(photo),
            ),
          ],
        ));
  }
}
