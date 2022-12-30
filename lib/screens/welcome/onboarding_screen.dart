import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:twinkstar/screens/welcome/login_screen.dart';
import 'package:twinkstar/screens/welcome/signup_screen.dart';
import 'package:twinkstar/utils/utils.dart';
import 'package:twinkstar/extensions/custom_theme_extension.dart';

class OnboardingPageState extends StatefulWidget {
  const OnboardingPageState({super.key});

  @override
  State<OnboardingPageState> createState() => _OnboardingPageStateState();
}

class _OnboardingPageStateState extends State<OnboardingPageState> {
  final controller = PageController(initialPage: 0);

  bool isLastPage = false;
  bool isFirstPage = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: controller,
                  onPageChanged: ((index) {
                    setState(() {
                      isLastPage = index == 2;
                      isFirstPage = index == 0;
                    });
                  }),
                  children: const [
                    OnBoardingContent(
                      lottieAsset: 'assets/jsons/social_network.json',
                      title: 'Expand your Network',
                      description:
                          'Connect With your Friends and explore the World',
                    ),
                    OnBoardingContent(
                      lottieAsset: 'assets/jsons/connect.json',
                      title: 'Connected To World',
                      description:
                          'Stay Up-to-Date What\'s happenening in the World',
                    ),
                    OnBoardingContent(
                      lottieAsset: 'assets/jsons/terms-and-conditions.json',
                      title: 'Terms and Conditions Applied',
                      description:
                          'By Moving Forward you Agree to our Terms and Conditions',
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  isFirstPage
                      ? const SizedBox(height: 60, width: 60)
                      : SizedBox(
                          height: 60,
                          width: 60,
                          child: ElevatedButton(
                              onPressed: () {
                                controller.previousPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut);
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder()),
                              child: const Icon(
                                Icons.arrow_back_rounded,
                                size: 30,
                              )),
                        ),
                  Center(
                    child: SmoothPageIndicator(
                      controller: controller,
                      count: 3,
                      effect: const WormEffect(
                        spacing: 10,
                        dotColor: Colors.grey,
                        activeDotColor: Colors.blue,
                      ),
                      onDotClicked: ((index) => controller.animateToPage(index,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut)),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: ElevatedButton(
                        onPressed: () {
                          !isLastPage
                              ? controller.nextPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut)
                              : showModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: ((context) {
                                    return Container(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              2.5,
                                      decoration: BoxDecoration(
                                        color: context.theme.backgroundColor!,
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(50),
                                          topLeft: Radius.circular(50),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text('LOGIN',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                          CustomizedButton(
                                              buttonText: 'LOG IN',
                                              buttonColor: Colors.black,
                                              textColor: Colors.white,
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const LoginScreen()));
                                              }),
                                          const SizedBox(height: 10),
                                          Text(
                                              'Don\'t have an Account? Register',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                          CustomizedButton(
                                              buttonText: 'SIGN UP',
                                              buttonColor: Colors.white,
                                              textColor: Colors.black,
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const SignUpScreen()));
                                              }),
                                        ],
                                      ),
                                    );
                                  }));
                          // : Navigator.pushAndRemoveUntil(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //             const WelcomeScreen()),
                          //     (route) => false);
                        },
                        style: ElevatedButton.styleFrom(
                            shape: const CircleBorder()),
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          size: 30,
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
