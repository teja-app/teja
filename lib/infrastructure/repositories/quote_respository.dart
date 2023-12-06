import 'package:isar/isar.dart';
import 'package:teja/domain/entities/quote_entity.dart';
import 'package:teja/infrastructure/database/isar_collections/quote.dart';

class QuoteRepository {
  final Isar isar;

  QuoteRepository(this.isar);

  Future<List<QuoteEntity>> getAllQuotes() async {
    final quotes = await isar.quotes.where().findAll();
    return quotes.map(toEntity).toList();
  }

  Future<void> addOrUpdateQuotes(List<QuoteEntity> quoteEntities) async {
    await isar.writeTxn(() async {
      for (var entity in quoteEntities) {
        // Check if the quote with the same id already exists
        var existingQuote = await isar.quotes.where().idEqualTo(entity.id).findFirst();

        if (existingQuote != null) {
          // Update existing quote
          existingQuote.author = entity.author;
          existingQuote.source = entity.source;
          existingQuote.text = entity.text;
          existingQuote.tags = entity.tags;
          await isar.quotes.put(existingQuote);
        } else {
          // Insert new quote
          var newQuote = toIsarQuote(entity);
          await isar.quotes.put(newQuote);
        }
      }
    });
  }

  QuoteEntity toEntity(Quote quote) {
    return QuoteEntity(
      id: quote.id,
      author: quote.author,
      source: quote.source,
      text: quote.text,
      tags: quote.tags,
    );
  }

  Quote toIsarQuote(QuoteEntity entity) {
    final quote = Quote()
      ..id = entity.id
      ..author = entity.author
      ..source = entity.source
      ..text = entity.text
      ..tags = entity.tags;
    return quote;
  }

  // Optional: Method to delete quotes
  Future<void> deleteAllQuotes() async {
    await isar.writeTxn(() async {
      await isar.quotes.clear();
    });
  }

  // Optional: Method to fetch a specific quote by ID or other criteria
  Future<QuoteEntity?> getQuoteById(int id) async {
    final quote = await isar.quotes.get(id);
    if (quote != null) {
      return toEntity(quote);
    }
    return null;
  }
}
