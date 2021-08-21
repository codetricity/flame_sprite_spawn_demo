import 'package:flame/components.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'dart:ui' as ui;
import 'dart:math';

void main() {
  var game = DragonGame();
  runApp(GameWidget(game: game));
}

int numberDragonsOnScreen = 0;

class DragonGame extends BaseGame with HasTappableComponents {
  late ui.Image backTop;
  ui.Image? dragon;
  bool initialized = false;
  int maxDragonsOnScreen = 12;

  Timer dragonSpawnTimer = Timer(1, repeat: true);

  Random randomX = Random();
  Random randomY = Random();

  @override
  Future<void> onLoad() async {
    super.onLoad();
    var backBottom = await Sprite.load('background_bottom.png');
    add(SpriteComponent(
        sprite: backBottom, position: Vector2(0, 0), size: size));

    // images is from flame Game class
    backTop = await images.load('background_top.png');

    add(SpriteComponent.fromImage(backTop,
        position: Vector2(0, 0), size: size));
    dragon = await images.load('dragon.png');
    dragonSpawnTimer.callback = () {
      print('spawn new dragon');
      numberDragonsOnScreen++;
      Dragon currentDragon = Dragon();
      double yPosition = randomY.nextDouble() * size[1] - 50;
      double dragonSize = (yPosition / 3) > 30 ? yPosition / 3 : 30;

      currentDragon
        ..sprite = Sprite(images.fromCache('dragon.png'))
        ..position = Vector2(size[0] * randomX.nextDouble() - 50, yPosition)
        ..size = Vector2(dragonSize, dragonSize);
      add(currentDragon);
    };
    dragonSpawnTimer.start();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (numberDragonsOnScreen <= maxDragonsOnScreen) {
      dragonSpawnTimer.update(dt);
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}

class Dragon extends SpriteComponent with Tappable {
  @override
  bool onTapDown(TapDownInfo event) {
    try {
      remove();
      numberDragonsOnScreen--;
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}
