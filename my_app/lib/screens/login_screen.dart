import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:my_app/screens/signup_screen.dart";
import "package:my_app/utils/utils.dart";
import "package:my_app/widgets/text_field_input.dart";
import 'package:my_app/utils/colors.dart';

import "../resources/auth_methods.dart";
import "../responsive_layout_screen/mobile_screen_layout.dart";
import "../responsive_layout_screen/responsive_layout_screen.dart";
import "../responsive_layout_screen/web_screen_layout.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginuser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginuser(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (res == "success") {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const ResponsiveLayout(
          webScreenLayout: WebScreenLayout(),
          mobileScreenLayout: MobileScreenLayout(),
        ),
      ));
    } else {
      showSnackBar(res, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void navigateTosignup() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const SignupScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(child: Container(), flex: 2),
                    // svg image
                    SvgPicture.asset(
                      'assets/ic_instagram.svg',
                      // ignore: deprecated_member_use
                      color: primaryColor,
                      height: 64,
                    ),
                    //text field input for email
                    const SizedBox(height: 34),
                    TextFieldInput(
                        textEditingController: _emailController,
                        hinText: "Enter Your E-Mail",
                        textInputType: TextInputType.emailAddress),
                    const SizedBox(height: 10),
                    TextFieldInput(
                        textEditingController: _passwordController,
                        isPass: true,
                        hinText: "Enter Your Password",
                        textInputType: TextInputType.text),
                    const SizedBox(height: 24),
                    // text field input for password
                    //button login
                    InkWell(
                      onTap: loginuser,
                      child: Container(
                        child: _isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: primaryColor,
                                ),
                              )
                            : const Text('Log in'),
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                          ),
                          color: blueColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 34),

                    // transitioning to sign up
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: const Text("Don't have an account?"),
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                          ),
                        ),
                        GestureDetector(
                          onTap: navigateTosignup,
                          child: Container(
                            child: const Text("Sign up.",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Flexible(child: Container(), flex: 2),
                  ],
                ))));
  }
}
