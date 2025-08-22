class ExchangeRateCalculator {
  ExchangeRateCalculator._();
  static final ExchangeRateCalculator _instance = ExchangeRateCalculator._();
  factory ExchangeRateCalculator() => _instance;

  final List<String> _keyPadValues = ['7', '8', '9', '4', '5', '6', '1', '2', '3', '00', '0', '.'];
  List<String> get keyPadValues => _keyPadValues;
  num _coinAmount = 0;
  num get coinAmount => _coinAmount;
  num _currencyAmount = 0;
  num get currencyAmount => _currencyAmount;
}
