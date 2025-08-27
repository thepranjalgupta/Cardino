
import '../model/business_card.dart';

class SearchCardsUseCase {
  List<BusinessCard> call(List<BusinessCard> cards, String query) {
    if (query.isEmpty) return cards;

    final lowerQuery = query.toLowerCase();

    return cards.where((card) {
      return card.name.toLowerCase().contains(lowerQuery) ;
      // ||
          // card.phone.toLowerCase().contains(lowerQuery) ||
          // card.email.toLowerCase().contains(lowerQuery) ||
          // card.address.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}
