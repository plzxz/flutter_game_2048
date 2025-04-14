import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_game_2048/components/grid.dart';
import 'package:flutter_game_2048/components/tile.dart';

enum SwipeDirection { up, down, left, right }

class GamePage extends StatefulWidget {
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

  @override
  void initState() {
    super.initState();

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
          color: lightBrown,
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
                            numTileColor[tile.animatedValue.value] ??
                            Colors.red,
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
    );

    return Scaffold(
      backgroundColor: tan,
      body: Padding(
        padding: EdgeInsets.all(contentPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Swiper(
              key: const ValueKey('game-swiper'), //key
              up: () => merge(SwipeDirection.up),
              down: () => merge(SwipeDirection.down),
              left: () => merge(SwipeDirection.left),
              right: () => merge(SwipeDirection.right),
              child: Container(
                height: gridSize,
                width: gridSize,
                padding: EdgeInsets.all(borderSize),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(cornerRadius),
                  color: darkBrown,
                ),
                child: Stack(children: stackItems),
              ),
            ),
            BigButton(
              key: const ValueKey('undo-btn'), //key
              label: "Undo",
              color: numColor,
              onPressed: gameStates.isEmpty ? () {} : undoMove,
            ),
            BigButton(
              key: const ValueKey('restart-btn'), //key
              label: "Restart",
              color: orange,
              onPressed: setupNewGame,
            ),
          ],
        ),
      ),
    );
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
    List<List<Tile>> gridBeforeSwipe =
        grid.map((row) => row.map((tile) => tile.copy()).toList()).toList();
    setState(() {
      if (mergeFn()) {
        gameStates.add(GameState(gridBeforeSwipe, direction));
        addNewTiles([2]);
        controller.forward(from: 0);
      }
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
      gameStates.clear();
      gridTiles.forEach((t) {
        t.value = 0;
        t.resetAnimations();
      });
      toAdd.clear();
      addNewTiles([2, 2]);
      controller.forward(from: 0);
    });
  }
}
