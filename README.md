# Personal Expense Tracker App

A Flutter application to manage daily income and expenses. Users can add, view,
update and delete transactions, and the app calculates total income, total
expense and current balance automatically. All data is stored locally using
SQLite, so it is still there after closing and reopening the app.

## Features

- Dashboard with **Total Income**, **Total Expense** and **Current Balance** cards
- Recent transactions list with a floating button to add a new transaction
- Add transaction form (title, amount, category, income/expense type, date picker)
- Form validation (empty title, invalid or non-positive amount, missing category/type)
- Full transaction list built with `ListView.builder`
  (green for income, red for expense)
- Transaction details screen with Edit and Delete options
- Edit existing transactions with previously saved values pre-filled
- Delete with an `AlertDialog` confirmation; list and totals update immediately
- About App screen
- Offline local storage with Sqflite

## Tech Stack

| Item | Details |
|---|---|
| Framework | Flutter (Dart) |
| Local database | `sqflite` |
| Database name | `expense_tracker.db` |
| Table | `transactions` |
| Date formatting | `intl` |

### Table structure

| Column | Type |
|---|---|
| id | INTEGER PRIMARY KEY AUTOINCREMENT |
| title | TEXT |
| amount | REAL |
| category | TEXT |
| type | TEXT (`Income` / `Expense`) |
| date | TEXT (ISO 8601) |

## Project Structure

```
lib/
├── main.dart
├── models/
│   └── transaction_model.dart
├── database/
│   └── database_helper.dart
├── widgets/
│   └── common_widgets.dart
└── screens/
    ├── dashboard_screen.dart
    ├── add_edit_transaction_screen.dart
    ├── transaction_list_screen.dart
    ├── transaction_details_screen.dart
    └── about_screen.dart
```

## Getting Started

```bash
git clone https://github.com/hellobelal/PERSONAL-EXPENSE-TRACKER-APP.git
cd PERSONAL-EXPENSE-TRACKER-APP
flutter pub get
dart run flutter_launcher_icons   # optional: generate the app icon
flutter run
```

## Author

Md Belal Mondal