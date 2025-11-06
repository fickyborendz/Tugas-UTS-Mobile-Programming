import 'package:flutter/material.dart';

class AddNotaPage extends StatelessWidget {
  const AddNotaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Nota'),
      ),
      body: const Center(
        child: Text('Halaman Tambah Nota'),
      ),
    );
  }
}
