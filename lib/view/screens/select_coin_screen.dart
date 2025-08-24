import 'package:factor/src/components.dart';
import 'package:factor/src/config.dart';
import 'package:factor/src/view_model.dart';
import 'package:flutter/material.dart';

class SelectCoinScreen extends StatefulWidget {
  const SelectCoinScreen({super.key});

  @override
  State<SelectCoinScreen> createState() => _SelectCoinScreenState();
}

class _SelectCoinScreenState extends State<SelectCoinScreen> {
  final ExchangeRateCalculator _exchangeRateProvider = ExchangeRateCalculator();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FactorColorsDark.kMidnight,
      appBar: AppBar(
        backgroundColor: FactorColorsDark.kMidnight,
        leadingWidth: 200,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back_sharp, color: FactorColorsDark.kSoftWhite, size: 25),
              ),
              Gap(20),
              TextView(
                text: FactorStrings.hdrSelectCoin,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsetsGeometry.only(right: 15),
            child: Icon(Icons.search_rounded, color: FactorColorsDark.kSoftWhite, size: 28),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 5,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(top: 30, left: 15, right: 15),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: GestureDetector(
              onTap: () {
                _exchangeRateProvider.selectACoin(index);
                setState(() {});
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextView(text: 'Algerian Dinar DZD', fontSize: 18, fontWeight: FontWeight.w500),
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _exchangeRateProvider.selectedCoin == index
                            ? FactorColorsDark.kSunsetOrange
                            : FactorColorsDark.kLightGray,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: _exchangeRateProvider.selectedCoin == index
                        ? Center(
                            child: Container(
                              height: 12,
                              width: 12,
                              decoration: BoxDecoration(
                                color: FactorColorsDark.kSunsetOrange,
                                shape: BoxShape.circle,
                              ),
                            ),
                          )
                        : null,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
