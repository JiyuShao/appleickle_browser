import 'dart:math';

late Random rnd = Random();

double getRandomNum(double min, double max) =>
    (rnd.nextDouble() * (max - min + 1)).floor() + min;
