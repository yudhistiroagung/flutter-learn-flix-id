import 'package:flix_id/presentation/providers/router/router_provider.dart';
import 'package:flix_id/presentation/providers/user_data/user_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  Text _renderText(WidgetRef ref) => Text(
      "This is ${ref.watch(userDataProvider).when(data: (data) => data?.name, error: (error, stackTrace) => "", loading: () => "Loading")}");

  ElevatedButton _renderLogout(WidgetRef ref) => ElevatedButton(
        onPressed: () {
          ref.watch(userDataProvider.notifier).logout();
        },
        child: const Text('Logout'),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(userDataProvider, (prev, next) {
      if (prev != null && next is AsyncData && next.value == null) {
        ref.read(routerProvider).goNamed('login');
      }
    });
    return Scaffold(
      appBar: AppBar(title: const Text("Main Page")),
      body: Center(
        child: Column(
          children: [_renderText(ref), _renderLogout(ref)],
        ),
      ),
    );
  }
}
