import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_project/bloc/auth_bloc_bloc.dart';
import 'package:pos_project/bloc/bloc/user_data_bloc.dart';
import 'package:pos_project/screens/dashboard.dart';
import 'package:pos_project/screens/sign_up_screen.dart';
import 'package:pos_project/widgets/buttons.dart';
import 'package:pos_project/widgets/textfields.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    void signInUser() {
      context.read<AuthBlocBloc>().add(SignInRequestEvent(
          email: emailController.text, password: passwordController.text));
      try {
        final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
        if (uid.isNotEmpty) {
          context.read<UserDataBloc>().add(FetchUserDataEvent(uid: uid));
        }
      } catch (e) {
        print('Error fetching user: ${e.toString()}');
      }
    }

    return BlocBuilder<AuthBlocBloc, AuthBlocState>(
      builder: (context, state) {
        if (state is AuthBlocLoadingState) {
          return const CircularProgressIndicator();
        } else if (state is AuthBlocSuccessState) {
          return const Dashboard();
        } else if (state is AuthBlocErrorState) {
          return const Text('Something went wrong');
        }
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.02, vertical: height * 0.04),
                        child: AnimatedTextKit(
                          animatedTexts: [
                            WavyAnimatedText(
                              'Welcome Back',
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      const Color.fromARGB(255, 41, 121, 255),
                                  fontSize: height * 0.05),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                      child: Text(
                        'Login to your account',
                        style: TextStyle(fontSize: height * 0.02),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.04,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.1,
                  ),
                  child: CustomTextFields(
                      autoFocus: true,
                      textEditingController: emailController,
                      textInputType: TextInputType.emailAddress,
                      obscureText: false,
                      hintText: 'Email'),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                  child: CustomTextFields(
                      autoFocus: true,
                      textEditingController: passwordController,
                      textInputType: TextInputType.text,
                      obscureText: true,
                      hintText: 'Password'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.1, vertical: height * 0.06),
                  child: SizedBox(
                    width: width * 0.9,
                    height: height * 0.05,
                    child: CustomButtons(
                      color: const Color.fromARGB(255, 41, 121, 255),
                      text: const Text('Login'),
                      onPressed: signInUser,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Flexible(
                      child: Container(
                        height: height * 0.001,
                        width: width * 0.5,
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                          height: height * 0.05,
                          width: width * 0.04,
                          child: const Text("or")),
                    ),
                    Flexible(
                      child: Container(
                        height: height * 0.001,
                        width: width * 0.5,
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: width * 0.8,
                  height: height * 0.07,
                  child: CustomButtons(
                    border: Border.fromBorderSide(BorderSide(
                        color: const Color.fromARGB(255, 41, 121, 255),
                        width: width * 0.004)),
                    text: const Text(
                      'Sign In with Google',
                      style: TextStyle(color: Colors.blue),
                    ),
                    onPressed: () {},
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                SizedBox(
                  width: width * 0.8,
                  height: height * 0.07,
                  child: CustomButtons(
                    border: Border.fromBorderSide(
                      BorderSide(
                          color: const Color.fromARGB(255, 41, 121, 255),
                          width: width * 0.004),
                    ),
                    text: const Text(
                      'Sign In with Facebook',
                      style: TextStyle(color: Colors.blue),
                    ),
                    onPressed: () {},
                  ),
                ),
                SizedBox(
                  width: width * 0.6,
                  height: height * 0.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return const SignUpScreen();
                          }));
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
