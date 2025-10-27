import 'package:factor/model/response/token_response_model.dart';
import 'package:factor/src/config.dart';
import 'package:factor/src/view_model.dart';
import 'package:factor/view/components/neumorphic_bottom_sheet.dart';
import 'package:factor/view/components/neumorphic_selector.dart';
import 'package:factor/view/components/token_avatar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectCoinScreen extends StatefulWidget {
  const SelectCoinScreen({super.key});

  @override
  State<SelectCoinScreen> createState() => _SelectCoinScreenState();
}

class _SelectCoinScreenState extends State<SelectCoinScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onQueryChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onQueryChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onQueryChanged() {
    context.read<ExchangeRateViewModel>().searchTokens(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ExchangeRateViewModel>();
    final tokens = viewModel.tokens;
    final isInitialLoading = viewModel.tokensLoading && tokens.isEmpty;
    final isSearching = viewModel.tokenSearchLoading;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        0,
        24,
        0, 
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const NeumorphicSheetHandle(),
          Text(
            FactorStrings.hdrSelectCoin,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _searchController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: FactorStrings.hintSearch,
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () => _searchController.clear(),
                      icon: const Icon(Icons.close_rounded),
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 20),
          if (isSearching)
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: LinearProgressIndicator(minHeight: 2),
            ),
          Expanded(
            child: isInitialLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: tokens.length,
                    itemBuilder: (context, index) {
                      final token = tokens[index];
                      final subtitle = _buildSubtitle(token);
                      return Padding(
                        padding: const EdgeInsets.only(right: 4, left: 4),
                        child: NeumorphicSelectorTile(
                          title: token.symbol?.toUpperCase() ?? '--',
                          subtitle: subtitle.isEmpty ? null : subtitle,
                          leading: TokenAvatar(
                            imageUrl: token.icon,
                            symbol: token.symbol,
                            size: 40,
                          ),
                          isSelected: token.id == viewModel.selectedToken?.id,
                          trailing: token.id == viewModel.selectedToken?.id
                              ? Icon(
                                  Icons.check_circle,
                                  color: Theme.of(context).colorScheme.primary,
                                )
                              : null,
                          onTap: () async {
                            final success = await viewModel.selectToken(token);
                            if (success && context.mounted) {
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

String _buildSubtitle(TokenResponseModel token) {
  final parts = <String>[];
  if (token.name != null && token.name!.isNotEmpty) {
    parts.add(token.name!);
  }
  if (token.id != null && token.id!.isNotEmpty) {
    parts.add(token.id!);
  }
  return parts.join(' • ');
}
