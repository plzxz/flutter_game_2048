import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_game_2048/theme/game_theme.dart';

const double cornerRadius = 8.0;
const double moveInterval = .5;

class Tile {
  final int x;
  final int y;

  int value;

  late Animation<double> animatedX;
  late Animation<double> animatedY;
  late Animation<double> size;

  late Animation<int> animatedValue;

  Tile(this.x, this.y, this.value) {
    resetAnimations();
  }

  void resetAnimations() {
    animatedX = AlwaysStoppedAnimation(x.toDouble());
    animatedY = AlwaysStoppedAnimation(y.toDouble());
    size = AlwaysStoppedAnimation(1.0);
    animatedValue = AlwaysStoppedAnimation(value);
  }

  void moveTo(Animation<double> parent, int x, int y) {
    Animation<double> curved = CurvedAnimation(
      parent: parent,
      curve: Interval(0.0, moveInterval),
    );
    animatedX = Tween(
      begin: this.x.toDouble(),
      end: x.toDouble(),
    ).animate(curved);
    animatedY = Tween(
      begin: this.y.toDouble(),
      end: y.toDouble(),
    ).animate(curved);
  }

  void bounce(Animation<double> parent) {
    size = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2), weight: 1.0),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 1.0),
    ]).animate(
      CurvedAnimation(parent: parent, curve: Interval(moveInterval, 1.0)),
    );
  }

  void changeNumber(Animation<double> parent, int newValue) {
    animatedValue = TweenSequence([
      TweenSequenceItem(tween: ConstantTween(value), weight: .01),
      TweenSequenceItem(tween: ConstantTween(newValue), weight: .99),
    ]).animate(
      CurvedAnimation(parent: parent, curve: Interval(moveInterval, 1.0)),
    );
  }

  void appear(Animation<double> parent) {
    size = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: parent, curve: Interval(moveInterval, 1.0)),
    );
  }

  Tile copy() {
    Tile t = Tile(x, y, value);
    t.resetAnimations();
    return t;
  }
}

class TileWidget extends StatelessWidget {
  final double x;
  final double y;
  final double containerSize;
  final double size;
  final Color color;
  final Widget child;

  const TileWidget({
    required Key key,
    required this.x,
    required this.y,
    required this.containerSize,
    required this.size,
    required this.color,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Positioned(
    left: x,
    top: y,
    child: Container(
      width: containerSize,
      height: containerSize,
      child: Center(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(cornerRadius),
            color: color,
          ),
          child: child,
        ),
      ),
    ),
  );
}

class TileNumber extends StatelessWidget {
  final int val;

  const TileNumber(this.val, {required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameTheme = Theme.of(context).extension<GameTheme>();

    final textColor = gameTheme!.textColors[val] ?? Colors.white;
    
    return Text(
      "$val",
      style: TextStyle(
        color: textColor,
        fontSize: val > 512 ? 28 : 35,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class BigButton extends StatelessWidget {
  final String label;
  final Color color;
  final void Function() onPressed;

  const BigButton({
    required Key key,
    required this.label,
    required this.color,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: 400,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cornerRadius),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 34,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class Swiper extends StatelessWidget {
  final Function() up;
  final Function() down;
  final Function() left;
  final Function() right;
  final Widget child;

  const Swiper({
    required Key key,
    required this.up,
    required this.down,
    required this.left,
    required this.right,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
    onVerticalDragEnd: (details) {
      if (details.velocity.pixelsPerSecond.dy < -50) {
        up();
      } else if (details.velocity.pixelsPerSecond.dy > 50) {
        down();
      }
    },
    onHorizontalDragEnd: (details) {
      if (details.velocity.pixelsPerSecond.dx < -50) {
        left();
      } else if (details.velocity.pixelsPerSecond.dx > 50) {
        right();
      }
    },
    child: child,
  );
}
