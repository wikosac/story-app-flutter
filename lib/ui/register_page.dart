import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/common/style.dart';
import 'package:story_app/data/model/user.dart';
import 'package:story_app/data/provider/user_provider.dart';
import 'package:story_app/route/router.dart';
import 'package:story_app/utils/response_state.dart';
import 'package:story_app/utils/utils.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final _userData = {'name': '', 'email': '', 'password': ''};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Register',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: lightColorScheme.primary),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: _buildForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Form _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: formFieldDecor('Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
            onChanged: (value) => _userData['name'] = value,
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            decoration: formFieldDecor('Email'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[\w.-]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
            onChanged: (value) => _userData['email'] = value,
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            decoration: formFieldDecor('Password'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 8) {
                return 'Password must be at least 8 characters';
              }
              return null;
            },
            onChanged: (value) => _userData['password'] = value,
          ),
          const SizedBox(height: 32),
          Consumer<UserProvider>(
            builder: (context, provider, _) {
              return ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    User data = User.fromJson(_userData);
                    await provider.registerUser(data).then((response) {
                      if (response.error == false) router.goNamed(Routes.login);
                      showSnackBar(context, response.message);
                    });
                  }
                },
                child: provider.state == ResponseState.loading
                    ? const CircularProgressIndicator()
                    : const Text('Submit'),
              );
            },
          ),
          const SizedBox(height: 16.0),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 14),
              children: [
                const TextSpan(
                  text: 'Already registered? login ',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
                ),
                TextSpan(
                  text: 'here',
                  style: const TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w300
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      router.goNamed(Routes.login);
                    },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
