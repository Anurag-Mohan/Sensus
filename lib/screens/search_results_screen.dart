import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/contact.dart';
import '../models/note.dart';
import '../models/receipt.dart';
import '../models/link.dart';

class SearchResultsScreen extends StatefulWidget {
  final String searchQuery;

  const SearchResultsScreen({super.key, required this.searchQuery});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  List<SearchResult> searchResults = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _performSearch();
  }

  Future<void> _performSearch() async {
    setState(() => isLoading = true);
    
    try {
      final query = widget.searchQuery.toLowerCase();
      List<SearchResult> results = [];

      
      try {
        final contactsBox = Hive.box<Contact>('contacts');
        for (var contact in contactsBox.values) {
          final name = contact.name.toLowerCase();
          final phone = contact.phone?.toLowerCase() ?? '';
          final email = contact.email?.toLowerCase() ?? '';
          
          if (name.contains(query) ||
              phone.contains(query) ||
              email.contains(query)) {
            results.add(SearchResult(
              category: 'Contacts',
              icon: Icons.contacts,
              title: contact.name,
              subtitle: contact.phone ?? contact.email ?? '',
              color: const Color(0xFFFFB3BA),
            ));
          }
        }
      } catch (e) {
        debugPrint('Error searching contacts: $e');
      }

      
      try {
        final notesBox = Hive.box<Note>('notes');
        for (var note in notesBox.values) {
          final title = note.title.toLowerCase();
          final content = note.content.toLowerCase();
          
          if (title.contains(query) || content.contains(query)) {
            results.add(SearchResult(
              category: 'Notes',
              icon: Icons.note,
              title: note.title,
              subtitle: note.content.length > 50 
                  ? '${note.content.substring(0, 50)}...' 
                  : note.content,
              color: const Color(0xFFE4C1F9),
            ));
          }
        }
      } catch (e) {
        debugPrint('Error searching notes: $e');
      }

      
      try {
        final receiptsBox = Hive.box<Receipt>('receipts');
        for (var receipt in receiptsBox.values) {
          final storeName = receipt.storeName.toLowerCase();
          final amount = receipt.amount?.toString() ?? '';
          
          if (storeName.contains(query) || amount.contains(query)) {
            String amountString;
            if (receipt.amount is num) {
              amountString = '\$${(receipt.amount as num).toStringAsFixed(2)}';
            } else {
              amountString = receipt.amount?.toString() ?? '\$0.00';
            }
            
            results.add(SearchResult(
              category: 'Receipts',
              icon: Icons.receipt,
              title: receipt.storeName,
              subtitle: amountString,
              color: const Color(0xFFA8D8EA),
            ));
          }
        }
      } catch (e) {
        debugPrint('Error searching receipts: $e');
      }

      
      try {
        final linksBox = Hive.box<LinkItem>('links');
        for (var link in linksBox.values) {
          final title = link.title.toLowerCase();
          final url = link.url.toLowerCase();
          
          if (title.contains(query) || url.contains(query)) {
            results.add(SearchResult(
              category: 'Links',
              icon: Icons.link,
              title: link.title,
              subtitle: link.url,
              color: const Color(0xFFB4E7CE),
            ));
          }
        }
      } catch (e) {
        debugPrint('Error searching links: $e');
      }

      debugPrint('Total results found: ${results.length}');
      
      setState(() {
        searchResults = results;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error performing search: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCFFFDC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF68BA7F),
        elevation: 0,
        title: Text(
          'Search: "${widget.searchQuery}"',
          style: const TextStyle(
            color: Color(0xFF253D2C),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF253D2C)),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: const Color(0xFF253D2C),
              ),
            )
          : searchResults.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 80,
                        color: const Color(0xFF2E6F40).withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No results found',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF253D2C),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Try searching with different keywords',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF2E6F40),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final result = searchResults[index];
                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(
                          color: const Color(0xFF68BA7F).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: result.color.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            result.icon,
                            color: const Color(0xFF253D2C),
                            size: 28,
                          ),
                        ),
                        title: Text(
                          result.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF253D2C),
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              result.subtitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF2E6F40),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: result.color.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                result.category,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF253D2C),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: const Color(0xFF2E6F40),
                          size: 16,
                        ),
                        onTap: () {
                          
                          _showResultDetails(result);
                        },
                      ),
                    );
                  },
                ),
    );
  }

  void _showResultDetails(SearchResult result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFCFFFDC),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: result.color.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(result.icon, color: const Color(0xFF253D2C)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                result.title,
                style: const TextStyle(
                  color: Color(0xFF253D2C),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: result.color.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                result.category,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF253D2C),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              result.subtitle,
              style: const TextStyle(
                color: Color(0xFF2E6F40),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(
                color: Color(0xFF253D2C),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchResult {
  final String category;
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const SearchResult({
    required this.category,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}