<div align="center">
  <img src="assets/logo.png" width="150" height="150" alt="Nova Drive Logo" />
  
  # Nova Drive
  
  **The ultimate, secure, and blazing-fast cloud storage client built on top of Telegram's TDLib.**
  
  [![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
  [![Flutter](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev)
  [![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-lightgrey.svg)]()
</div>

---

## 🚀 Overview

Nova Drive is a beautiful, highly optimized cloud storage application that leverages the power of Telegram's ecosystem. By using the official TDLib (Telegram Database Library) via FFI, Nova Drive transforms your "Saved Messages" and Telegram chats into a fully functional, end-to-end encrypted personal cloud drive. 

Enjoy limitless storage, lightning-fast uploads/downloads, and an intuitive, modern user interface.

## ✨ Features

- **Blazing Fast Sync:** Uses native TDLib C++ bindings for maximum performance and minimum overhead.
- **Infinite Storage:** Leverages Telegram's cloud infrastructure for unlimited file storage.
- **Smart Vaults & Categories:** Automatically organizes your files into intuitive categories (Images, Videos, Documents, Music).
- **Secure by Design:** Files are tied directly to your Telegram account. No third-party servers, no middle-men.
- **Dynamic Theming:** Beautiful, responsive UI built with Flutter Riverpod and Material 3.
- **Logical Deletions:** Safe and synchronized file deletions, complete with a Trash Bin.

## 🛠 Tech Stack

- **Framework:** [Flutter](https://flutter.dev) (Dart)
- **State Management:** [Riverpod](https://riverpod.dev)
- **Routing:** [GoRouter](https://pub.dev/packages/go_router)
- **Core Engine:** [TDLib](https://core.telegram.org/tdlib) (via `handy_tdlib`)
- **Local Database:** [Drift](https://drift.simonbinder.eu/) (SQLite)
- **Secure Storage:** `flutter_secure_storage`

## 📦 Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/cassielxyz/NovaDrive.git
   cd NovaDrive
   ```

2. **Install Dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the App:**
   ```bash
   flutter run
   ```

## 🔑 Authentication
Nova Drive requires a Telegram API ID and Hash. Upon first launch, you will be prompted to enter your credentials securely. Your session is stored locally using `flutter_secure_storage` and the native `tdlib` database.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🌟 Acknowledgements
- [Telegram API & TDLib](https://core.telegram.org/tdlib)
- The incredible Flutter community

---
<div align="center">
  <i>Built with ❤️ by Cassiel</i>
</div>
