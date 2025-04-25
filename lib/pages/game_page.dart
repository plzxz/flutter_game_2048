import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_game_2048/components/tile.dart';
import 'package:flutter_game_2048/components/itemButton.dart';
import 'package:flutter_game_2048/theme/game_theme.dart';
import 'package:flutter_game_2048/theme/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snow_fall_animation/snow_fall_animation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum SwipeDirection { up, down, left, right }
enum GameActionMode { none, switchTile, removeSimilar }
GameActionMode currentAction = GameActionMode.none;
Tile? firstSelectedTile;

const double moveInterval = .5;

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  GamePageState createState() => GamePageState();
}

class GameState {
  final List<List<Tile>> _previousGrid;
  final SwipeDirection swipe;

  GameState(List<List<Tile>> previousGrid, this.swipe)
    : _previousGrid = previousGrid;

  List<List<Tile>> get previousGrid =>
      _previousGrid
          .map((row) => row.map((tile) => tile.copy()).toList())
          .toList();
}

class GamePageState extends State<GamePage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  List<List<Tile>> grid = List.generate(
    4,
    (y) => List.generate(4, (x) => Tile(x, y, 0)),
  );
  List<GameState> gameStates = [];
  List<Tile> toAdd = [];

  Iterable<Tile> get gridTiles => grid.expand((e) => e);
  Iterable<Tile> get allTiles => [gridTiles, toAdd].expand((e) => e);
  List<List<Tile>> get gridCols =>
      List.generate(4, (x) => List.generate(4, (y) => grid[y][x]));

  late Timer aiTimer;
  int score = 0;
  int points = 0;
  List<int> scoreHistory = [];
  bool isGameOver = false;

    int item_undo = 2;
  int item_switch = 0;
  int item_remove = 0;

  Future<void> updateScore(String username, int score) async {
    final url = Uri.parse('https://2048-api.vercel.app/update-score');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"username": username, "score": score}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update score: ${response.body}');
    }
  }

  void onRestartPressed() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username') ?? '';

    if (username.isNotEmpty) {
      try {
        await updateScore(username, score);
      } catch (e) {
        print('Score update failed: $e');
      }
    }

    setupNewGame();
  }

  @override
  void initState() {
    super.initState();
    loadItems();
    loadPoints();

    controller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          toAdd.forEach((e) => grid[e.y][e.x].value = e.value);
          gridTiles.forEach((t) => t.resetAnimations());
          toAdd.clear();
        });
      }
    });

    setupNewGame();
  }

  @override
  Widget build(BuildContext context) {
    final gameTheme = Theme.of(context).extension<GameTheme>();

    double contentPadding = 16;
    double borderSize = 4;
    double gridSize = MediaQuery.of(context).size.width - contentPadding * 2;
    double tileSize = (gridSize - borderSize * 2) / 4;
    List<Widget> stackItems = [];
    stackItems.addAll(
      gridTiles.map(
        (t) => TileWidget(
          x: tileSize * t.x,
          y: tileSize * t.y,
          key: ValueKey('${t.x}-${t.y}'), //key
          containerSize: tileSize,
          size: tileSize - borderSize * 2,
          color: gameTheme?.gridColor ?? Colors.purple,
          child: const SizedBox(),
        ),
      ),
    );
    stackItems.addAll(
      allTiles.map(
        (tile) => AnimatedBuilder(
          animation: controller,
          builder:
              (context, child) =>
                  tile.animatedValue.value == 0
                      ? SizedBox()
                      : TileWidget(
                        x: tileSize * tile.animatedX.value,
                        y: tileSize * tile.animatedY.value,
                        key: ValueKey(
                          '${tile.x}-${tile.y}-${tile.animatedValue.value}',
                        ), //key
                        containerSize: tileSize,
                        size: (tileSize - borderSize * 2) * tile.size.value,
                        color:
                            gameTheme?.tileColors[tile.animatedValue.value] ??
                            Colors.red,
                        child: GestureDetector(
                          onTap: () => onTileTap(tile),
                          child: Center(
                            child: TileNumber(
                              key: ValueKey(
                                'tile-num-${tile.x}-${tile.y}-${tile.animatedValue.value}',
                              ), //key
                              tile.animatedValue.value,
                            ),
                          ),
                        ),
                      ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(backgroundColor: gameTheme!.appBar),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          if(Provider.of<ThemeProvider>(context).selectTheme == 4)
          SnowFallAnimation(
            config: SnowfallConfig(
              numberOfSnowflakes: 200,
              speed: 1.0,
              useEmoji: true,
              customEmojis: ['❄️', '❅', '❆'],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(contentPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Score: $score",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
                ),
                Swiper(
                  key: const ValueKey('game-swiper'), //key
                  up: () => merge(SwipeDirection.up),
                  down: () => merge(SwipeDirection.down),
                  left: () => merge(SwipeDirection.left),
                  right: () => merge(SwipeDirection.right),
                  child: Stack(
                    children: [
                      Container(
                        height: gridSize,
                        width: gridSize,
                        padding: EdgeInsets.all(borderSize),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(cornerRadius),
                          color: gameTheme.gridBackground,
                        ),
                        child: Stack(children: stackItems),
                      ),
                      if (isGameOver)
                        Positioned.fill(
                          child: Container(
                            alignment: Alignment.center,
                            color: Colors.black.withOpacity(0.4),
                            child: Text(
                              'Game Over',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    offset: Offset(2, 2),
                                    blurRadius: 4,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ItemButton( //undo button
                      icon: Icons.fast_rewind,
                      label: "$item_undo", // show remain used
                      colorButton: gameTheme.activeButton,
                      colorButtonS: gameTheme.inactiveButton,
                      colorIcon: gameTheme.lightText,
                      isDisabled: item_undo == 0,
                      onTap: gameStates.isEmpty || item_undo == 0 ? () {} : () {
                        item_undo--;
                        saveItems();
                        undoMove();
                      },
                      height: 90,
                      width: 90,
                    ),
                    ItemButton( //switch button
                      icon: Icons.loop,
                      label: "$item_switch", // show remain used
                      colorButton: gameTheme.activeButton,
                      colorButtonS: gameTheme.inactiveButton,
                      colorIcon: gameTheme.lightText,
                      isDisabled: item_switch == 0,
                      isHighlighted: currentAction == GameActionMode.switchTile,
                      onTap: item_switch == 0 ? () {} : () {
                        setState(() {
                          currentAction = GameActionMode.switchTile;
                          firstSelectedTile = null;
                        });
                      },
                      height: 90,
                      width: 90,
                    ),
                    ItemButton( //remove button
                      icon: Icons.delete_forever,
                      label: "$item_remove", // show remain used
                      colorButton: gameTheme.activeButton,
                      colorButtonS: gameTheme.inactiveButton,
                      colorIcon: gameTheme.lightText,
                      isDisabled: item_remove == 0,
                      isHighlighted: currentAction == GameActionMode.removeSimilar,
                      onTap: item_remove == 0 ? () {} : () {
                        setState(() {
                          currentAction = GameActionMode.removeSimilar;
                          firstSelectedTile = null;
                        });
                      },
                      height: 90,
                      width: 90,
                    ),
                  ],
                ),
                // BigButton(
                //   // change later
                //   key: const ValueKey('undo-btn'), //key
                //   label: "Undo",
                //   color: gameTheme.inactiveButton, //change
                //   onPressed: gameStates.isEmpty ? () {} : undoMove,
                // ),
                BigButton(
                  // change later
                  key: const ValueKey('restart-btn'), //key
                  label: "Restart",
                  color: gameTheme.actionButton, //change
                  onPressed: onRestartPressed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      item_undo = prefs.getInt('item_undo') ?? 0;
      item_switch = prefs.getInt('item_swap') ?? 0;
      item_remove = prefs.getInt('item_delete') ?? 0;
    });
  }

  Future<void> saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('item_undo', item_undo);
    await prefs.setInt('item_swap', item_switch);
    await prefs.setInt('item_delete', item_remove);
  }

  Future<void> loadPoints() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      points = prefs.getInt('points') ?? 0;
    });
  }

  Future<void> savePointNScore() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('points', points);
    prefs.setInt('score', score);
  }

  void onTileTap(Tile tile) {
    if (tile.value == 0) return;

    if (currentAction == GameActionMode.switchTile) {
      if (firstSelectedTile == null) {
        firstSelectedTile = tile;
      } else {
        if (tile == firstSelectedTile) return;

        //  Save state before switch
        gameStates.add(GameState(
          grid.map((row) => row.map((tile) => tile.copy()).toList()).toList(),
          SwipeDirection.up,
        ));
        scoreHistory.add(score);

        setState(() {
          int temp = tile.value;
          tile.value = firstSelectedTile!.value;
          firstSelectedTile!.value = temp;

          currentAction = GameActionMode.none;
          firstSelectedTile = null;

          item_switch--;
          saveItems(); 
          controller.forward(from: 0); //  Trigger visual update
        });
      }
    } else if (currentAction == GameActionMode.removeSimilar) {
      //  Save state before remove
      gameStates.add(GameState(
        grid.map((row) => row.map((tile) => tile.copy()).toList()).toList(),
        SwipeDirection.up,
      ));
      scoreHistory.add(score);

      setState(() {
        int target = tile.value;
        gridTiles.where((t) => t.value == target).forEach((t) => t.value = 0);

        currentAction = GameActionMode.none;
        firstSelectedTile = null;

        --item_remove;
        saveItems(); 
        controller.forward(from: 0); //  Trigger visual update
      });
    }
  }

  void undoMove() {
    GameState previousState = gameStates.removeLast();
    bool Function() mergeFn;
    switch (previousState.swipe) {
      case SwipeDirection.up:
        mergeFn = mergeUp;
        break;
      case SwipeDirection.down:
        mergeFn = mergeDown;
        break;
      case SwipeDirection.left:
        mergeFn = mergeLeft;
        break;
      case SwipeDirection.right:
        mergeFn = mergeRight;
        break;
    }
    setState(() {
      this.grid = previousState.previousGrid;
      mergeFn();
      score = scoreHistory.removeLast();
      isGameOver = false;
      controller.reverse(from: .99).then((_) {
        setState(() {
          this.grid = previousState.previousGrid;
          gridTiles.forEach((t) => t.resetAnimations());
        });
      });
    });
  }

  void merge(SwipeDirection direction) {
    bool Function() mergeFn;
    switch (direction) {
      case SwipeDirection.up:
        mergeFn = mergeUp;
        break;
      case SwipeDirection.down:
        mergeFn = mergeDown;
        break;
      case SwipeDirection.left:
        mergeFn = mergeLeft;
        break;
      case SwipeDirection.right:
        mergeFn = mergeRight;
        break;
    }

    bool _canMerge(List<List<Tile>> testGrid) {
      for (var row in testGrid) {
        for (int i = 0; i < row.length - 1; i++) {
          if (row[i].value == 0 && row[i + 1].value != 0) return true;
          if (row[i].value != 0 && row[i].value == row[i + 1].value)
            return true;
        }
      }
      return false;
    }

    bool canSwipe() {
      return _canMerge(grid) ||
          _canMerge(grid.map((e) => e.reversed.toList()).toList()) ||
          _canMerge(gridCols) ||
          _canMerge(gridCols.map((e) => e.reversed.toList()).toList());
    }

    List<List<Tile>> gridBeforeSwipe =
        grid.map((row) => row.map((tile) => tile.copy()).toList()).toList();
    setState(() {
      if (mergeFn()) {
        gameStates.add(GameState(gridBeforeSwipe, direction));
        scoreHistory.add(score);
        addNewTiles([2]);
        controller.forward(from: 0);
      }
      if (!canSwipe()) {
        isGameOver = true;
      } else
        isGameOver = false;
    });
  }

  Tile? findNextTile(List<Tile> tiles, int startIndex) {
    for (int k = startIndex + 1; k < tiles.length; k++) {
      if (tiles[k].value != 0) return tiles[k];
    }
    return null;
  }

  bool mergeLeft() => grid.map((e) => mergeTiles(e)).toList().any((e) => e);

  bool mergeRight() =>
      grid.map((e) => mergeTiles(e.reversed.toList())).toList().any((e) => e);

  bool mergeUp() => gridCols.map((e) => mergeTiles(e)).toList().any((e) => e);

  bool mergeDown() => gridCols
      .map((e) => mergeTiles(e.reversed.toList()))
      .toList()
      .any((e) => e);

  bool mergeTiles(List<Tile> tiles) {
    bool didChange = false;
    for (int i = 0; i < tiles.length; i++) {
      for (int j = i; j < tiles.length; j++) {
        if (tiles[j].value != 0) {
          // Tile? mergeTile = tiles
          //     .skip(j + 1)
          //     .firstWhere((t) => t.value != 0, orElse: () => null);
          Tile? mergeTile = findNextTile(tiles, j);
          if (mergeTile != null && mergeTile.value != tiles[j].value) {
            mergeTile = null;
          }
          if (i != j || mergeTile != null) {
            didChange = true;
            int resultValue = tiles[j].value;
            tiles[j].moveTo(controller, tiles[i].x, tiles[i].y);
            if (mergeTile != null) {
              resultValue += mergeTile.value;
              score += resultValue;
              mergeTile.moveTo(controller, tiles[i].x, tiles[i].y);
              mergeTile.bounce(controller);
              mergeTile.changeNumber(controller, resultValue);
              mergeTile.value = 0;
              tiles[j].changeNumber(controller, 0);
            }
            tiles[j].value = 0;
            tiles[i].value = resultValue;
          }
          break;
        }
      }
    }
    return didChange;
  }

  void addNewTiles(List<int> values) {
    List<Tile> empty = gridTiles.where((t) => t.value == 0).toList();
    empty.shuffle();
    for (int i = 0; i < values.length; i++) {
      toAdd.add(Tile(empty[i].x, empty[i].y, values[i])..appear(controller));
    }
  }

  void setupNewGame() {
    setState(() {
      int gainedPoints = score ~/ 10;
      points += gainedPoints;
      savePointNScore();

      gameStates.clear();
      gridTiles.forEach((t) {
        t.value = 0;
        t.resetAnimations();
      });
      toAdd.clear();
      score = 0;
      isGameOver = false;
      scoreHistory.clear();
      addNewTiles([2, 2]);
      controller.forward(from: 0);
    });
  }
}
