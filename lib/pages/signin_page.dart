import 'package:firebase_auth_bloc/blocs/signin/signin_cubit.dart';
import 'package:firebase_auth_bloc/pages/signup_page.dart';
import 'package:firebase_auth_bloc/utils/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validators/validators.dart';

class SigninPage extends StatefulWidget {
  static const String routeName = '/signin';
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
  String? _email, _password;

  void _submit() {
    setState(() {
      autoValidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    form.save();
    print('email:$_email, password:$_password');

    context.read<SigninCubit>().signin(_email!, _password!);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: BlocConsumer<SigninCubit, SigninState>(
            listener: (context, state) {
              if (state.signinStatus == SigninStatus.error) {
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
                          shrinkWrap: true,
                          children: [
                            Image.asset(
                              'assets/images/flutter_logo.png',
                              width: 250,
                              height: 250,
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
                            ElevatedButton(
                                onPressed: state.signinStatus ==
                                        SigninStatus.submitting
                                    ? null
                                    : _submit,
                                style: ElevatedButton.styleFrom(
                                    textStyle: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10)),
                                child: Text(state.signinStatus ==
                                        SigninStatus.submitting
                                    ? 'loading...'
                                    : 'Sign in')),
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed:
                                  state.signinStatus == SigninStatus.submitting
                                      ? null
                                      : () {
                                          Navigator.pushNamed(
                                              context, SignupPage.routeName);
                                        },
                              style: TextButton.styleFrom(
                                  textStyle: const TextStyle(
                                      fontSize: 20,
                                      decoration: TextDecoration.underline)),
                              child: const Text('not a member? sign up!'),
                            )
                          ],
                        ),
                      )),
                ),
              );
            },
          )),
    );
  }
}
