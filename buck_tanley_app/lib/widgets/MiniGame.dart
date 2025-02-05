import 'dart:async';

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
  double obstacleX = 1;
  int score = 0;
  int highScore = 0;
  Timer? gameTimer;

  void startGame() {
    finish = false;
    isJumping = false;
    dinoY = 1;
    obstacleX = 1;
    score = 0;

    gameTimer = Timer.periodic(Duration(milliseconds: 30), (timer) {
      setState(() {
        obstacleX -= 0.02; // 장애물 왼쪽으로 이동
        score++;

        if (obstacleX < -1) {
          obstacleX = 1;
        }

        if (checkCollision()) {
          timer.cancel();
          finish = true;
          highScore = score > highScore ? score : highScore;
        }
      });
    });

    Timer.periodic(Duration(milliseconds: 250), (timer) {
      setState(() {
        dinosaur = !dinosaur;
      });

      if (finish) {
        timer.cancel();
      }
    });
  }

  void jump() {
    if (isJumping) return;
    isJumping = true;
    double time = 0;
    double initialPos = dinoY;

    Timer.periodic(Duration(milliseconds: 35), (timer) {
      time += 0.03;
      double height = 4 * time * (1 - time);

      setState(() {
        dinoY = initialPos - height;
      });

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
    return (-0.9 < obstacleX && obstacleX < -0.5) && (dinoY >= 0.5);
  }

  Widget finishGame() {
    return AnimatedOpacity(
      opacity: finish ? 1.0 : 0.0, // 서서히 나타나기
      duration: const Duration(seconds: 1), // 애니메이션 지속 시간
      curve: Curves.easeInOut, // 부드러운 효과
      child: Positioned(
        top: 10,
        right: 20,
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
      ),
    );
  }

  Widget gaming() {
    return AnimatedOpacity(
      opacity: finish ? 0.2 : 1.0, // 서서히 나타나기
      duration: const Duration(milliseconds: 200), // 애니메이션 지속 시간
      curve: Curves.easeInOut, // 부드러운 효과
      child: Stack(
        children: [
          AnimatedContainer(
            alignment: Alignment(-0.7, dinoY),
            duration: Duration(milliseconds: 0),
            child: Image.asset(
              dinosaur ? "assets/images/dinosaur1.png" : "assets/images/dinosaur2.png",
              scale: 1.5,
            ),
          ),

          AnimatedContainer(
            alignment: Alignment(obstacleX, 1),
            duration: Duration(milliseconds: 0),
            child: Image.asset(
              "assets/images/block.png",
              scale: 2,
            ),
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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 100),
          GestureDetector(
            onTap: () {
              if (gameTimer == null || !gameTimer!.isActive || finish) {
                finish = false;
                startGame();
              } else {
                jump();
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
                  gaming(),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
