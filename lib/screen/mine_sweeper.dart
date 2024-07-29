import 'dart:html';
import 'dart:math';

import 'package:flutter/material.dart';

class Minesweeper extends StatefulWidget {
  @override
  _MinesweeperState createState() => _MinesweeperState();
}

class _MinesweeperState extends State<Minesweeper> {
  static const int gridSize = 9;
  static const int numberOfMines = 10;

  late List<List<int>> grid;
  late List<List<bool>> revealed;
  late List<List<bool>> flagged;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    grid = List.generate(gridSize, (i) => List.generate(gridSize, (j) => 0));
    revealed =
        List.generate(gridSize, (i) => List.generate(gridSize, (j) => false));
    flagged =
        List.generate(gridSize, (i) => List.generate(gridSize, (j) => false));

    _placeMines();
    _calculateNumbers();
  }

  void _placeMines() {
    Random random = Random();
    int placedMines = 0;

    while (placedMines < numberOfMines) {
      int x = random.nextInt(gridSize);
      int y = random.nextInt(gridSize);

      if (grid[x][y] == 0) {
        grid[x][y] = -1;
        placedMines++;
      }
    }
  }

  void _calculateNumbers() {
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (grid[i][j] == -1) continue;

        int count = 0;
        for (int dx = -1; dx <= 1; dx++) {
          for (int dy = -1; dy <= 1; dy++) {
            int nx = i + dx;
            int ny = j + dy;

            if (nx >= 0 &&
                nx < gridSize &&
                ny >= 0 &&
                ny < gridSize &&
                grid[nx][ny] == -1) {
              count++;
            }
          }
        }
        grid[i][j] = count;
      }
    }
  }

  void _revealCell(int x, int y) {
    if (x < 0 || x >= gridSize || y < 0 || y >= gridSize || revealed[x][y])
      return;

    setState(() {
      revealed[x][y] = true;
      if (grid[x][y] == -1) {
        _showGameOverDialog();
      } else if (grid[x][y] == 0) {
        for (int dx = -1; dx <= 1; dx++) {
          for (int dy = -1; dy <= 1; dy++) {
            _revealCell(x + dx, y + dy);
          }
        }
      }
    });
  }

  void _toggleFlag(int x, int y) {
    setState(() {
      flagged[x][y] = !flagged[x][y];
    });
  }

  void _showGameOverDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Game Over"),
          content: Text("You hit a mine!"),
          actions: <Widget>[
            TextButton(
              child: Text("Restart"),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _initializeGame();
                });
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildCell(int x, int y) {
    if (revealed[x][y]) {
      if (grid[x][y] == -1) {
        return Container(
          color: Colors.red,
          child: Icon(Icons.bug_report, color: Colors.white),
        );
      } else {
        return Container(
          color: Colors.grey[600],
          child: Center(
            child: Text(grid[x][y] == 0 ? '' : grid[x][y].toString(),
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        );
      }
    } else {
      return GestureDetector(
        onTap: () {
          if (!flagged[x][y]) {
            _revealCell(x, y);
          }
        },
        onLongPress: () {
          _toggleFlag(x, y);
        },
        child: Container(
          color: Colors.grey,
          child: Center(
            child: flagged[x][y] ? Icon(Icons.flag, color: Colors.white) : null,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Game',
            onPressed: () {
              setState(() {
                _initializeGame();
              });
            },
          )
        ],
        title: Text('Minesweeper'),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            width: screenWidth,
            height: screenHeight,
            color: Colors.red,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridSize,
              ),
              itemBuilder: (context, index) {
                int x = index ~/ gridSize;
                int y = index % gridSize;
                return _buildCell(x, y);
              },
              itemCount: gridSize * gridSize,
            ),
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     setState(() {
      //       _initializeGame();
      //     });
      //   },
      //   child: Icon(Icons.refresh),
      // ),
    );
  }
}
