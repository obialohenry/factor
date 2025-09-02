class TokenResponseModel {
  String? id;
  String? name;
  String? symbol;
  String? icon;
  int? decimals;
  double? circSupply;
  double? totalSupply;
  String? tokenProgram;
  int? ctLikes;
  int? smartCtLikes;
  String? updatedAt;

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
  });

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
    };
  }

  factory TokenResponseModel.fromJson(Map<String, dynamic> json) {
    return TokenResponseModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      symbol: json['symbol'] as String?,
      icon: json['icon'] as String?,
      decimals: json['decimals'] as int?,
      circSupply: json['circSupply'] as double?,
      totalSupply: json['totalSupply'] as double?,
      tokenProgram: json['tokenProgram'] as String?,
      ctLikes: json['ctLikes'] as int?,
      smartCtLikes: json['smartCtLikes'] as int?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  @override
  String toString() =>
      "TokenResponseModel(id: $id,name: $name,symbol: $symbol,icon: $icon,decimals: $decimals,circSupply: $circSupply,totalSupply: $totalSupply,tokenProgram: $tokenProgram,ctLikes: $ctLikes,smartCtLikes: $smartCtLikes,updatedAt: $updatedAt)";

  @override
  int get hashCode => Object.hash(id, name, symbol, icon, decimals, circSupply,
      totalSupply, tokenProgram, ctLikes, smartCtLikes, updatedAt);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TokenResponseModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          symbol == other.symbol &&
          icon == other.icon &&
          decimals == other.decimals &&
          circSupply == other.circSupply &&
          totalSupply == other.totalSupply &&
          tokenProgram == other.tokenProgram &&
          ctLikes == other.ctLikes &&
          smartCtLikes == other.smartCtLikes &&
          updatedAt == other.updatedAt;
}
