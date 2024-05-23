import '../model/order.dart';
import 'language_map.dart';

double convertBanglaToDouble(String banglaNumber) {
  String englishNumber = banglaToEnglish(banglaNumber);
  return double.parse(englishNumber);
}

double calculateTotalSum(List<Orders> orders) {
  double sum = 0.0;
  for (var order in orders) {
    String newAmount = order.amount.replaceAll(' টাকা', '');
    sum += convertBanglaToDouble(newAmount) * convertBanglaToDouble(order.quantity);
  }
  sum += 50; // Delivery charge or any additional charges
  return sum;
}

String multiplyBanglaAmounts(String amount, String quantity) {
  double mul = 0.0;
  String newAmount = amount.replaceAll(' টাকা', '');

  mul = convertBanglaToDouble(newAmount) * convertBanglaToDouble(quantity);
  print(mul);

  String englishMul = mul.toStringAsFixed(2); // To keep two decimal places
  return englishToBangla(englishMul);
}
