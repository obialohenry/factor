import 'package:factor/src/model.dart';
import 'package:factor/src/repository.dart';

class TokensAndPrice {
  TokensAndPrice._();
  static final TokensAndPrice _internal = TokensAndPrice._();
  factory TokensAndPrice() => _internal;

  final factorsService = FactorsBackend();

  TokenIDModel? _token;

  Future<void> getTokenPriceInUSD({required String tokenId, required String tokenName}) async {
    try {
      final response = await factorsService.getPriceBackend(tokenId);

      if (response == null) {
        print("❌ Nullable response");
        return;
      }

      if ((response as Map<String, dynamic>).isEmpty) {
        print("❌ No Data");
        return;
      }
      
      final data = response[tokenId] as Map<String, dynamic>;
      _token = TokenIDModel.fromJson(data);
      print("$tokenName USD price is: ${_token?.usdPrice}");
    } catch (e, s) {
      print("👀 $s");
      print("found it😅: $e");
    }
  }
}
