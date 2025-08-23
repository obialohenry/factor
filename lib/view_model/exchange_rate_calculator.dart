class ExchangeRateCalculator {
  ExchangeRateCalculator._();
  static final ExchangeRateCalculator _instance = ExchangeRateCalculator._();
  factory ExchangeRateCalculator() => _instance;

  final List<String> _keyPadValues = ['7', '8', '9', '4', '5', '6', '1', '2', '3', '00', '0', '.'];
  List<String> get keyPadValues => _keyPadValues;
  final List<String> _coinAmountDigits = [];
  List<String> get coinAmountDigits => _coinAmountDigits;
  num _currencyAmount = 0;
  num get currencyAmount => _currencyAmount;
  double _exchangeRateItemFontSize = 32;
  double get exchangeRateItemFontSize => _exchangeRateItemFontSize;
  bool _maximumDigitsReached = false;
  bool get maximumDigitsReached => _maximumDigitsReached;

  ///Method handles keypad tap actions.
  ///When any of the `[clear,delete, and number value keys] is pressed,
  ///It either clears, deletes the last value, or appends the key’s value as a string
  ///to the private `coinAmount` list variable depending on the key pressed.
  void onKeyPressed(String value) {
    if (value == 'clear') {
      _coinAmountDigits.clear();
      _maximumDigitsReached = false;
      return;
    }
    if (value == 'delete') {
      if (_coinAmountDigits.isNotEmpty) {
        _coinAmountDigits.removeLast();
        _maximumDigitsReached = false;
        adjustFontSizeByListLength();
      }
      return;
    }
    if (_coinAmountDigits.length < 15) {
      addDigitToCoinAmount(value);
      adjustFontSizeByListLength();
    } else {
      _maximumDigitsReached = true;
    }
  }

  ///Adds digit from keypad to the coin amount private list variable.
  ///The `.` character cannot be added more than once.
  void addDigitToCoinAmount(String value) {
    if (value == '.' && _coinAmountDigits.contains('.')) return;
    _coinAmountDigits.add(value);
  }

  /// Adjusts the font size of an exchange item based on the length of
  /// the entered coin amount, ensuring responsive scaling and avoiding overflow.
  void adjustFontSizeByListLength() {
    const maxFontSize = 32.0;
    const reductionStartLength = 7;
    const reduceFontSizeBy = 2.0;
    if (_coinAmountDigits.length <= 7) {
      _exchangeRateItemFontSize = maxFontSize;
    } else {
      final reductionAmount = (_coinAmountDigits.length - reductionStartLength) * reduceFontSizeBy;
      _exchangeRateItemFontSize = maxFontSize - reductionAmount;
    }
  }

  /// Converts the entered coin amount into the selected currency
  /// by multiplying the currency rate with the entered coin amount.
  void convertCoinToCurrency(double currencyRate) {}
}
