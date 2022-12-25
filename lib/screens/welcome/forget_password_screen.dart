import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twinkstar/screens/welcome/login_screen.dart';
import 'package:twinkstar/utils/utils.dart';

class ForgotPassword extends StatefulWidget {
  static TextEditingController emailController = TextEditingController();
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState(emailController);
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();

  _ForgotPasswordState(this.emailController);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_sharp),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    )),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "Don't worry! It occurs. Please enter the email address linked with your account.",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
                CustomizedTextField(
                    controller: emailController,
                    hintText: 'Enter Your Email',
                    isPassword: false,
                    keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 30),
                CustomizedLoginSignupButton(
                    buttonText: 'Send Code',
                    buttonColor: Colors.black,
                    textColor: Colors.white,
                    onPressed: () async {
                      FirebaseAuth.instance
                          .sendPasswordResetEmail(email: emailController.text)
                          .then((value) {
                        Toast.showToast(
                            'Check Your Email to Reset Password', Colors.blue);
                        // Navigator.push(context, MaterialPageRoute(builder: (context)=>OTPScreen(emailController: emailController)));
                      }).onError((error, stackTrace) {
                        Toast.showToast(error.toString(), Colors.red);
                      });
                      // EmailSend email=new EmailSend();
                      // email.sendEmail();
                      // email.SendEmail(emailController.text, 'body', emailController.text);
                      // showDialog(
                      //   context: context,
                      //   builder: (context)=> CupertinoAlertDialog(
                      //     title: new Text("Dialog Title"),
                      //     content: new Text("Your Password has been emailed at your own email Address"),
                      //     actions: <Widget>[
                      //       CupertinoDialogAction(
                      //         onPressed: (){
                      //           Navigator.of(context).pop();
                      //         },
                      //         isDefaultAction: true,
                      //         child: Text("Okh"),
                      //       ),
                      //       // CupertinoDialogAction(
                      //       //   child: Text("No"),
                      //       // )
                      //     ],
                      //   ),
                      // builder: (context) => AlertDialog(
                      //   title: const Text("Forgot Password"),
                      //   content: const Text("Your Password has been emailed at your own email Address"),
                      //   actions: <Widget>[
                      //     TextButton(
                      //       onPressed: () {
                      //         Navigator.of(context).pop();
                      //
                      //       },
                      //       child: Container(
                      //         // color: Colors.green,
                      //         padding: const EdgeInsets.all(14),
                      //         child: const Text("okay"),
                      //       ),
                      //     ),
                      //   ],
                      // ),

                      // );
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>OTPScreen(emailController: emailController,)));
                    }),
                SingleChildScrollView(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        "Remember Password?",
                        style:
                            TextStyle(fontSize: 15, color: Color(0xff1e232c)),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          },
                          child: const Text(
                            'LogIn',
                            style: TextStyle(
                                fontSize: 15, color: Color(0xff35c2c1)),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
