import 'dart:async';

import 'package:collection/collection.dart';
import 'package:factor/model/response/fiat_currency_model.dart';
import 'package:factor/model/response/price_response_model.dart';
import 'package:factor/model/response/token_response_model.dart';
import 'package:factor/src/repository.dart';
import 'package:flutter/material.dart';

class ExchangeRateViewModel extends ChangeNotifier {
  ExchangeRateViewModel({
    FactorsBackend? factorsBackend,
    CurrencyBackend? currencyBackend,
  }) : _factorsBackend = factorsBackend ?? FactorsBackend(),
       _currencyBackend = currencyBackend ?? CurrencyBackend();

  final FactorsBackend _factorsBackend;
  final CurrencyBackend _currencyBackend;

  bool _initialized = false;
  bool _loadingTokens = false;
  bool _loadingCurrencies = false;
  bool _loadingPrice = false;
  bool _searchingTokens = false;

  List<TokenResponseModel> _tokens = [];
  List<TokenResponseModel> _filteredTokens = [];
  TokenResponseModel? _selectedToken;

  List<FiatCurrency> _currencies = [];
  List<FiatCurrency> _filteredCurrencies = [];
  FiatCurrency? _selectedCurrency;

  TokenPrice? _tokenPrice;
  DateTime? _priceFetchedAt;
  String? _errorMessage;
  String _tokenQuery = '';
  String _currencyQuery = '';
  String? _ratesLastUpdatedLabel;
  Timer? _tokenSearchDebounce;
  String _lastRemoteTokenQuery = '';

  bool get isInitialized => _initialized;
  bool get tokensLoading => _loadingTokens;
  bool get currenciesLoading => _loadingCurrencies;
  bool get priceLoading => _loadingPrice;
  bool get tokenSearchLoading => _searchingTokens;
  bool get isBusy => _loadingTokens || _loadingCurrencies || _loadingPrice;
  String? get errorMessage => _errorMessage;
  String? get ratesLastUpdatedLabel => _ratesLastUpdatedLabel;

  List<TokenResponseModel> get tokens => List.unmodifiable(_filteredTokens);
  List<FiatCurrency> get currencies => List.unmodifiable(_filteredCurrencies);

  TokenResponseModel? get selectedToken => _selectedToken;
  FiatCurrency? get selectedCurrency => _selectedCurrency;
  TokenPrice? get currentPrice => _tokenPrice;
  DateTime? get priceFetchedAt => _priceFetchedAt;

  double get usdPricePerToken => _tokenPrice?.usdPrice ?? 0;
  double get convertedPricePerToken {
    final rate = _selectedCurrency?.rateToUsd ?? 1;
    return usdPricePerToken * rate;
  }

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    try {
      await Future.wait([_loadCurrencies(), _loadTokens()]);
      _selectedCurrency ??= _currencies.firstWhere(
        (currency) => currency.code == 'USD',
        orElse: () => _currencies.first,
      );
      _filteredCurrencies = List.of(_currencies);
      _selectedToken ??= _tokens.firstWhere(
        (token) => (token.symbol ?? '').toUpperCase() == 'SOL',
        orElse: () => _tokens.first,
      );
      _filteredTokens = List.of(_tokens);
      await refreshPrice();
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
    }
  }

  Future<void> refreshPrice() async {
    final tokenId = _selectedToken?.id;
    if (tokenId == null || tokenId.isEmpty) {
      return;
    }
    _loadingPrice = true;
    notifyListeners();
    try {
      _tokenPrice = await _factorsBackend.getPriceBackend(tokenId);
      _priceFetchedAt = DateTime.now();
      _errorMessage = null;
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _loadingPrice = false;
      notifyListeners();
    }
  }

  Future<void> reloadCatalogue() async {
    await _loadTokens(force: true);
    await refreshPrice();
  }

  void searchTokens(String query) {
    final trimmed = query.trim();
    _tokenQuery = trimmed;
    _tokenSearchDebounce?.cancel();

    if (trimmed.isEmpty) {
      _searchingTokens = false;
      _filteredTokens = List.of(_tokens);
      _lastRemoteTokenQuery = '';
      notifyListeners();
      return;
    }

    final localMatches = _tokens
        .where((token) => token.matchesQuery(trimmed))
        .toList();
    _filteredTokens = localMatches;

    final shouldHitRemote =
        trimmed.length >= 2 && trimmed != _lastRemoteTokenQuery;
    _searchingTokens = shouldHitRemote;
    notifyListeners();

    if (!shouldHitRemote) {
      return;
    }

    final fallback = List<TokenResponseModel>.from(localMatches);
    _tokenSearchDebounce = Timer(const Duration(milliseconds: 320), () {
      _performRemoteTokenSearch(trimmed, fallback);
    });
  }

  void searchCurrencies(String query) {
    _currencyQuery = query;
    if (query.isEmpty) {
      _filteredCurrencies = List.of(_currencies);
    } else {
      final lower = query.toLowerCase();
      _filteredCurrencies = _currencies
          .where(
            (currency) =>
                currency.code.toLowerCase().contains(lower) ||
                currency.name.toLowerCase().contains(lower),
          )
          .toList();
    }
    notifyListeners();
  }

  /// Attempts to select a token. Returns `true` if successful, `false` if price
  /// data is unavailable for this token.
  Future<bool> selectToken(TokenResponseModel token) async {
    final tokenId = token.id;
    if (tokenId == null || tokenId.isEmpty) {
      _errorMessage = 'Invalid token: missing ID';
      notifyListeners();
      return false;
    }

    // First check if price data is available for this token
    _loadingPrice = true;
    notifyListeners();
    
    try {
      final tokenPrice = await _factorsBackend.getPriceBackend(tokenId);
      
      // Price data is available, proceed with selection
      _selectedToken = token;
      _tokenPrice = tokenPrice;
      _priceFetchedAt = DateTime.now();
      _tokenQuery = '';
      _filteredTokens = List.of(_tokens);
      _tokenSearchDebounce?.cancel();
      _searchingTokens = false;
      _errorMessage = null;
      _loadingPrice = false;
      notifyListeners();
      return true;
    } catch (error) {
      // Price data not available - don't change the selected token
      _errorMessage = 'Price unavailable for ${token.symbol ?? 'this token'} - '
          'it may have insufficient liquidity or not be tradable on Jupiter';
      _loadingPrice = false;
      notifyListeners();
      return false;
    }
  }

  void selectCurrency(FiatCurrency currency) {
    _selectedCurrency = currency;
    _currencyQuery = '';
    _filteredCurrencies = List.of(_currencies);
    notifyListeners();
  }

  double convertTokenAmount(String tokenAmountDigits) {
    final amount = double.tryParse(tokenAmountDigits) ?? 0;
    final usdValue = amount * usdPricePerToken;
    final rate = _selectedCurrency?.rateToUsd ?? 1;
    return usdValue * rate;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _tokenSearchDebounce?.cancel();
    super.dispose();
  }

  @visibleForTesting
  void seedData({
    List<TokenResponseModel>? tokens,
    List<FiatCurrency>? currencies,
    TokenResponseModel? selectedToken,
    FiatCurrency? selectedCurrency,
    TokenPrice? price,
    DateTime? priceFetchedAt,
  }) {
    if (tokens != null) {
      _tokens = tokens;
      _filteredTokens = List.of(tokens);
    }
    if (currencies != null) {
      _currencies = currencies;
      _filteredCurrencies = List.of(currencies);
    }
    if (selectedToken != null) {
      _selectedToken = selectedToken;
    }
    if (selectedCurrency != null) {
      _selectedCurrency = selectedCurrency;
    }
    if (price != null) {
      _tokenPrice = price;
    }
    if (priceFetchedAt != null) {
      _priceFetchedAt = priceFetchedAt;
    }
    _initialized = true;
    notifyListeners();
  }

  Future<void> _loadTokens({bool force = false}) async {
    if (_tokens.isNotEmpty && !force) return;
    _loadingTokens = true;
    notifyListeners();
    try {
      final catalogue = await _factorsBackend.fetchTokenCatalogue();
      _tokens = catalogue;
      _filteredTokens = _tokenQuery.isEmpty
          ? List.of(_tokens)
          : _tokens.where((token) => token.matchesQuery(_tokenQuery)).toList();
      _errorMessage = null;
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _loadingTokens = false;
      notifyListeners();
    }
  }

  Future<void> _loadCurrencies() async {
    if (_currencies.isNotEmpty) return;
    _loadingCurrencies = true;
    notifyListeners();
    try {
      final response = await _currencyBackend.getUsdRates();
      final rates = response['rates'];
      if (rates is Map<String, dynamic>) {
        final List<FiatCurrency> parsed = [];
        for (final entry in rates.entries) {
          final code = entry.key.toUpperCase();
          if (!FiatCurrency.supportedCodes.contains(code)) continue;
          final value = entry.value;
          if (value is num) {
            parsed.add(FiatCurrency.fromRatesEntry(code, value));
          }
        }
        parsed.sort((a, b) => a.code.compareTo(b.code));
        _currencies = parsed;
        _filteredCurrencies = _currencyQuery.isEmpty
            ? List.of(_currencies)
            : _currencies
                  .where(
                    (currency) =>
                        currency.code.toLowerCase().contains(
                          _currencyQuery.toLowerCase(),
                        ) ||
                        currency.name.toLowerCase().contains(
                          _currencyQuery.toLowerCase(),
                        ),
                  )
                  .toList();
        _errorMessage = null;
      } else {
        throw UnknownApiException('Currency rates unavailable');
      }
      _ratesLastUpdatedLabel = response['time_last_update_utc'] as String?;
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _loadingCurrencies = false;
      notifyListeners();
    }
  }

  Future<void> _performRemoteTokenSearch(
    String query,
    List<TokenResponseModel> fallback,
  ) async {
    try {
      final remoteResults = await _factorsBackend.searchTokens(query);
      if (_tokenQuery != query) return;

      if (remoteResults.isNotEmpty) {
        _tokens = _mergeTokenCatalogues(_tokens, remoteResults);
        _filteredTokens = remoteResults;
        _lastRemoteTokenQuery = query;
        _errorMessage = null;
      } else {
        _filteredTokens = fallback;
      }
    } catch (error) {
      if (_tokenQuery == query) {
        _filteredTokens = fallback;
        _errorMessage = error.toString();
      }
    } finally {
      if (_tokenQuery == query) {
        _searchingTokens = false;
        notifyListeners();
      }
    }
  }

  List<TokenResponseModel> _mergeTokenCatalogues(
    List<TokenResponseModel> existing,
    List<TokenResponseModel> incoming,
  ) {
    final byId = <String, TokenResponseModel>{};
    for (final token in existing) {
      final id = token.id;
      if (id == null) continue;
      byId[id] = token;
    }
    for (final token in incoming) {
      final id = token.id;
      if (id == null) continue;
      byId[id] = token;
    }

    final merged = byId.values.toList()
      ..sort(
        (a, b) => compareAsciiLowerCaseNatural(a.symbol ?? '', b.symbol ?? ''),
      );
    return merged;
  }
}
