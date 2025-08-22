class ExchangeRateCalculator {
  ExchangeRateCalculator._();
  static final ExchangeRateCalculator _instance = ExchangeRateCalculator._();
  factory ExchangeRateCalculator() => _instance;

  final List<String> _keyPadValues = ['7', '8', '9', '4', '5', '6', '1', '2', '3', '00', '0', '.'];
  List<String> get keyPadValues => _keyPadValues;
  List<String> _coinAmount = [];
  List<String> get coinAmount => _coinAmount;
  num _currencyAmount = 0;
  num get currencyAmount => _currencyAmount;

  ///Method handles keypad tap actions.
  ///When any of the `[clear,delete, and number value keys] is pressed,
  ///It either clears, deletes the last value, or appends the key’s value as a string
  ///to the private `coinAmount` list variable depending on the key pressed.
  void onKeyPressed(String value) {
    if (value == 'clear') {
      _coinAmount.clear();
      return;
    }
    if (value == 'delete') {
      if (_coinAmount.isNotEmpty) {
        _coinAmount.removeLast();
      }
      return;
    }
    _coinAmount.add(value);
  }

  /// Converts the entered coin amount into the selected currency
  /// by multiplying the currency rate with the entered coin amount.
  void convertCoinToCurrency(double currencyRate) {}
}
