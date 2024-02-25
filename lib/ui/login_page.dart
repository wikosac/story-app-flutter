import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:story_app/common/common.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/provider/auth_provider.dart';
import 'package:story_app/data/provider/user_provider.dart';
import 'package:story_app/route/router.dart';
import 'package:story_app/utils/response_state.dart';
import 'package:story_app/utils/utils.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
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
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: _buildForm(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Form _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: emailController,
            decoration: formFieldDecor('Email'),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.emailWarning;
              }
              if (!RegExp(r'^[\w.-]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return AppLocalizations.of(context)!.emailWarning2;
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: passwordController,
            decoration: formFieldDecor('Password'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.passwordWarning;
              }
              if (value.length < 8) {
                return AppLocalizations.of(context)!.passwordWarning2;
              }
              return null;
            },
          ),
          const SizedBox(height: 32.0),
          Consumer2<UserProvider, AuthProvider>(
            builder: (context, user, pref, _) {
              return ElevatedButton(
                onPressed: () {
                  onSubmit(context, user, pref);
                },
                child: user.state == ResponseState.loading
                    ? const CircularProgressIndicator()
                    : Text(AppLocalizations.of(context)!.loginButton),
              );
            },
          ),
          const SizedBox(height: 16.0),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 14),
              children: [
                TextSpan(
                  text: AppLocalizations.of(context)!.loginDescription,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                TextSpan(
                  text: AppLocalizations.of(context)!.here,
                  style: const TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w300,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      context.goNamed(Routes.register);
                    },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onSubmit(
    BuildContext context,
    UserProvider provider,
    AuthProvider auth,
  ) async {
    if (_formKey.currentState!.validate()) {
      if (provider.state == ResponseState.error && context.mounted) {
        showSnackBar(context, AppLocalizations.of(context)!.networkError);
      }
      String email = emailController.text;
      String password = passwordController.text;
      LoginResponse response = await provider.login(email, password);
      if (response.error == false) {
        if (context.mounted) context.goNamed(Routes.navigation);
        LoginResult result = response.loginResult!;
        auth.setCredential(result.token, result.name, email);
      }
      if (context.mounted) showSnackBar(context, response.message);
    }
  }
}
