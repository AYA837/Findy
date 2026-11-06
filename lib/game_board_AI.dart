import 'package:flutter/material.dart';

class GameBoardAI extends StatefulWidget {
  const GameBoardAI({super.key});

  @override
  State<GameBoardAI> createState() => _GameBoardAIState();
}

class _GameBoardAIState extends State<GameBoardAI> {

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Tic Tac Toe Board'),
            const SizedBox(height: 5),
            SizedBox(
              width: 150,
              height: 200,
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                children: [
                  Container(
                    width: 5,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 2,
                      ),
                    ),
                  ),
                  Container(
                    width: 5,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 2,
                      ),
                    ),
                  ),
                  Container(
                    width: 5,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 2,
                      ),
                    ),
                  ),
                  Container(
                    width: 5,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 2,
                      ),
                    ),
                  ),
                  Container(
                    width: 5,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 2,
                      ),
                    ),
                  ),
                  Container(
                    width: 5,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 2,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 2,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 2,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Text('Play Turn: X or O ?'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // redirection logic added here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              child: Container(
                width: 100,
                child: Center(
                  child: const Text(
                    'Reset Game',
                    style: TextStyle(
                      color: Colors.purple,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text('Player X ? O ? is a Winner'),
          ],
        ),
      ),
    );
  }
}