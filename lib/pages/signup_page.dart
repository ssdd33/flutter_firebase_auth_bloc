import 'package:firebase_auth_bloc/blocs/signup/signup_cubit.dart';
import 'package:firebase_auth_bloc/pages/signin_page.dart';
import 'package:firebase_auth_bloc/utils/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validators/validators.dart';

class SignupPage extends StatefulWidget {
  static const String routeName = '/signup';
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
  final _passwordController = TextEditingController();
  String? _email, _password, _name;

  void _submit() {
    setState(() {
      autoValidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    form.save();
    print('email:$_email, password:$_password,name:$_name');

    context.read<SignupCubit>().signup(_email!, _password!, _name!);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<SignupCubit, SignupState>(
          listener: (context, state) {
            if (state.signupStatus == SignupStatus.error) {
              errorDialog(context, state.error);
            }
          },
          builder: (context, state) {
            return Scaffold(
              body: Center(
                child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: autoValidateMode,
                      child: ListView(
                        reverse: true,
                        shrinkWrap: true,
                        children: [
                          Image.asset(
                            'assets/images/flutter_logo.png',
                            width: 250,
                            height: 250,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              filled: true,
                              labelText: 'Name',
                              prefixIcon: Icon(Icons.account_box),
                            ),
                            validator: (String? input) {
                              if (input == null || input.trim().isEmpty) {
                                return 'name is required';
                              }
                              if (input.trim().length < 2) {
                                return 'name must be at least 2 characters long';
                              }

                              return null;
                            },
                            onSaved: (String? input) {
                              _name = input;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              filled: true,
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email),
                            ),
                            validator: (String? input) {
                              if (input == null || input.trim().isEmpty) {
                                return 'email is required';
                              }
                              if (!isEmail(input.trim())) {
                                return 'enter valid email';
                              }
                              return null;
                            },
                            onSaved: (String? email) {
                              _email = email;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                filled: true,
                                labelText: 'Password',
                                prefixIcon: Icon(Icons.lock)),
                            validator: (String? input) {
                              if (input == null || input.trim().isEmpty) {
                                return 'password is required';
                              }
                              if (input.trim().length < 6) {
                                return 'password must be at least 6 characters long';
                              }
                              return null;
                            },
                            onSaved: (String? input) {
                              _password = input;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            obscureText: true,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                filled: true,
                                labelText: 'Password',
                                prefixIcon: Icon(Icons.lock)),
                            validator: (String? input) {
                              if (input != _passwordController.text) {
                                return 'password not match';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                              onPressed:
                                  state.signupStatus == SignupStatus.submitting
                                      ? null
                                      : _submit,
                              style: ElevatedButton.styleFrom(
                                  textStyle: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10)),
                              child: Text(
                                  state.signupStatus == SignupStatus.submitting
                                      ? 'loading...'
                                      : 'Sign up')),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed:
                                state.signupStatus == SignupStatus.submitting
                                    ? null
                                    : () {
                                        Navigator.pushNamed(
                                            context, SigninPage.routeName);
                                      },
                            style: TextButton.styleFrom(
                                textStyle: const TextStyle(
                                    fontSize: 20,
                                    decoration: TextDecoration.underline)),
                            child: const Text('already  member? sign in!'),
                          )
                        ].reversed.toList(),
                      ),
                    )),
              ),
            );
          },
        ));
  }
}
