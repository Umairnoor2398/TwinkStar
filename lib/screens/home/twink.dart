import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:twinkstar/utils/profile_image.dart';
import 'package:timeago/timeago.dart' as timeago;

class Twink extends StatefulWidget {
  final Icon likedIcon;
  final Icon savedIcon;
  final Function likePress;
  final Function savePress;
  final DocumentSnapshot docSnapshot;
  const Twink({
    super.key,
    required this.likedIcon,
    required this.savedIcon,
    required this.likePress,
    required this.savePress,
    required this.docSnapshot,
  });

  @override
  State<Twink> createState() => _TwinkState();
}

class _TwinkState extends State<Twink> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(height: 5.0),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.black,
            child:
                ProfilePicture(imgName: widget.docSnapshot['user'], radius: 19),
          ),
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.docSnapshot['username'].toString(),
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '@${widget.docSnapshot['email'].toString()}',
                        style: const TextStyle(
                            fontSize: 13,
                            fontStyle: FontStyle.normal,
                            color: Colors.grey),
                      ),
                    ],
                  ),
                  Text(
                    timeago.format(widget.docSnapshot['time'].toDate()),
                    style: const TextStyle(
                        fontSize: 13,
                        fontStyle: FontStyle.normal,
                        color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                widget.docSnapshot['twink'].toString().trim(),
                overflow: TextOverflow.clip,
                maxLines: null,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {
                            widget.likePress();
                            setState(() {});
                          },
                          icon: widget.likedIcon),
                      Text(
                        widget.docSnapshot['likes'].toString().trim(),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          widget.savePress();
                          setState(() {});
                        },
                        icon: widget.savedIcon,
                      ),
                      Text(
                        widget.docSnapshot['saved'].toString().trim(),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
