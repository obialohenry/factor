import 'package:factor/repository/backend/factors_backend.dart';
import 'package:flutter/foundation.dart';

class TokensAndPrice {
  TokensAndPrice._();
  static final TokensAndPrice _internal = TokensAndPrice._();
  factory TokensAndPrice() => _internal;

  final FactorsBackend _backend = FactorsBackend();

  /// Legacy wrapper that fetches the USD price for a given [tokenId].
  /// Returns the USD price if available, otherwise `null`.
  Future<double?> getTokenPriceInUSD({
    required String tokenId,
    String? tokenName,
  }) async {
    try {
      final tokenPrice = await _backend.getPriceBackend(tokenId);
      return tokenPrice.usdPrice;
    } catch (error, stackTrace) {
      debugPrint(
        'TokensAndPrice price lookup failed for $tokenId ($tokenName): $error',
      );
      debugPrintStack(stackTrace: stackTrace);
      return null;
    }
  }
}
