import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotesPage extends ConsumerWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(body: Center(child: Text('notes page')));
  }
}
