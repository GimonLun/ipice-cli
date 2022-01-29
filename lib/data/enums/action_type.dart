final supportedActionMin = ActionType.uppercase.index;
final supportedActionMax = ActionType.exit.index;

enum ActionType {
  none,
  uppercase,
  lowercase,
  transformByChar,
  generateCsv,
  exit,
}
