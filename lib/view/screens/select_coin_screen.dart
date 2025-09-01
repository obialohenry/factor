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
          child: _exchangeRateProvider.searchingForACoin
              ? FactorsAppBars.searchAppBar(
                  context,
                  controller: _searchController,
                  focusNode: _searchFieldsFocus,
                  onCancelTap: () {
                    _exchangeRateProvider.setSearchingForACoin(false);
                    _searchController.clear();
                    setState(() {});
                  },
                  onTextFieldChange: (value) {
                    if (_searchController.text.isEmpty) {
                      _exchangeRateProvider.setSelectCoinScreenInteractionDisabilityStatus(true);
                    } else if (_searchController.text.isNotEmpty) {
                      _exchangeRateProvider.setSelectCoinScreenInteractionDisabilityStatus(false);
                    }
                    setState(() {});
                  },
                  onCloseIconTap: () {
                    _searchController.clear();
                    _exchangeRateProvider.setSelectCoinScreenInteractionDisabilityStatus(true);
                    setState(() {});
                  },
                )
              : FactorsAppBars.selectAppBar(
                  context,
                  title: FactorStrings.hdrSelectCoin,
                  onSearchOnTap: () {
                    _exchangeRateProvider.setSearchingForACoin(true);
                    setState(() {});
                  },
                ),
        ),
      ),
      body: Stack(
        children: [
          ListView.builder(
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
                      TextView(
                        text: 'Algerian Dinar DZD',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
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
            visible: _exchangeRateProvider.isSelectCoinScreenInteractionDisabled,
            child: GestureDetector(
              onTap: () {
                _exchangeRateProvider.setSearchingForACoin(false);
                setState(() {});
              },
              child: Container(color: FactorColorsDark.kMidnight.withAlpha((0.6 * 255).toInt())),
            ),
          ),
        ],
      ),
    );
  }
}
