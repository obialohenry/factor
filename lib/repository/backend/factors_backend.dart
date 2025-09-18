import 'package:factor/src/repository.dart';

class FactorsBackend extends ApiServices {
  Future<dynamic> getPriceBackend(String id) {
    return get(uri: priceInUSDUri(id),header: apiHeader);
  }
}
