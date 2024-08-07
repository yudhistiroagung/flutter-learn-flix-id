import 'package:flix_id/presentation/providers/router/router_provider.dart';
import 'package:flix_id/presentation/providers/user_data/user_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

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
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(next.error.toString())));
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
            child: ElevatedButton(
          onPressed: login(context, ref),
          style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48.0)),
          child: const Text("Login"),
        )),
      ),
    );
  }
}
