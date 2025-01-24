import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_project/bloc/auth_bloc_bloc.dart';
import 'package:pos_project/bloc/bloc/user_data_bloc.dart';
import 'package:pos_project/screens/login_screen.dart';
import 'package:pos_project/widgets/buttons.dart';
import 'package:pos_project/widgets/textfields.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _nameController = TextEditingController();

    void signUpUser() {
      context.read<AuthBlocBloc>().add(SignUpRequestEvent(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text));
      try {
        final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
        if (uid.isNotEmpty) {
          context.read<UserDataBloc>().add(FetchUserDataEvent(uid: uid));
        }
      } catch (e) {
        Text('Error fetching user: ${e.toString()}');
      }
    }

    return BlocBuilder<AuthBlocBloc, AuthBlocState>(
      builder: (context, state) {
        if (state is AuthBlocLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AuthBlocSuccessState) {
          Future.microtask(() {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginScreen()));
          });
        } else if (state is AuthBlocErrorState) {
          Future.microtask(() {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("the user with email already exists")));
          });
        }
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Expanded(
                //   flex: 10,
                //   child: Image.asset(
                //     'assets/images/sign_up.jpg',
                //     fit: BoxFit.cover,
                //   ),
                // ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.02,
                            vertical: screenHeight * 0.04),
                        child: AnimatedTextKit(
                          animatedTexts: [
                            TypewriterAnimatedText('Create Account',
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        const Color.fromARGB(255, 41, 121, 255),
                                    fontSize: screenHeight * 0.05),
                                speed: const Duration(milliseconds: 300)),
                            // TyperAnimatedText('Create Account',
                            //     textStyle: TextStyle(
                            //         fontWeight: FontWeight.bold,
                            //         color:
                            //             const Color.fromARGB(255, 41, 121, 255),
                            //         fontSize: screenHeight * 0.05),
                            //     speed: const Duration(milliseconds: 100)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                      child: Text(
                        'Sign up to get started',
                        style: TextStyle(fontSize: screenHeight * 0.02),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.04,
                ),

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.1,
                  ),
                  child: CustomTextFields(
                      autoFocus: true,
                      textEditingController: _nameController,
                      textInputType: TextInputType.name,
                      obscureText: false,
                      hintText: 'Enter your name'),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: CustomTextFields(
                      autoFocus: true,
                      textEditingController: _emailController,
                      textInputType: TextInputType.emailAddress,
                      obscureText: false,
                      hintText: 'Enter your email'),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: CustomTextFields(
                      autoFocus: false,
                      textEditingController: _passwordController,
                      textInputType: TextInputType.text,
                      obscureText: true,
                      hintText: 'password'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.1,
                      vertical: screenHeight * 0.06),
                  child: SizedBox(
                    width: screenWidth * 0.9,
                    height: screenHeight * 0.05,
                    child: CustomButtons(
                      color: const Color.fromARGB(255, 41, 121, 255),
                      text: const Text('Sign Up'),
                      onPressed: signUpUser,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Flexible(
                      child: Container(
                        height: screenHeight * 0.001,
                        width: screenWidth * 0.5,
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                          height: screenHeight * 0.05,
                          width: screenWidth * 0.04,
                          child: const Text("or")),
                    ),
                    Flexible(
                      child: Container(
                        height: screenHeight * 0.001,
                        width: screenWidth * 0.5,
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: screenWidth * 0.8,
                  height: screenHeight * 0.07,
                  child: CustomButtons(
                    border: Border.fromBorderSide(BorderSide(
                        color: const Color.fromARGB(255, 41, 121, 255),
                        width: screenWidth * 0.004)),
                    text: const Text(
                      'Sign Up with Google',
                      style: TextStyle(color: Colors.blue),
                    ),
                    onPressed: () {},
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                SizedBox(
                  width: screenWidth * 0.8,
                  height: screenHeight * 0.07,
                  child: CustomButtons(
                    border: Border.fromBorderSide(
                      BorderSide(
                          color: const Color.fromARGB(255, 41, 121, 255),
                          width: screenWidth * 0.004),
                    ),
                    text: const Text(
                      'Sign Up with Facebook',
                      style: TextStyle(color: Colors.blue),
                    ),
                    onPressed: () {},
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.6,
                  height: screenHeight * 0.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already got an account?"),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return const LoginScreen();
                            }));
                          },
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
