import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/const/app_const.dart';
import 'package:whatsapp/features/home/home_page.dart';
import 'package:whatsapp/features/user/presentation/cubit/auth/auth_cubit.dart';
import 'package:whatsapp/features/user/presentation/cubit/credential/credential_cubit.dart';
import 'package:whatsapp/features/user/presentation/pages/initial_profile_submit_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CredentialCubit, CredentialState>(
      listener: (context, state) {
        if (state is CredentialSuccess) {
          BlocProvider.of<AuthCubit>(context).loggedIn();
        }
        if (state is CredentialFailure) {
          toast(state.error);
        }
      },
      builder: (context, state) {
        if (state is CredentialLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is CredentialPhoneAuthProfileInfo) {
          return InitialProfileSubmitPage(email: _emailController.text.trim());
        }
        if (state is CredentialSuccess) {
          return BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is Authenticated) {
                return HomePage(uid: state.uid);
              }
              return _buildLoginForm();
            },
          );
        }
        return _buildLoginForm();
      },
    );
  }

  Widget _buildLoginForm() {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _submitLogin, child: const Text("Login")),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _submitSignup,
              child: const Text("Sign Up"),
            ),
          ],
        ),
      ),
    );
  }

  void _submitLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      toast("Please enter email and password");
      return;
    }

    context.read<CredentialCubit>().submitLogin(
      email: email,
      password: password,
    );
  }

  void _submitSignup() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      toast("Please enter email and password");
      return;
    }

    context.read<CredentialCubit>().submitSignup(
      email: email,
      password: password,
    );
  }
}
