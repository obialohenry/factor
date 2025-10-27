import 'package:factor/repository/network/currency_api_constants.dart';
import 'package:factor/src/repository.dart';

class CurrencyBackend extends ApiServices {
  CurrencyBackend() : _constants = const CurrencyApiConstants();

  final CurrencyApiConstants _constants;

  Future<Map<String, dynamic>> getUsdRates() async {
    final response = await get(uri: _constants.usdBaseRatesUri);
    if (response is Map<String, dynamic>) {
      return response;
    }
    throw UnknownApiException('Unexpected response from currency service');
  }
}
