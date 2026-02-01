import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(const SnakeGameApp());
}

class SnakeGameApp extends StatelessWidget {
  const SnakeGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snake Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1A1A2E),
      ),
      home: const SnakeGame(),
    );
  }
}

class SnakeGame extends StatefulWidget {
  const SnakeGame({super.key});

  @override
  State<SnakeGame> createState() => _SnakeGameState();
}

enum Direction { up, down, left, right }

class _SnakeGameState extends State<SnakeGame> {
  static const int gridSize = 20;
  static const int cellCount = gridSize * gridSize;
  
  List<int> snake = [];
  int food = 0;
  Direction direction = Direction.right;
  Direction nextDirection = Direction.right;
  bool isPlaying = false;
  bool isGameOver = false;
  int score = 0;
  int highScore = 0;
  Timer? gameTimer;
  final FocusNode _focusNode = FocusNode();
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  void _initGame() {
    snake = [gridSize * 10 + 5, gridSize * 10 + 4, gridSize * 10 + 3];
    direction = Direction.right;
    nextDirection = Direction.right;
    score = 0;
    isGameOver = false;
    _spawnFood();
  }

  void _spawnFood() {
    List<int> availableCells = [];
    for (int i = 0; i < cellCount; i++) {
      if (!snake.contains(i)) {
        availableCells.add(i);
      }
    }
    if (availableCells.isNotEmpty) {
      food = availableCells[random.nextInt(availableCells.length)];
    }
  }

  void _startGame() {
    if (isGameOver) {
      _initGame();
    }
    isPlaying = true;
    gameTimer?.cancel();
    gameTimer = Timer.periodic(const Duration(milliseconds: 150), (_) {
      _moveSnake();
    });
    setState(() {});
    _focusNode.requestFocus();
  }

  void _pauseGame() {
    isPlaying = false;
    gameTimer?.cancel();
    setState(() {});
  }

  void _moveSnake() {
    direction = nextDirection;
    
    int head = snake.first;
    int newHead;
    
    int row = head ~/ gridSize;
    int col = head % gridSize;
    
    switch (direction) {
      case Direction.up:
        row = (row - 1 + gridSize) % gridSize;
        break;
      case Direction.down:
        row = (row + 1) % gridSize;
        break;
      case Direction.left:
        col = (col - 1 + gridSize) % gridSize;
        break;
      case Direction.right:
        col = (col + 1) % gridSize;
        break;
    }
    
    newHead = row * gridSize + col;
    
    // Collision with self
    if (snake.contains(newHead)) {
      _gameOver();
      return;
    }
    
    snake.insert(0, newHead);
    
    // Eat food
    if (newHead == food) {
      score += 10;
      if (score > highScore) {
        highScore = score;
      }
      _spawnFood();
    } else {
      snake.removeLast();
    }
    
    setState(() {});
  }

  void _gameOver() {
    isPlaying = false;
    isGameOver = true;
    gameTimer?.cancel();
    setState(() {});
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;
    
    if (!isPlaying && !isGameOver) {
      _startGame();
      return;
    }
    
    if (isGameOver) {
      _startGame();
      return;
    }
    
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowUp:
      case LogicalKeyboardKey.keyW:
        if (direction != Direction.down) {
          nextDirection = Direction.up;
        }
        break;
      case LogicalKeyboardKey.arrowDown:
      case LogicalKeyboardKey.keyS:
        if (direction != Direction.up) {
          nextDirection = Direction.down;
        }
        break;
      case LogicalKeyboardKey.arrowLeft:
      case LogicalKeyboardKey.keyA:
        if (direction != Direction.right) {
          nextDirection = Direction.left;
        }
        break;
      case LogicalKeyboardKey.arrowRight:
      case LogicalKeyboardKey.keyD:
        if (direction != Direction.left) {
          nextDirection = Direction.right;
        }
        break;
      case LogicalKeyboardKey.space:
        if (isPlaying) {
          _pauseGame();
        } else {
          _startGame();
        }
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: _handleKeyEvent,
        child: GestureDetector(
          onTap: () {
            if (!isPlaying) {
              _startGame();
            } else {
              _pauseGame();
            }
          },
          onVerticalDragUpdate: (details) {
            if (details.delta.dy < -5 && direction != Direction.down) {
              nextDirection = Direction.up;
            } else if (details.delta.dy > 5 && direction != Direction.up) {
              nextDirection = Direction.down;
            }
          },
          onHorizontalDragUpdate: (details) {
            if (details.delta.dx < -5 && direction != Direction.right) {
              nextDirection = Direction.left;
            } else if (details.delta.dx > 5 && direction != Direction.left) {
              nextDirection = Direction.right;
            }
          },
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(child: _buildGameBoard()),
                  _buildControls(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SCORE',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                  letterSpacing: 2,
                ),
              ),
              Text(
                '$score',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Text(
            '🐍 SNAKE',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00D9FF),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'HIGH SCORE',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                  letterSpacing: 2,
                ),
              ),
              Text(
                '$highScore',
                style: const TextStyle(
                  color: Color(0xFFFFD700),
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGameBoard() {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0F0F1A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF00D9FF).withOpacity(0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00D9FF).withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Stack(
              children: [
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridSize,
                  ),
                  itemCount: cellCount,
                  itemBuilder: (context, index) {
                    return _buildCell(index);
                  },
                ),
                if (!isPlaying) _buildOverlay(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCell(int index) {
    bool isSnakeHead = snake.isNotEmpty && snake.first == index;
    bool isSnakeBody = snake.contains(index) && !isSnakeHead;
    bool isFood = food == index;
    
    Color cellColor = Colors.transparent;
    BorderRadius? borderRadius;
    
    if (isSnakeHead) {
      cellColor = const Color(0xFF00FF88);
      borderRadius = BorderRadius.circular(4);
    } else if (isSnakeBody) {
      int bodyIndex = snake.indexOf(index);
      double opacity = 1.0 - (bodyIndex / snake.length * 0.5);
      cellColor = Color(0xFF00D9FF).withOpacity(opacity);
      borderRadius = BorderRadius.circular(3);
    } else if (isFood) {
      cellColor = const Color(0xFFFF6B6B);
      borderRadius = BorderRadius.circular(6);
    }
    
    return Container(
      margin: const EdgeInsets.all(0.5),
      decoration: BoxDecoration(
        color: cellColor,
        borderRadius: borderRadius,
        boxShadow: isSnakeHead || isFood
            ? [
                BoxShadow(
                  color: cellColor.withOpacity(0.5),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: isFood
          ? const Center(
              child: Text('🍎', style: TextStyle(fontSize: 10)),
            )
          : null,
    );
  }

  Widget _buildOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isGameOver) ...[
              const Text(
                'GAME OVER',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF6B6B),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Score: $score',
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
            ],
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF00D9FF),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00D9FF).withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Text(
                isGameOver ? 'PLAY AGAIN' : 'START',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Use Arrow Keys / WASD or Swipe',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildControlButton(Icons.arrow_upward, () {
                if (direction != Direction.down) nextDirection = Direction.up;
              }),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildControlButton(Icons.arrow_back, () {
                if (direction != Direction.right) nextDirection = Direction.left;
              }),
              const SizedBox(width: 60),
              _buildControlButton(Icons.arrow_forward, () {
                if (direction != Direction.left) nextDirection = Direction.right;
              }),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildControlButton(Icons.arrow_downward, () {
                if (direction != Direction.up) nextDirection = Direction.down;
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: () {
        if (isPlaying) onPressed();
      },
      child: Container(
        width: 56,
        height: 56,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A4A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF00D9FF).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: const Color(0xFF00D9FF),
          size: 28,
        ),
      ),
    );
  }
}
