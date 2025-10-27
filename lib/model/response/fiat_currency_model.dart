class FiatCurrency {
  FiatCurrency({
    required this.code,
    required this.name,
    required this.symbol,
    required this.rateToUsd,
  });

  final String code;
  final String name;
  final String symbol;
  final double rateToUsd;

  /// Converts a USD amount to this currency using the stored rate.
  double convertFromUsd(double usdAmount) => usdAmount * rateToUsd;

  /// Converts from this currency back to USD.
  double convertToUsd(double amount) => rateToUsd == 0 ? 0 : amount / rateToUsd;

  static FiatCurrency fromRatesEntry(String code, num rate) {
    final normalizedCode = code.toUpperCase();
    final name = _currencyNames[normalizedCode] ?? normalizedCode;
    final symbol = _currencySymbols[normalizedCode] ?? normalizedCode;
    return FiatCurrency(
      code: normalizedCode,
      name: name,
      symbol: symbol,
      rateToUsd: rate.toDouble(),
    );
  }

  static const List<String> supportedCodes = [
    'USD',
    'EUR',
    'GBP',
    'CAD',
    'AUD',
    'JPY',
    'CNY',
    'SGD',
    'INR',
    'NGN',
    'KES',
    'ZAR',
    'BRL',
    'CHF',
  ];

  static const Map<String, String> _currencyNames = {
    'USD': 'US Dollar',
    'EUR': 'Euro',
    'GBP': 'British Pound',
    'CAD': 'Canadian Dollar',
    'AUD': 'Australian Dollar',
    'JPY': 'Japanese Yen',
    'CNY': 'Chinese Yuan',
    'SGD': 'Singapore Dollar',
    'INR': 'Indian Rupee',
    'NGN': 'Nigerian Naira',
    'KES': 'Kenyan Shilling',
    'ZAR': 'South African Rand',
    'BRL': 'Brazilian Real',
    'CHF': 'Swiss Franc',
  };

  static const Map<String, String> _currencySymbols = {
    'USD': r'$',
    'EUR': '€',
    'GBP': '£',
    'CAD': 'C\$',
    'AUD': 'A\$',
    'JPY': '¥',
    'CNY': '¥',
    'SGD': 'S\$',
    'INR': '₹',
    'NGN': '₦',
    'KES': 'KSh',
    'ZAR': 'R',
    'BRL': 'R\$',
    'CHF': 'CHF',
  };
}
