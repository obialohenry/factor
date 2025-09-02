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
  Uri get verifiedTagsUri =>
      Uri(scheme: schema, host: host, path: '$tokens/$version/$tag', query: 'verified');
  Uri get lstTagsUri =>
      Uri(scheme: schema, host: host, path: '$tokens/$version/$tag', query: 'lst');
  Uri get topTrendingCategoryUri =>
      Uri(scheme: schema, host: host, path: '$tokens/$version/toptrending/1h');
  Uri get topOrganicScoreCategoryUri =>
      Uri(scheme: schema, host: host, path: '$tokens/$version/toporganicscore/24h');
  Uri get topTradedCategoryUri =>
      Uri(scheme: schema, host: host, path: '$tokens/$version/toptraded/6h');

  ///<------------------------------- Token ends here ----------------------------------->
  ///
  ///<------------------------------- Price begins here ----------------------------------->
  Uri  priceInUSDUri(String id) => Uri(scheme: schema, host: host, path: '$price/$version3',queryParameters: {'ids':id,},);
  ///<------------------------------- Price ends here ----------------------------------->

  Map<String, String> apiHeader = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: '*/*',
  };
}
