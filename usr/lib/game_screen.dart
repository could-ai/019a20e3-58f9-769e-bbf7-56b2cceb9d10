import 'dart:math';
import 'package:flutter/material.dart';

enum GameChoice { rock, paper, scissors }

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int playerScore = 0;
  int computerScore = 0;
  GameChoice? playerChoice;
  GameChoice? computerChoice;
  String result = 'Choose your weapon!';

  final Map<GameChoice, IconData> choiceIcons = {
    GameChoice.rock: Icons.gavel,
    GameChoice.paper: Icons.pages,
    GameChoice.scissors: Icons.cut,
  };

  void _play(GameChoice choice) {
    setState(() {
      playerChoice = choice;
      computerChoice = GameChoice.values[Random().nextInt(GameChoice.values.length)];
      _determineWinner();
    });
  }

  void _determineWinner() {
    if (playerChoice == computerChoice) {
      result = "It's a draw!";
    } else if (
      (playerChoice == GameChoice.rock && computerChoice == GameChoice.scissors) ||
      (playerChoice == GameChoice.paper && computerChoice == GameChoice.rock) ||
      (playerChoice == GameChoice.scissors && computerChoice == GameChoice.paper)
    ) {
      result = 'You win!';
      playerScore++;
    } else {
      result = 'You lose!';
      computerScore++;
    }
  }

  void _resetGame() {
    setState(() {
      playerScore = 0;
      computerScore = 0;
      playerChoice = null;
      computerChoice = null;
      result = 'Choose your weapon!';
    });
  }

  Widget _buildChoiceWidget(GameChoice? choice) {
    if (choice == null) {
      return const Icon(Icons.question_mark, size: 80, color: Colors.grey);
    }
    return Icon(choiceIcons[choice], size: 80, color: Colors.blueAccent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rock Paper Scissors'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Score', style: Theme.of(context).textTheme.headlineMedium),
            Text('Player: $playerScore - Computer: $computerScore', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text('You', style: TextStyle(fontSize: 20)),
                    const SizedBox(height: 10),
                    _buildChoiceWidget(playerChoice),
                  ],
                ),
                Column(
                  children: [
                    const Text('Computer', style: TextStyle(fontSize: 20)),
                    const SizedBox(height: 10),
                    _buildChoiceWidget(computerChoice),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40),
            Text(result, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            const Text('Choose one:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: GameChoice.values.map((choice) {
                return ElevatedButton(
                  onPressed: () => _play(choice),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(choiceIcons[choice], size: 40),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 40),
            TextButton.icon(
              onPressed: _resetGame,
              icon: const Icon(Icons.refresh),
              label: const Text('Reset Game'),
            ),
          ],
        ),
      ),
    );
  }
}
