import 'dart:math';

int randomNumber(int a, int b) {
  if (a >= b) return a;
  Random random = Random();
  return a + random.nextInt(b - a);
}