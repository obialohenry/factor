class PriceResponseModel {
  PriceResponseModel({required this.entries});

  final Map<String, TokenPrice> entries;

  TokenPrice? operator [](String tokenId) => entries[tokenId];

  factory PriceResponseModel.fromJson(Map<String, dynamic> json) {
    final parsed = <String, TokenPrice>{};
    for (final entry in json.entries) {
      if (entry.value is Map<String, dynamic>) {
        parsed[entry.key] = TokenPrice.fromJson(
          entry.value as Map<String, dynamic>,
        );
      }
    }
    return PriceResponseModel(entries: parsed);
  }
}

class TokenPrice {
  TokenPrice({this.usdPrice, this.blockId, this.decimals, this.priceChange24h});

  final double? usdPrice;
  final int? blockId;
  final int? decimals;
  final double? priceChange24h;

  factory TokenPrice.fromJson(Map<String, dynamic> json) {
    return TokenPrice(
      usdPrice: (json['usdPrice'] as num?)?.toDouble(),
      blockId: (json['blockId'] as num?)?.toInt(),
      decimals: (json['decimals'] as num?)?.toInt(),
      priceChange24h: (json['priceChange24h'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'usdPrice': usdPrice,
    'blockId': blockId,
    'decimals': decimals,
    'priceChange24h': priceChange24h,
  };
}
