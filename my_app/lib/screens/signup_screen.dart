import 'dart:typed_data';

import 'package:flutter/material.dart';
import "package:flutter_svg/flutter_svg.dart";
import 'package:image_picker/image_picker.dart';
import 'package:my_app/resources/auth_methods.dart';
import 'package:my_app/utils/utils.dart';
import "package:my_app/widgets/text_field_input.dart";
import 'package:my_app/utils/colors.dart';

import '../responsive_layout_screen/mobile_screen_layout.dart';
import '../responsive_layout_screen/responsive_layout_screen.dart';
import '../responsive_layout_screen/web_screen_layout.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signupuser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signupuser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: _image!,
    );
    setState(() {
      _isLoading = false;
    });
    if (res != 'success') {
      showSnackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const ResponsiveLayout(
          webScreenLayout: WebScreenLayout(),
          mobileScreenLayout: MobileScreenLayout(),
        ),
      ));
    }
  }

  void navigateToLogin() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const LoginScreen(),
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
                    const SizedBox(height: 34),
                    //circular widget
                    Stack(
                      children: [
                        _image != null
                            ? CircleAvatar(
                                radius: 64,
                                backgroundImage: MemoryImage(_image!),
                              )
                            : const CircleAvatar(
                                radius: 64,
                                backgroundImage: NetworkImage(
                                    "https://t3.ftcdn.net/jpg/00/64/67/80/360_F_64678017_zUpiZFjj04cnLri7oADnyMH0XBYyQghG.jpg"),
                              ),
                        Positioned(
                          bottom: -10,
                          left: 80,
                          child: IconButton(
                            onPressed: selectImage,
                            icon: const Icon(
                              Icons.add_a_photo,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // text field input for username
                    TextFieldInput(
                        textEditingController: _usernameController,
                        hinText: "Create Username",
                        textInputType: TextInputType.text),
                    const SizedBox(height: 10),

                    //text field input for email

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
                    const SizedBox(height: 10),
                    // text field input for bio
                    TextFieldInput(
                        textEditingController: _bioController,
                        hinText: " Enter Your Bio",
                        textInputType: TextInputType.text),

                    const SizedBox(height: 24),
                    // text field input for password
                    //button login
                    InkWell(
                      onTap: signupuser,
                      child: Container(
                        child: _isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: primaryColor,
                                ),
                              )
                            : const Text('Sign up'),
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
                          onTap: navigateToLogin,
                          child: Container(
                            child: const Text("Log in.",
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
