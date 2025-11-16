class TextParser {
  static final _emailRegex = RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b');
  
  
  static final _phoneWithContextRegex = RegExp(
    r'(?:ph(?:one)?|mobile|mob|cell|contact|tel(?:ephone)?|call)\s*:?\s*([+]?91)?[-\s]?(\d{10})',
    caseSensitive: false,
  );
  
  
  static final _standalonePhoneRegex = RegExp(r'\b[6-9]\d{9}\b');

  
  static final _amountPatterns = [
    RegExp(r'(?:grand\s*total|net\s*total|final\s*total)\s*:?\s*₹?\s*(\d+(?:\.\d{2})?)', caseSensitive: false),
    RegExp(r'(?:total|amount\s*payable?)\s*:?\s*₹?\s*(\d+(?:\.\d{2})?)', caseSensitive: false),
    RegExp(r'(?:₹|rs\.?|inr)\s*(\d+(?:\.\d{2})?)', caseSensitive: false),
    RegExp(r'(?:total|amount)\s*:?\s*(\d+(?:\.\d{2})?)', caseSensitive: false),
  ];

  static String? extractEmail(String text) {
    final match = _emailRegex.firstMatch(text);
    return match?.group(0);
  }

  static String? extractPhone(String text) {
    
    final contextMatch = _phoneWithContextRegex.firstMatch(text);
    if (contextMatch != null) {
      final countryCode = contextMatch.group(1) ?? '';
      final number = contextMatch.group(2) ?? '';
      return countryCode.isNotEmpty ? '+$countryCode$number' : number;
    }
    
    
    final standaloneMatch = _standalonePhoneRegex.firstMatch(text);
    if (standaloneMatch != null) {
      final number = standaloneMatch.group(0)!;
      
      final beforeIndex = text.indexOf(number);
      if (beforeIndex > 0) {
        final before = text[beforeIndex - 1];
        if (before.contains(RegExp(r'\d'))) return null; 
      }
      return number;
    }
    
    return null;
  }

  static String? extractAmount(String text) {
    
    for (final pattern in _amountPatterns) {
      final matches = pattern.allMatches(text);
      if (matches.isNotEmpty) {
        
        final amounts = matches.map((m) => double.tryParse(m.group(1) ?? '0') ?? 0).toList();
        amounts.sort((a, b) => b.compareTo(a));
        if (amounts.first > 0) {
          return amounts.first.toStringAsFixed(2);
        }
      }
    }
    return null;
  }

  static bool isReceipt(String text) {
    final lower = text.toLowerCase();
    return lower.contains(RegExp(r'\b(total|amount|receipt|invoice|bill|paid|payment)\b')) ||
           extractAmount(text) != null;
  }

  static bool isContact(String text) {
    return extractPhone(text) != null || extractEmail(text) != null;
  }

  static String extractStoreName(String text) {
    final lines = text.split('\n').where((l) => l.trim().isNotEmpty).toList();
    if (lines.isEmpty) return 'Unknown Store';
    
    
    for (final line in lines.take(3)) {
      if (!RegExp(r'^\d+$').hasMatch(line.trim())) {
        return line.trim();
      }
    }
    return lines.first.trim();
  }

  
  static List<String> extractAllPhones(String text) {
    final phones = <String>[];
    
    
    for (final match in _phoneWithContextRegex.allMatches(text)) {
      final countryCode = match.group(1) ?? '';
      final number = match.group(2) ?? '';
      phones.add(countryCode.isNotEmpty ? '+$countryCode$number' : number);
    }
    
    
    for (final match in _standalonePhoneRegex.allMatches(text)) {
      final number = match.group(0)!;
      if (!phones.contains(number)) phones.add(number);
    }
    
    return phones;
  }

  
  static List<String> extractAllEmails(String text) {
    return _emailRegex.allMatches(text).map((m) => m.group(0)!).toList();
  }
}