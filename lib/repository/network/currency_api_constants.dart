class CurrencyApiConstants {
  const CurrencyApiConstants();

  Uri get usdBaseRatesUri =>
      Uri(scheme: 'https', host: 'open.er-api.com', path: '/v6/latest/USD');
}
