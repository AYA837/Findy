import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart'; //find the necessary directories and files
import 'dart:io'; //used for modifiying , deleting , writing to files

class NewHome extends StatefulWidget {
  const NewHome({super.key});

  @override
  State<NewHome> createState() => _NewHomeState();
}

class _NewHomeState extends State<NewHome> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
          appBar: AppBar(title : const Text('file system Storage section')),
   );
  }

}
