import 'package:factor/src/components.dart';
import 'package:factor/src/config.dart';
import 'package:factor/src/screens.dart';
import 'package:factor/src/view_model.dart';
import 'package:flutter/material.dart';

class ExchangeRateScreen extends StatefulWidget {
  const ExchangeRateScreen({super.key});

  @override
  State<ExchangeRateScreen> createState() => _ExchangeRateScreenState();
}

class _ExchangeRateScreenState extends State<ExchangeRateScreen> {
  final ExchangeRateCalculator _exchangeRateProvider = ExchangeRateCalculator();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FactorColorsDark.kMidnight,
      appBar: AppBar(
        backgroundColor: FactorColorsDark.kMidnight,
        centerTitle: true,
        title: TextView(
          text: FactorStrings.factor,
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: FactorColorsDark.kSunsetOrange,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///[First half of screen]
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.35,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      ExchangeRateItem(
                        title: 'Solana',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SelectCurrencyScreen()),
                          );
                        },
                        trailing: _exchangeRateProvider.coinAmount.isEmpty
                            ? '0'
                            : _exchangeRateProvider.coinAmount.join(''),
                        highlight: true,
                      ),
                      Gap(24),
                      ExchangeRateItem(
                        title: 'US Dollar USD',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SelectCurrencyScreen()),
                          );
                        },
                        trailing: _exchangeRateProvider.currencyAmount.toString(),
                      ),
                    ],
                  ),
                  TextView(
                    text: 'Data provided by Webull, updated on 8/22/2025, 12:05 AM.',
                    color: FactorColorsDark.kLightGray,
                    fontSize: 12,
                  ),
                ],
              ),
            ),
          ),

          ///[Second half of screen]
          Expanded(
            child: Container(
              color: FactorColorsDark.kGunmetal,
              padding: EdgeInsets.only(right: 24, top: 24, left: 24, bottom: 48),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Wrap(
                      children: _exchangeRateProvider.keyPadValues
                          .map(
                            (value) => Padding(
                              padding: const EdgeInsets.only(right: 64, bottom: 48),
                              child: TextView(
                                text: value,
                                fontSize: 32,
                                onTap: () {
                                  print('🔥🔥 $value');
                                  _exchangeRateProvider.onKeyPressed(value);
                                  setState(() {});
                                },
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  Gap(10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextView(
                        text: FactorStrings.lblClear,
                        fontSize: 32,
                        color: FactorColorsDark.kSunsetOrange,
                        onTap: () {
                          _exchangeRateProvider.onKeyPressed('clear');
                          setState(() {});
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          _exchangeRateProvider.onKeyPressed('delete');
                          setState(() {});
                        },
                        child: Icon(
                          Icons.backspace_outlined,
                          color: FactorColorsDark.kSunsetOrange,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExchangeRateItem extends StatelessWidget {
  /// Creates a widget displaying a currency name on the left,
  /// an forward icon signifying that different currencies can be selected,
  ///  and the corresponding value on the right.
  /// If [highlight] is true, the value is shown with an accent color.
  const ExchangeRateItem({
    super.key,
    required this.onTap,
    required this.title,
    required this.trailing,
    this.highlight = false,
  });
  final VoidCallback onTap;
  final String title;
  final String trailing;
  final bool highlight;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Row(
            children: [
              TextView(text: title, fontSize: 18),
              Gap(10),
              Icon(Icons.arrow_forward_ios, color: FactorColorsDark.kMediumGray, size: 20),
            ],
          ),
        ),
        TextView(
          text: trailing,
          fontSize: 32,
          color: highlight ? FactorColorsDark.kSunsetOrange : null,
        ),
      ],
    );
  }
}
