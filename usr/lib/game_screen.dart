import 'dart:async';
import 'package:flutter/material.dart';
import 'character_painter.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // Stats range from 0.0 to 1.0
  double hunger = 0.8; // 1.0 means full, 0.0 means starving
  double energy = 0.8; // 1.0 means energetic, 0.0 means tired
  double happiness = 0.8; // 1.0 means happy, 0.0 means sad

  Timer? _gameLoop;
  bool _isSleeping = false;

  @override
  void initState() {
    super.initState();
    _startGameLoop();
  }

  @override
  void dispose() {
    _gameLoop?.cancel();
    super.dispose();
  }

  void _startGameLoop() {
    _gameLoop = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        if (_isSleeping) {
          energy = (energy + 0.05).clamp(0.0, 1.0);
          hunger = (hunger - 0.02).clamp(0.0, 1.0);
          if (energy >= 1.0) {
            _isSleeping = false; // Wake up when fully rested
          }
        } else {
          hunger = (hunger - 0.01).clamp(0.0, 1.0);
          energy = (energy - 0.01).clamp(0.0, 1.0);
          happiness = (happiness - 0.015).clamp(0.0, 1.0);
        }
      });
    });
  }

  void _feed() {
    setState(() {
      hunger = (hunger + 0.2).clamp(0.0, 1.0);
      _isSleeping = false;
    });
  }

  void _play() {
    setState(() {
      if (energy > 0.1) {
        happiness = (happiness + 0.2).clamp(0.0, 1.0);
        energy = (energy - 0.1).clamp(0.0, 1.0);
        hunger = (hunger - 0.05).clamp(0.0, 1.0);
        _isSleeping = false;
      }
    });
  }

  void _toggleSleep() {
    setState(() {
      _isSleeping = !_isSleeping;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: const Text('Mi Mascota Virtual'),
        backgroundColor: Colors.pink[100],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          _buildStatusBars(),
          Expanded(
            child: Center(
              child: CustomPaint(
                size: const Size(200, 300),
                painter: CharacterPainter(
                  happiness: happiness,
                  energy: energy,
                  isSleeping: _isSleeping,
                ),
              ),
            ),
          ),
          _buildControls(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildStatusBars() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          _buildBar('Hambre', hunger, Colors.orange),
          const SizedBox(height: 8),
          _buildBar('Energía', energy, Colors.blue),
          const SizedBox(height: 8),
          _buildBar('Felicidad', happiness, Colors.green),
        ],
      ),
    );
  }

  Widget _buildBar(String label, double value, Color color) {
    return Row(
      children: [
        SizedBox(width: 70, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
        Expanded(
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: Colors.grey[300],
            color: color,
            minHeight: 10,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ],
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(Icons.fastfood, 'Comer', _feed),
        _buildActionButton(Icons.sports_soccer, 'Jugar', _play),
        _buildActionButton(
          _isSleeping ? Icons.wb_sunny : Icons.bed, 
          _isSleeping ? 'Despertar' : 'Dormir', 
          _toggleSleep
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onPressed) {
    return Column(
      children: [
        FloatingActionButton(
          onPressed: onPressed,
          backgroundColor: Colors.white,
          child: Icon(icon, color: Colors.pink),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
