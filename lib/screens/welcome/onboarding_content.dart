import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OnBoardingContent extends StatelessWidget {
  final String lottieAsset, title, description;
  const OnBoardingContent({
    Key? key,
    required this.lottieAsset,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        LottieBuilder.asset(lottieAsset),
        const Spacer(),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .headline5!
              .copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 16),
        Text(
          description,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
