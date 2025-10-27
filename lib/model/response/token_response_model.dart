class TokenResponseModel {
  TokenResponseModel({
    this.id,
    this.name,
    this.symbol,
    this.icon,
    this.decimals,
    this.circSupply,
    this.totalSupply,
    this.tokenProgram,
    this.ctLikes,
    this.smartCtLikes,
    this.updatedAt,
    this.tags,
    this.usdPrice,
    this.launchpad,
    this.holderCount,
  });

  final String? id;
  final String? name;
  final String? symbol;
  final String? icon;
  final int? decimals;
  final double? circSupply;
  final double? totalSupply;
  final String? tokenProgram;
  final int? ctLikes;
  final int? smartCtLikes;
  final String? updatedAt;
  final List<String>? tags;
  final double? usdPrice;
  final String? launchpad;
  final int? holderCount;

  TokenResponseModel copyWith({
    String? id,
    String? name,
    String? symbol,
    String? icon,
    int? decimals,
    double? circSupply,
    double? totalSupply,
    String? tokenProgram,
    int? ctLikes,
    int? smartCtLikes,
    String? updatedAt,
    List<String>? tags,
    double? usdPrice,
    String? launchpad,
    int? holderCount,
  }) {
    return TokenResponseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      icon: icon ?? this.icon,
      decimals: decimals ?? this.decimals,
      circSupply: circSupply ?? this.circSupply,
      totalSupply: totalSupply ?? this.totalSupply,
      tokenProgram: tokenProgram ?? this.tokenProgram,
      ctLikes: ctLikes ?? this.ctLikes,
      smartCtLikes: smartCtLikes ?? this.smartCtLikes,
      updatedAt: updatedAt ?? this.updatedAt,
      tags: tags ?? this.tags,
      usdPrice: usdPrice ?? this.usdPrice,
      launchpad: launchpad ?? this.launchpad,
      holderCount: holderCount ?? this.holderCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'symbol': symbol,
      'icon': icon,
      'decimals': decimals,
      'circSupply': circSupply,
      'totalSupply': totalSupply,
      'tokenProgram': tokenProgram,
      'ctLikes': ctLikes,
      'smartCtLikes': smartCtLikes,
      'updatedAt': updatedAt,
      'tags': tags,
      'usdPrice': usdPrice,
      'launchpad': launchpad,
      'holderCount': holderCount,
    };
  }

  factory TokenResponseModel.fromJson(Map<String, dynamic> json) {
    return TokenResponseModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      symbol: json['symbol'] as String?,
      icon: json['icon'] as String?,
      decimals: (json['decimals'] as num?)?.toInt(),
      circSupply: (json['circSupply'] as num?)?.toDouble(),
      totalSupply: (json['totalSupply'] as num?)?.toDouble(),
      tokenProgram: json['tokenProgram'] as String?,
      ctLikes: (json['ctLikes'] as num?)?.toInt(),
      smartCtLikes: (json['smartCtLikes'] as num?)?.toInt(),
      updatedAt: json['updatedAt'] as String?,
      tags: (json['tags'] as List?)?.map((tag) => tag.toString()).toList(),
      usdPrice: (json['usdPrice'] as num?)?.toDouble(),
      launchpad: json['launchpad'] as String?,
      holderCount: (json['holderCount'] as num?)?.toInt(),
    );
  }

  bool matchesQuery(String query) {
    if (query.isEmpty) return true;
    final normalizedQuery = query.toLowerCase();
    final attributes = [name, symbol, id];
    return attributes.whereType<String>().any(
      (value) => value.toLowerCase().contains(normalizedQuery),
    );
  }

  @override
  String toString() =>
      'TokenResponseModel(id: $id, name: $name, symbol: $symbol, icon: $icon, decimals: $decimals, circSupply: $circSupply, totalSupply: $totalSupply, usdPrice: $usdPrice)';

  @override
  int get hashCode => Object.hash(
    id,
    name,
    symbol,
    icon,
    decimals,
    circSupply,
    totalSupply,
    tokenProgram,
    ctLikes,
    smartCtLikes,
    updatedAt,
    usdPrice,
    launchpad,
    holderCount,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is TokenResponseModel &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            symbol == other.symbol;
  }
}
