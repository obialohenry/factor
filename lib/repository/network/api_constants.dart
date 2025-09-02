import 'dart:io';

class ApiConstants {
  final String schema = 'https';
  final String host = 'lite-api.jup.ag';
  final String version = 'v2';
  final String version3 = 'v3';
  final String price = 'price';
  final String tokens = 'tokens';
  final String tag = 'tag';

  ///<------------------------------- Token begins here ----------------------------------->
  /// Verified token list
  Uri get verifiedTagsUri => Uri(
    scheme: schema,
    host: host,
    path: '$tokens/$version/$tag',
    queryParameters: {'query': 'verified'},
  );

  /// Liquid Staking Tokens (LSTs) like mSOL, jitoSOL
  Uri get lstTagsUri => Uri(
    scheme: schema,
    host: host,
    path: '$tokens/$version/$tag',
    queryParameters: {'query': 'lst'},
  );

  /// Top trending tokens (1h interval)
  Uri get topTrendingCategoryUri =>
      Uri(scheme: schema, host: host, path: '$tokens/$version/toptrending/1h');

  /// Top organic score tokens (24h interval)
  Uri get topOrganicScoreCategoryUri =>
      Uri(scheme: schema, host: host, path: '$tokens/$version/toporganicscore/24h');

  /// Top traded tokens (6h interval)
  Uri get topTradedCategoryUri =>
      Uri(scheme: schema, host: host, path: '$tokens/$version/toptraded/6h');

  /// Collect all token endpoints in one place
  List<Uri> get allTokenUris => [
    verifiedTagsUri,
    lstTagsUri,
    topTrendingCategoryUri,
    topOrganicScoreCategoryUri,
    topTradedCategoryUri,
  ];

  ///<------------------------------- Token ends here ----------------------------------->
  ///
  ///<------------------------------- Price begins here ----------------------------------->
  /// Returns the price of a token in USDC (treated as USD).
  /// - [id] is the token's mint address (e.g., SOL's mint).
  Uri priceInUSDUri(String id) =>
      Uri(scheme: schema, host: host, path: '$price/$version3', queryParameters: {'ids': id});

  ///<------------------------------- Price ends here ----------------------------------->

  Map<String, String> apiHeader = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: '*/*',
  };
}
