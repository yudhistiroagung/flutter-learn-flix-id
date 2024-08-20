import 'package:flix_id/presentation/extentions/build_context_extention.dart';
import 'package:flix_id/presentation/misc/methods.dart';
import 'package:flix_id/presentation/providers/router/router_provider.dart';
import 'package:flix_id/presentation/providers/user_data/user_data_provider.dart';
import 'package:flix_id/presentation/widgets/flix_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  Function() login(BuildContext context, WidgetRef ref) {
    return () {
      ref
          .read(userDataProvider.notifier)
          .login(email: "yudhistiro@flixid.com", password: "pass1234");
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(userDataProvider, (previous, next) {
      if (next is AsyncData && next.value != null) {
        return ref.read(routerProvider).goNamed('main');
      }

      if (next is AsyncError) {
        context.showSnackbar(next.error.toString());
      }
    });
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            verticalSpace(100),
            Center(child: Image.asset('assets/flix_logo.png', width: 150)),
            verticalSpace(70),
            FlixtextField(label: "Email", controller: emailController),
            verticalSpace(24),
            FlixtextField(
              label: "Password",
              controller: passwordController,
              obscureText: true,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text("Forgot Password?",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            verticalSpace(24),
            ElevatedButton(
              onPressed: login(context, ref),
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48.0)),
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
