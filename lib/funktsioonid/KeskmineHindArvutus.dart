import 'dart:math';

keskmineHindArvutaus(Map<int, dynamic> lulitus) {
  double summa = 0;

  double AVG;

  int hindNr = 0;

  num mod = pow(10.0, 2);

  lulitus.values.forEach((data) {
    summa += data[1];

    hindNr++;
  });

  AVG = summa / hindNr;

  if (hindNr > 0) {
    return ((AVG * mod).round().toDouble() / mod);
  } else {
    return 0;
  }
}
