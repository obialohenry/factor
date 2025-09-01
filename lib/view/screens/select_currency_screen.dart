import 'package:factor/src/components.dart';
import 'package:factor/src/config.dart';
import 'package:factor/src/view_model.dart';
import 'package:flutter/material.dart';

class SelectCurrencyScreen extends StatefulWidget {
  const SelectCurrencyScreen({super.key});

  @override
  State<SelectCurrencyScreen> createState() => _SelectCurrencyScreenState();
}

class _SelectCurrencyScreenState extends State<SelectCurrencyScreen> {
  final ExchangeRateCalculator _exchangeRateProvider = ExchangeRateCalculator();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFieldsFocus = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFieldsFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FactorColorsDark.kMidnight,
      appBar: PreferredSize(
        preferredSize: Size(0, 40),
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 600),
          transitionBuilder: (child, animation) {
            return ScaleTransition(
              scale: CurvedAnimation(parent: animation, curve: Curves.elasticOut),
              child: child,
            );
          },
          child: _exchangeRateProvider.searchingForACurrency
              ? FactorsAppBars.searchAppBar(
                  context,
                  controller: _searchController,
                  focusNode: _searchFieldsFocus,
                  onCancelTap: () {
                    _exchangeRateProvider.setSearchingForACurrency(false);
                    _searchController.clear();
                    setState(() {});
                  },
                  onTextFieldChange: (value) {
                    if (_searchController.text.isEmpty) {
                      _exchangeRateProvider.setSelectCurrencyScreenInteractionDisabilityStatus(
                        true,
                      );
                    } else if (_searchController.text.isNotEmpty) {
                      _exchangeRateProvider.setSelectCurrencyScreenInteractionDisabilityStatus(
                        false,
                      );
                    }
                    setState(() {});
                  },
                  onCloseIconTap: () {
                    _searchController.clear();
                    _exchangeRateProvider.setSelectCurrencyScreenInteractionDisabilityStatus(true);
                    setState(() {});
                  },
                )
              : FactorsAppBars.selectAppBar(
                  context,
                  title: FactorStrings.hdrSelectCurrency,
                  onSearchOnTap: () {
                    _exchangeRateProvider.setSearchingForACurrency(true);
                    setState(() {});
                  },
                ),
        ),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: 20,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(top: 30, left: 15, right: 15),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: GestureDetector(
                  onTap: () {
                    _exchangeRateProvider.selectACurrency(index);
                    setState(() {});
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextView(
                        text: 'Algerian Dinar DZD',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _exchangeRateProvider.selectedCurrency == index
                                ? FactorColorsDark.kSunsetOrange
                                : FactorColorsDark.kLightGray,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: _exchangeRateProvider.selectedCurrency == index
                            ? Center(
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.elasticOut,
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
          Visibility(
            visible: _exchangeRateProvider.isSelectCurrencyScreenInteractionDisabled,
            child: GestureDetector(
              onTap: () {
                _exchangeRateProvider.setSearchingForACurrency(false);
                setState(() {});
              },
              child: Container(color: FactorColorsDark.kMidnight.withAlpha((0.6 * 255).toInt())),
            ),
          ),
        ]
      ),
    );
  }
}
