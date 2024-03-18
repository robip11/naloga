# Flutter Todo List App

This is a simple todo list application built using Flutter.

## Features

- Add new items to the todo list.
- Edit existing items.
- Delete items from the list.
- Mark items as checked or unchecked.
- View checked and unchecked items separately.

## Installation

1. Ensure you have Flutter installed. If not, follow the [installation instructions](https://flutter.dev/docs/get-started/install).
2. Clone this repository to your local machine.
3. Open the project in your preferred IDE or text editor.
4. Run the following command in the project directory to install dependencies:

    
    flutter pub get
    

5. Connect a device or start an emulator.
6. Run the app using the following command:

    
    flutter run
    

## Usage

- Upon launching the app, you will see a list of items.
- To add a new item, tap on the floating action button and enter the item's name in the dialog box that appears.
- To edit an existing item, tap on the edit icon next to the item, make your changes in the dialog box, and save.
- To delete an item, tap on the delete icon next to the item.
- You can mark an item as checked or unchecked by tapping on the checkbox next to it.
- Use the bottom navigation bar to switch between viewing all items, checked items, and unchecked items.

## Structure

lib
|-- main.dart
|-- screens
|   |-- home_page.dart
|   |-- stored_items_page.dart
|   |-- unstored_items_page.dart
|-- models
|   |-- item.dart

## Credits

This application is created by Róbert Požonec.