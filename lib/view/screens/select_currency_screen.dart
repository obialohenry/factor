import 'package:factor/src/config.dart';
import 'package:flutter/material.dart';

class SelectCurrencyScreen extends StatefulWidget {
  const SelectCurrencyScreen({super.key});

  @override
  State<SelectCurrencyScreen> createState() => _SelectCurrencyScreenState();
}

class _SelectCurrencyScreenState extends State<SelectCurrencyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: FactorColorsDark.kMidnight,
    );
  }
}