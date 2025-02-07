import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class MiniGame extends StatefulWidget {
  const MiniGame({super.key});

  @override
  State<MiniGame> createState() => _MiniGameState();
}

class _MiniGameState extends State<MiniGame> {
  bool finish = true;
  bool isJumping = false;
  bool dinosaur = false;
  double dinoY = 1;
  List<double> obstacleX = [1];
  int score = 0;
  int highScore = 0;
  Timer? game, img, jump;
  late Image _dino1, _dino2, _block;

  @override
  void initState() {
    super.initState();
    _dino1 = Image.asset("assets/images/dinosaur1.png", scale: 1.5);
    _dino2 = Image.asset("assets/images/dinosaur2.png", scale: 1.5);
    _block = Image.asset("assets/images/block.png", scale: 2);
  }

  @override
  void dispose() {
    game?.cancel();
    img?.cancel();
    jump?.cancel();
    super.dispose();
  }

  void gaming() {
    Random random = Random();
    int randomInt = random.nextInt(6);
    int spawn = 0;
    finish = false;
    isJumping = false;
    dinoY = 1;
    obstacleX = [1];
    score = 0;

    game = Timer.periodic(Duration(milliseconds: 20), (timer) {
      if (mounted) {
        setState(() {
          score++;
          spawn++;

          for (var i = 0; i < obstacleX.length; i++) {
            obstacleX[i] -= 0.02;
          }

          if (obstacleX.isNotEmpty && obstacleX[0] < -1) {
            obstacleX.removeAt(0);
          }

          if (checkCollision()) {
            timer.cancel();
            finish = true;
            highScore = score > highScore ? score : highScore;
          }

          if (spawn > 50 + (randomInt*5)) {
            obstacleX.add(1);
            spawn = 0;
            randomInt = random.nextInt(20);
          }
        });
      }
    });

    img = Timer.periodic(Duration(milliseconds: 200), (timer) {
      if (mounted) {
        setState(() {
          dinosaur = !dinosaur;
        });
      }

      if (finish) {
        timer.cancel();
      }
    });
  }

  void jumping() {
    if (isJumping) return;
    isJumping = true;
    double time = 0;
    double initialPos = dinoY;

    jump = Timer.periodic(Duration(milliseconds: 23), (timer) {
      time += 0.03;
      double height = 4 * time * (1 - time);

      if (mounted) {
        setState(() {
          dinoY = initialPos - height;
        });
      }

      if (finish) {
        timer.cancel();
      }

      if (dinoY >= 1) {
        dinoY = 1;
        isJumping = false;
        timer.cancel();
      }
    });
  }

  bool checkCollision() {
    for (var i = 0; i < obstacleX.length; i++) {
      if ((-0.9 < obstacleX[i] && obstacleX[i] < -0.5) && (dinoY >= 0.5)) return true;
    }
    return false;
  }

  Widget startGame() {
    return AnimatedOpacity(
      opacity: finish ? 0.2 : 1.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Stack(
        children: [
          AnimatedContainer(
            alignment: Alignment(-0.7, dinoY),
            duration: Duration(milliseconds: 0),
            child: dinosaur ? _dino1 : _dino2,
          ),
          () {
            return Container();
          }(),
          for (int i = 0; i < obstacleX.length; i++)
            AnimatedContainer(
              alignment: Alignment(obstacleX[i], 1),
              duration: Duration(milliseconds: 0),
              child: _block,
            ),

          // 점수 표시
          Positioned(
            top: 10,
            right: 20,
            child: Text('점수: $score', style: TextStyle(fontSize: 24)),
          ),
        ],
      ),
    );
  }

  Widget finishGame() {
    return AnimatedOpacity(
      opacity: finish ? 1.0 : 0.0,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
      child: finish
          ? AnimatedContainer(
              alignment: Alignment(0, 0),
              duration: Duration(milliseconds: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('점수: $score', style: TextStyle(fontSize: 24)),
                  Text('최고 점수: $highScore', style: TextStyle(fontSize: 17)),
                ],
              ),
            )
          : Container(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 100),
          GestureDetector(
            onTap: () {
              if (finish) {
                gaming();
              } else {
                jumping();
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 200,
                child: Stack(children: [
                  finishGame(),
                  startGame(),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
