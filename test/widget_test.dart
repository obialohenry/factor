import 'package:factor/model/response/fiat_currency_model.dart';
import 'package:factor/model/response/price_response_model.dart';
import 'package:factor/model/response/token_response_model.dart';
import 'package:factor/src/view_model.dart';
import 'package:factor/view/screens/exchange_rate_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('ExchangeRateScreen renders seeded data', (
    WidgetTester tester,
  ) async {
    final viewModel = ExchangeRateViewModel();
    final token = TokenResponseModel(
      id: 'So111',
      name: 'Solana',
      symbol: 'SOL',
    );
    final currency = FiatCurrency(
      code: 'USD',
      name: 'US Dollar',
      symbol: r'$',
      rateToUsd: 1,
    );
    final price = TokenPrice(
      usdPrice: 205.12,
      blockId: 1,
      decimals: 9,
      priceChange24h: 2.1,
    );

    viewModel.seedData(
      tokens: [token],
      currencies: [currency],
      selectedToken: token,
      selectedCurrency: currency,
      price: price,
      priceFetchedAt: DateTime(2025, 10, 14, 12, 00),
    );

    await tester.pumpWidget(
      ChangeNotifierProvider<ExchangeRateViewModel>.value(
        value: viewModel,
        child: const MaterialApp(home: ExchangeRateScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Factor'), findsOneWidget);
    expect(find.textContaining('SOL'), findsWidgets);
    expect(find.textContaining('USD'), findsWidgets);
  });
}
