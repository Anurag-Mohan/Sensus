# Sensus

<div align="center">

![Sensus Logo](https://img.shields.io/badge/Sensus-Smart%20Capture-68BA7F?style=for-the-badge)

**Intelligent Document Scanning and Organization**

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey)](https://github.com)

[Features](#features) • [Installation](#installation) • [Usage](#usage) • [Tech Stack](#tech-stack) • [Contributing](#contributing)

</div>

---

## Screenshots

<div align="center">

<img src="screenshots/home.png" width="250" alt="Home Screen"/> <img src="screenshots/notes.png" width="250" alt="Notes Screen"/> <img src="screenshots/contacts.png" width="250" alt="Contacts Screen"/>

<img src="screenshots/links.png" width="250" alt="Links Screen"/> <img src="screenshots/receipts.png" width="250" alt="Receipts Screen"/> <img src="screenshots/scan.png" width="250" alt="Scan Screen"/>

</div>

---

## About Sensus

Sensus is a powerful multi-purpose document scanning and organization application built with Flutter. Using advanced OCR (Optical Character Recognition) technology, Sensus automatically extracts text from images and intelligently categorizes them into contacts, receipts, notes, and links—streamlining document management workflows.

### Key Capabilities

- **Smart Scanning** - Camera-based document capture with real-time preview
- **Intelligent Recognition** - Automatic document type detection using ML
- **Auto-Organization** - Seamless categorization into structured data types
- **Universal Search** - Cross-category search functionality
- **Offline-First Architecture** - Complete functionality without internet connectivity
- **Modern UI** - Clean, intuitive interface following Material Design principles

---

## Features

### Document Scanning
- Real-time camera preview with document frame overlay
- Gallery import and direct camera capture support
- Live OCR processing powered by Google ML Kit
- Automatic document classification

### Data Categorization

#### Contacts Management
- Automatic extraction of phone numbers and email addresses
- One-tap calling functionality
- Card-based UI with contact initials
- Edit and delete operations with confirmation dialogs

#### Receipt Archive
- Automatic store name and amount extraction
- Full receipt text preservation
- Chronological organization
- Searchable receipt database

#### Notes Collection
- Title and content organization
- Timeline visualization with date stamps
- Alternating card layout
- Full-text search capability

#### Link Bookmarks
- URL detection and validation
- Title-based organization
- Direct browser integration
- Link management interface

### Global Search
- Cross-category search across all data types
- Color-coded results by category
- Real-time filtering
- Detailed result preview modals

---

## Installation

### Prerequisites
- Flutter SDK (3.0 or higher)
- Dart SDK
- Android Studio or Xcode
- Android device/emulator or iOS device/simulator

### Setup Instructions

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/sensus.git
   cd sensus
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

### Build for Production

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

---

## Usage

1. Launch Sensus and grant necessary permissions (camera, storage)
2. Navigate to the Scan tab and tap the scan button
3. Select input source: Camera or Gallery
4. Wait for OCR processing to complete
5. Review and edit the extracted information in the dialog
6. Save the data - automatic categorization will be applied
7. Access organized data through the bottom navigation tabs
8. Use the search tab to find data across all categories

---

## Tech Stack

### Framework
- **Flutter** - Cross-platform mobile application framework
- **Dart** - Primary programming language

### Core Dependencies
| Package | Purpose |
|---------|---------|
| `google_mlkit_text_recognition` | OCR and text extraction engine |
| `hive_flutter` | Local NoSQL database for offline storage |
| `camera` | Camera hardware access and preview |
| `image_picker` | Gallery and camera image selection |
| `url_launcher` | External URL and phone dialer integration |
| `intl` | Internationalization and date formatting |

### Architecture
- **Storage Layer**: Hive-based local database for offline-first operation
- **State Management**: ValueListenableBuilder with reactive Hive boxes
- **OCR Engine**: Google ML Kit Text Recognition API
- **Text Processing**: Regex-based intelligent parsing for data extraction

---

## Project Structure

```
lib/
├── main.dart                      # Application entry point
├── screens/
│   ├── scan_screen.dart           # Camera scanning interface
│   ├── contacts_screen.dart       # Contact management UI
│   ├── receipts_screen.dart       # Receipt archive interface
│   ├── notes_screen.dart          # Notes collection UI
│   ├── links_screen.dart          # URL bookmarks interface
│   └── search_results_screen.dart # Global search UI
├── services/
│   ├── ocr_service.dart           # OCR processing logic
│   ├── text_parser.dart           # Intelligent text parsing
│   └── storage_service.dart       # Database operations
├── models/
│   ├── contact.dart               # Contact data model
│   ├── receipt.dart               # Receipt data model
│   ├── note.dart                  # Note data model
│   └── link.dart                  # Link data model
└── widgets/
    ├── scan_button.dart           # Reusable button component
    ├── item_card.dart             # Generic card widget
    └── loading_overlay.dart       # Loading state indicator
```

---

## Design System

Sensus implements a cohesive design language with the following principles:

### Color Palette
- **Primary**: #68BA7F (brand green)
- **Secondary**: #2E6F40 (dark green accents)
- **Background**: #CFFFDC (light green background)
- **Text**: #253D2C (dark green text)
- **Accent**: #E8D177 (gold highlights)

### UI Patterns
- Card-based layouts with elevation shadows
- Gradient overlays for visual depth
- Rounded corners (12-24px border radius)
- Circular icon containers
- Status badges for categorization
- Generous padding for readability

---

## Permissions

Sensus requires the following Android/iOS permissions:

- **Camera** - Document scanning functionality
- **Storage** - Gallery access and local data persistence
- **Phone** - Direct calling from saved contacts (optional feature)

---

## Contributing

Contributions are welcome and appreciated. To contribute:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/YourFeature`)
3. Commit your changes (`git commit -m 'Add YourFeature'`)
4. Push to the branch (`git push origin feature/YourFeature`)
5. Open a Pull Request

### Development Guidelines
- Follow Flutter and Dart style guidelines
- Maintain consistent code formatting using `dart format`
- Write clear, descriptive commit messages
- Add inline documentation for complex logic
- Test functionality on both Android and iOS platforms
- Ensure backward compatibility

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for complete details.

---

## Bug Reports

To report bugs, please open an issue including:
- Device model and OS version
- Steps to reproduce the issue
- Expected vs actual behavior
- Screenshots or logs if applicable

---

## Feature Requests

For feature suggestions, open an issue with:
- Clear description of the proposed feature
- Use case and expected benefits
- Relevant mockups or reference implementations

---

## Contact

**Project Maintainer**: Anurag Mohan

- GitHub: [@Anurag-Mohan](https://github.com/Anurag-Mohan)

---

## Acknowledgments

- Google ML Kit for OCR capabilities
- Flutter team for the cross-platform framework
- Hive team for efficient local storage solution
- All contributors and users of Sensus

---

<div align="center">

**Built with Flutter**

Star this repository if you find it useful

</div>
