import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/model/user.dart';
import 'package:story_app/data/provider/user_provider.dart';
import 'package:story_app/utils/response_state.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Register'),
      ),
      body: const RegistrationForm(),
    );
  }
}

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  RegistrationFormState createState() => RegistrationFormState();
}

class RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final _userData = {'name': '', 'email': '', 'password': ''};

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
            onChanged: (value) => _userData['name'] = value,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
            onChanged: (value) => _userData['email'] = value,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
            onChanged: (value) => _userData['password'] = value,
          ),
          Consumer<UserProvider>(
            builder: (context, provider, _) {
              return ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    print('data: $_userData');
                    final user = User.fromJson(_userData);
                    Provider.of<UserProvider>(context, listen: false)
                        .registerUser(user)
                        .then((result) {
                      final snackBar = SnackBar(
                        content: Text(result.message),
                        duration: const Duration(seconds: 3),
                        action: SnackBarAction(
                          label: 'Close',
                          onPressed: () {},
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      print(result);
                    }).catchError((error) {
                      print(error);
                    });
                  }
                },
                child: provider.state == ResponseState.loading
                    ? const CircularProgressIndicator()
                    : const Text('Register'),
              );
            },
          ),
        ],
      ),
    );
  }
}
