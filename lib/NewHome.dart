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

//function to create the directory where we will be storing the files
Future<Directory> getDirectory() async {
  return await getApplicationCacheDirectory();
}

//creating a  file inside that directory 
Future<File> fileCreationAndManipulation() async {
  final directory = await getDirectory();

  return File('$directory.path/file.txt');
}

