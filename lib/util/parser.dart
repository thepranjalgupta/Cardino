// import '../business_card.dart';
//
// BusinessCard parseBusinessCard(String text) {
//   final phoneRegex = RegExp(r'(\+?\d[\d\s\-\(\)]{8,}\d)');
//   final emailRegex = RegExp(r'[\w._%+-]+@[\w.-]+\.\w+');
//
//   final phone = phoneRegex.firstMatch(text)?.group(0) ?? '';
//   final email = emailRegex.firstMatch(text)?.group(0) ?? '';
//
//   final lines = text
//       .split("\n")
//       .map((line) => line.trim())
//       .where((line) => line.isNotEmpty)
//       .toList();
//
//   String name = '';
//   String company = '';
//   String address = '';
//
//   for (var line in lines) {
//     if (line.contains(email) || line.contains(phone)) {
//       continue; // already extracted
//     } else if (line.toUpperCase().contains("PVT") ||
//         line.toUpperCase().contains("LTD") ||
//         line.toUpperCase().contains("MANUFACTURER") ||
//         line.toUpperCase().contains("INC") ||
//         line.toUpperCase().contains("LLP")) {
//       company = line;
//     } else if (name.isEmpty &&
//         !line.contains("@") &&
//         !RegExp(r'\d').hasMatch(line)) {
//       name = line; // first "clean" line without numbers/emails
//     } else {
//       address += line + ", ";
//     }
//   }
//
//   return BusinessCard(
//     id: '',
//     name: name,
//     // company: company,
//     phone: phone,
//     email: email,
//     address: address.trim().replaceAll(RegExp(r',$'), ''),
//     rawText: text,
//   );
// }

// import '../business_card.dart';
//
// BusinessCard parseBusinessCard(String text) {
//   // Regex patterns
//   final phoneRegex = RegExp(r'(\+?\d[\d\s\-\(\)]{8,}\d)');
//   final emailRegex = RegExp(r'[\w._%+-]+@[\w.-]+\.\w+');
//   final websiteRegex = RegExp(r'(https?:\/\/[^\s]+|www\.[^\s]+)', caseSensitive: false);
//
//   // Extract main fields
//   final phone = phoneRegex.firstMatch(text)?.group(0) ?? '';
//   final email = emailRegex.firstMatch(text)?.group(0) ?? '';
//   final website = websiteRegex.firstMatch(text)?.group(0);
//
//   // Split lines and clean them
//   final lines = text
//       .split("\n")
//       .map((line) => line.trim())
//       .where((line) => line.isNotEmpty)
//       .toList();
//
//   String? ownerName;
//   String? company;
//   String address = '';
//
//   for (var line in lines) {
//     if (line.contains(email) || line.contains(phone) || line.contains(website ?? "")) {
//       continue; // already extracted
//     }
//     // Detect company names by keywords or ALL CAPS
//     else if (line.toUpperCase().contains("PVT") ||
//         line.toUpperCase().contains("LTD") ||
//         line.toUpperCase().contains("MANUFACTURER") ||
//         line.toUpperCase().contains("INC") ||
//         line.toUpperCase().contains("LLP") ||
//         (line == line.toUpperCase() && line.length > 3)) {
//       company = line;
//     }
//     // Likely owner name (first valid human name line)
//     else if (ownerName == null &&
//         !line.contains("@") &&
//         !RegExp(r'\d').hasMatch(line) &&
//         line.split(" ").length <= 4) {
//       ownerName = line;
//     }
//     else {
//       address += line + ", ";
//     }
//   }
//
//   return BusinessCard(
//     id: '',
//     name: company ?? ownerName ?? '',  // fallback if no company found
//     phone: phone,
//     email: email,
//     address: address.trim().replaceAll(RegExp(r',$'), ''),
//     rawText: text,
//     ownerName: ownerName,
//     website: website,
//   );
// }



// import '../business_card.dart';
//
// bool looksLikeName(String line) {
//   // Must only contain alphabets & spaces (no numbers, no @, no www)
//   if (!RegExp(r'^[A-Za-z\s]+$').hasMatch(line)) return false;
//
//   // Should be 2–4 words (first + last, maybe middle, maybe title)
//   final wordCount = line.trim().split(RegExp(r'\s+')).length;
//   if (wordCount < 1 || wordCount > 4) return false;
//
//   // Avoid job titles
//   final jobKeywords = ["FOUNDER", "CEO", "MANAGER", "DIRECTOR", "OWNER", "PARTNER"];
//   if (jobKeywords.any((kw) => line.toUpperCase().contains(kw))) return false;
//
//   return true;
// }
//
// BusinessCard parseBusinessCard(String text) {
//   final phoneRegex = RegExp(r'(\+?\d[\d\s\-\(\)]{7,}\d)');
//   final emailRegex = RegExp(r'[\w._%+-]+@[\w.-]+\.\w+');
//   final websiteRegex = RegExp(r'(https?:\/\/[^\s]+|www\.[^\s]+)', caseSensitive: false);
//
//   final phones = phoneRegex.allMatches(text).map((m) => m.group(0)!.trim()).toList();
//   final email = emailRegex.firstMatch(text)?.group(0) ?? '';
//   final website = websiteRegex.firstMatch(text)?.group(0);
//
//   final lines = text
//       .split("\n")
//       .map((line) => line.trim())
//       .where((line) => line.isNotEmpty)
//       .toList();
//
//   String? ownerName;
//   String? company;
//   String address = '';
//
//   for (var line in lines) {
//     // Skip if it's phone/email/website
//     if (phones.any((p) => line.contains(p)) ||
//         line.contains(email) ||
//         (website != null && line.contains(website))) {
//       continue;
//     }
//
//     // Detect company
//     if (company == null &&
//         (line.toUpperCase().contains("PVT") ||
//             line.toUpperCase().contains("LTD") ||
//             line.toUpperCase().contains("INC") ||
//             line.toUpperCase().contains("LLP") ||
//             line.toUpperCase().contains("COMPANY") ||
//             (line == line.toUpperCase() && line.length > 3))) {
//       company = line;
//     }
//
//     // Detect name (strictly characters only)
//     else if (ownerName == null && looksLikeName(line)) {
//       ownerName = line;
//     }
//
//     // Otherwise → assume it's part of address
//     else {
//       address += line + ", ";
//     }
//   }
//
//   return BusinessCard(
//     id: '',
//     name: company ?? ownerName ?? '',  // show company first, fallback to person
//     phone: phones.isNotEmpty ? phones.first : '',
//     email: email,
//     website: website,
//     address: address.trim().replaceAll(RegExp(r',$'), ''),
//     rawText: text,
//     ownerName: ownerName,
//   );
// }



import '../model/business_card.dart';

BusinessCard parseBusinessCard(String text) {
  // --- Regex patterns ---
  final phoneRegex = RegExp(r'(\+?\d[\d\s\-\(\)]{7,}\d)');
  final emailRegex = RegExp(r'[\w._%+-]+@[\w.-]+\.\w+');
  final websiteRegex = RegExp(r'((https?:\/\/)?(www\.)?[a-zA-Z0-9\-]+\.[a-zA-Z]{2,}(\S*)?)');

  // --- Extract matches ---
  final phones = phoneRegex.allMatches(text).map((m) => m.group(0) ?? '').toSet().toList();
  final emails = emailRegex.allMatches(text).map((m) => m.group(0) ?? '').toSet().toList();
  final websites = websiteRegex.allMatches(text).map((m) => m.group(0) ?? '').toSet().toList();

  // --- Clean lines ---
  final lines = text
      .split("\n")
      .map((l) => l.trim())
      .where((l) => l.isNotEmpty)
      .toList();

  String? ownerName;
  String? company;
  String address = "";

  // Scoring system
  for (var line in lines) {
    if (phones.any((p) => line.contains(p)) ||
        emails.any((e) => line.contains(e)) ||
        websites.any((w) => line.contains(w))) {
      continue; // skip classified
    }

    // Company → ALL CAPS or contains company keywords
    if (company == null &&
        (line == line.toUpperCase() && line.length > 3 ||
            line.contains("PVT") ||
            line.contains("LTD") ||
            line.contains("LLP") ||
            line.contains("INC") ||
            line.contains("CORP") ||
            line.contains("COMPANY") ||
            line.contains("ENTERPRISES"))) {
      company = line;
    }

    // Owner name → 2–3 words, starts with capitals, no digits
    else if (ownerName == null &&
        !RegExp(r'\d').hasMatch(line) &&
        !line.contains("@") &&
        line.split(" ").length <= 4 &&
        RegExp(r'^[A-Z][a-zA-Z]+(\s+[A-Z][a-zA-Z]+)*$').hasMatch(line)) {
      ownerName = line;
    }

    // Address → fallback
    else {
      address += line + ", ";
    }
  }

  return BusinessCard(
    id: '',
    name: company ?? ownerName ?? (lines.isNotEmpty ? lines.first : ""),
    ownerName: ownerName,
    phone: phones.isNotEmpty ? phones.join(", ") : "",
    email: emails.isNotEmpty ? emails.first : "",
    website: websites.isNotEmpty ? websites.first : null,
    address: address.trim().replaceAll(RegExp(r',$'), ''),
    rawText: text,
  );
}

