import 'package:flutter/material.dart';

import '../model/business_card.dart';
import '../usecase/SearchCardsUseCase.dart';


class SearchCardsPage extends StatefulWidget {
  final List<BusinessCard> allCards;

  const SearchCardsPage({Key? key, required this.allCards}) : super(key: key);

  @override
  State<SearchCardsPage> createState() => _SearchCardsPageState();
}

class _SearchCardsPageState extends State<SearchCardsPage> {
  final _searchUseCase = SearchCardsUseCase();
  List<BusinessCard> _filteredCards = [];

  @override
  void initState() {
    super.initState();
    _filteredCards = widget.allCards; // show all initially
  }

  void _search(String query) {
    setState(() {
      _filteredCards = _searchUseCase(widget.allCards, query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'Search cards...',
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: _search, // 🔎 filter on typing
        ),
      ),
      body: _filteredCards.isEmpty
          ? const Center(child: Text("No matching cards"))
          : ListView.builder(
        itemCount: _filteredCards.length,
        itemBuilder: (context, i) {
          final card = _filteredCards[i];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(card.name.isNotEmpty ? card.name : "No Name"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (card.phone.isNotEmpty) Text("📞 ${card.phone}"),
                  if (card.email.isNotEmpty) Text("✉️ ${card.email}"),
                  if (card.address.isNotEmpty) Text("🏢 ${card.address}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
