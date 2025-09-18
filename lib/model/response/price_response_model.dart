class PriceResponseModel {
  TokenIDModel? id;

  PriceResponseModel({
    this.id,
  });

  PriceResponseModel copyWith({
    TokenIDModel? id,
  }) {
    return PriceResponseModel(
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }

  factory PriceResponseModel.fromJson(Map<String, dynamic> json) {
    return PriceResponseModel(
      id: json['id'] == null
          ? null
          : TokenIDModel.fromJson(json['id'] as Map<String, dynamic>),
    );
  }

  @override
  String toString() => "PriceResponseModel(id: $id)";

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PriceResponseModel &&
          runtimeType == other.runtimeType &&
          id == other.id;
}

class TokenIDModel {
  double? usdPrice;
  int? blockId;
  int? decimals;
  double? priceChange24h;

  TokenIDModel({
    this.usdPrice,
    this.blockId,
    this.decimals,
    this.priceChange24h,
  });

  TokenIDModel copyWith({
    double? usdPrice,
    int? blockId,
    int? decimals,
    double? priceChange24h,
  }) {
    return TokenIDModel(
      usdPrice: usdPrice ?? this.usdPrice,
      blockId: blockId ?? this.blockId,
      decimals: decimals ?? this.decimals,
      priceChange24h: priceChange24h ?? this.priceChange24h,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usdPrice': usdPrice,
      'blockId': blockId,
      'decimals': decimals,
      'priceChange24h': priceChange24h,
    };
  }

  factory TokenIDModel.fromJson(Map<String, dynamic> json) {
    return TokenIDModel(
      usdPrice: json['usdPrice'] as double?,
      blockId: json['blockId'] as int?,
      decimals: json['decimals'] as int?,
      priceChange24h: json['priceChange24h'] as double?,
    );
  }

  @override
  String toString() =>
      "Id(usdPrice: $usdPrice,blockId: $blockId,decimals: $decimals,priceChange24h: $priceChange24h)";

  @override
  int get hashCode => Object.hash(usdPrice, blockId, decimals, priceChange24h);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TokenIDModel &&
          runtimeType == other.runtimeType &&
          usdPrice == other.usdPrice &&
          blockId == other.blockId &&
          decimals == other.decimals &&
          priceChange24h == other.priceChange24h;
}

