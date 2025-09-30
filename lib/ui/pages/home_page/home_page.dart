import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Creditech")),
      body: SafeArea(
        child: Padding(padding: EdgeInsets.all(8.0), child: Placeholder()),
      ),
    );
  }
}
