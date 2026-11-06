import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart'; //find the necessary directories and files
import 'dart:io'; //used for modifiying , deleting , writing to files

class NewHome extends StatefulWidget {
  const NewHome({super.key});

  @override
  State<NewHome> createState() => _NewHomeState();
}

class _NewHomeState extends State<NewHome> {

  //file manipulation 
  final file = fileCreation();

   TextEditingController textFieldController = TextEditingController();

   String savedContent = '';

  @override
  Widget build(BuildContext context) {
   return Scaffold(
          appBar: AppBar(title : const Text('file system Storage section')),
          body: Column(
            children: [
               const Text('this is the content of journal'),
               const SizedBox(height: 20,),
                TextField(
                controller: textFieldController,
                decoration: InputDecoration(
                    hintText: 'write your journal',
                    border: OutlineInputBorder(),
                ),

               )
            ],
          ),
   );
  }

}

//function to create the directory where we will be storing the files
Future<Directory> getDirectory() async {
  return await getApplicationCacheDirectory();
}

//creating a  file inside that directory 
Future<File> fileCreation() async {
  final directory = await getDirectory();

  return File('$directory.path/file.txt');
}



