import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/provider/user_provider.dart';
import 'package:story_app/route/router.dart';
import 'package:story_app/utils/response_state.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        // color: Colors.white,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/login.svg',
                  height: 300,
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          filled: true,
                          fillColor: Colors.white,
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16.0),
                      TextField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          filled: true,
                          fillColor: Colors.white,
                          border: InputBorder.none,
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 32.0),
                      Consumer<UserProvider>(
                        builder: (context, provider, _) {
                          return ElevatedButton(
                            onPressed: () async {
                              onSubmit(context, provider);
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2.0),
                                ),
                              ),
                            ),
                            child: provider.state == ResponseState.loading
                                ? const CircularProgressIndicator()
                                : const Text('Masuk'),
                          );
                        },
                      ),
                      const SizedBox(height: 16.0),
                      GestureDetector(
                        onTap: () {
                          router.goNamed(Routes.register);
                        },
                        child: const Text('Daftar'),
                      ),
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

  void onSubmit(BuildContext context, UserProvider provider) async {
    String email = emailController.text;
    String password = passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      showSnackBar(context, 'Form tidak boleh kosong');
    } else {
      LoginResponse response = await provider.login(email, password);
      if (response.error == false) {
        router.goNamed(Routes.home);
      }
      if (!context.mounted) return;
      showSnackBar(context, response.message);
    }
  }

  void showSnackBar(BuildContext context, String msg) {
    final message = capitalizeFirstLetter(msg);
    var snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  String capitalizeFirstLetter(String text) {
    return text.substring(0, 1).toUpperCase() + text.substring(1).toLowerCase();
  }
}
