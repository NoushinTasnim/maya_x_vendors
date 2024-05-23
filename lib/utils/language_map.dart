Map<String, String> banglaToEnglishMap = {
  '০': '0',
  '১': '1',
  '২': '2',
  '৩': '3',
  '৪': '4',
  '৫': '5',
  '৬': '6',
  '৭': '7',
  '৮': '8',
  '৯': '9',
};

Map<String, String> englishToBanglaMap = {
  '0': '০',
  '1': '১',
  '2': '২',
  '3': '৩',
  '4': '৪',
  '5': '৫',
  '6': '৬',
  '7': '৭',
  '8': '৮',
  '9': '৯',
};

String banglaToEnglish(String banglaNumber) {
  return banglaNumber.split('').map((char) => banglaToEnglishMap[char] ?? char).join('');
}

String englishToBangla(String englishNumber) {
  return englishNumber.split('').map((char) => englishToBanglaMap[char] ?? char).join('');
}