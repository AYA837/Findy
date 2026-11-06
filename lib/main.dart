import 'package:flutter/material.dart';
import 'package:hello_ensia/NewHome.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: NewHome(),
                
   );
              
            

     
  }
}
