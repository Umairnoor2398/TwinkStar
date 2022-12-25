import 'package:flutter/material.dart';

class ProfilePicture extends StatefulWidget {
  final String imgPath;
  const ProfilePicture({super.key, required this.imgPath});

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  @override
  Widget build(BuildContext context) {
    return const ClipRRect(
      child: SizedBox(
        height: 200,
        width: 200,
        // child: FadeInImage(
        //   image: NetworkImage(),
        // ),
      ),
    );
  }
}
