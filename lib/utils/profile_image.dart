import 'package:flutter/material.dart';
import 'package:twinkstar/services/storage_services.dart';

class ProfilePicture extends StatelessWidget {
  final String imgName;
  final double radius;
  const ProfilePicture(
      {super.key, required this.imgName, required this.radius});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: StorageService().downloadUrl('profile_images', imgName),
      builder: ((BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return CircleAvatar(
            radius: radius,
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(snapshot.data!),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        return const CircularProgressIndicator();
      }),
    );
  }
}
