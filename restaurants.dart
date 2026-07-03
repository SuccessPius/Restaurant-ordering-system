import 'dart:io';

// Base class representing a generic item on the menu.
// Uses private fields and public getters to demonstrate encapsulation.
class MenuItem {
  // Private properties
  final String _name;
  final double _price;
  final String _category;

  // Constructor
  MenuItem(this._name, this._price, this._category);

  // Getters to expose private fields for reading outside the class
  String get name => _name;
  double get price => _price;
  String get category => _category;

  // Prints the basic details of the menu item
  void displayItem() {
    print('[$_category] $_name - ₦${_price.toStringAsFixed(2)}');
  }
}

// Subclass representing food items, extending MenuItem.
class Food extends MenuItem {
  // Extra property specific to Food (small, medium, or large)
  final String _portionSize;

  // Constructor using 'super' to pass shared properties to the base class
  Food(String name, double price, this._portionSize) : super(name, price, 'Food');

  // Getter for portion size
  String get portionSize => _portionSize;

  // Overrides displayItem to include portion size details
  @override
  void displayItem() {
    print('[$category] $name ($_portionSize size) - ₦${price.toStringAsFixed(2)}');
  }
}

// Subclass representing drink items, extending MenuItem.
class Drink extends MenuItem {
  // Extra properties specific to Drink
  final String _size;
  final bool _isCold;

  // Constructor using 'super' to pass shared properties to the base class
  Drink(String name, double price, this._size, this._isCold) : super(name, price, 'Drink');

  // Getters for drink-specific fields
  String get size => _size;
  bool get isCold => _isCold;

  // Overrides displayItem to include size and temperature details
  @override
  void displayItem() {
    String temperature = _isCold ? 'Cold' : 'Hot';
    print('[$category] $name ($_size size, $temperature) - ₦${price.toStringAsFixed(2)}');
  }
}

//Class that manages the state of a customer's order.
class Order {
  final String _customerName;
  final List<MenuItem> _items = [];
  double _total = 0.0;

  // Constructor
  Order(this._customerName);

  // Getters
  String get customerName => _customerName;
  List<MenuItem> get items => _items;
  double get total => _total;

  // Adds an item to the order list and updates the total bill
  void addItem(MenuItem item) {
    _items.add(item);
    _total += item.price;
    print('Successfully added ${item.name} to the order.');
  }

  // Searches items by name using a loop, removes it if found, or prints error
  void removeItem(String name) {
    bool found = false;

    for (int i = 0; i < _items.length; i++) {
      // Direct case-insensitive match for easier user experience
      if (_items[i].name.toLowerCase() == name.toLowerCase()) {
        _total -= _items[i].price;
        print('Successfully removed ${_items[i].name} from the order.');
        _items.removeAt(i);
        found = true;
        break; // Stop loop after finding and removing the item
      }
    }

    if (!found) {
      print('Error: "$name" was not found in your current order.');
    }
  }

  // Prints the customer receipt summary and clears state for the next session
  void printBill() {
    print('\n===RECEIPT ===');
    print('Customer Name: $_customerName');
    
    
    if (_items.isEmpty) {
      print('No items ordered.');
    } else {
      for (var item in _items) {
        item.displayItem();
      }
    }
    
    print('---');
    print('Total Amount Due: ₦${_total.toStringAsFixed(2)}');
    print('===\n');

    // Resetting order state for the next customer session
    _items.clear();
    _total = 0.0;
    print('Order session reset successfully. Ready for next customer.');
  }
}

void main() {
  // Menu items 
  List<MenuItem> menu = [
    Food('Pounded Yam with Egusi', 3500, 'large'),
    Food('Suya Platter', 4000, 'medium'),
    Food('Asun (Spicy Goat Meat)', 2800, 'small'),
    Drink('Zobo Drink', 600, 'large', true),
    Drink('Chapman CockTail', 1200, 'medium', true),
    Drink('Fanta', 800, 'small', false),
  ];

// Capture Customer name to initialize the order object session
  print('Welcome to the Restaurant Ordering System!');
  stdout.write('Enter customer name to begin: ');
  String customerName = stdin.readLineSync() ?? 'Valued Customer';
  if (customerName.trim().isEmpty) {
    customerName = 'Valued Customer';
  }
  
  Order currentOrder = Order(customerName);
  bool isRunning = true;

  // Main Menu Loop running until exit condition is met
  while (isRunning) {
    print('\n MAIN MENU ');
    print('1. View Menu');
    print('2. Add Item to Order');
    print('3. Remove Item from Order');
    print('4. Print Bill');
    print('5. Exit');
    stdout.write('Select an option (1-5): ');
    
    String? choice = stdin.readLineSync();

    //  Conditional validation handling using explicit if/else logic
    if (choice == '1') {
      print('\n- OUR MENU -');
      for (int i = 0; i < menu.length; i++) {
        stdout.write('${i + 1}. ');
        menu[i].displayItem();
      }
    } 
    else if (choice == '2') {
      print('\n--- SELECT AN ITEM TO ADD ---');
      for (int i = 0; i < menu.length; i++) {
        print('${i + 1}. ${menu[i].name} (₦${menu[i].price})');
      }
      stdout.write('Enter item number: ');
      String? itemChoice = stdin.readLineSync();
      
      // Match option strictly using explicit if/else statements
      if (itemChoice == '1') {
        currentOrder.addItem(menu[0]);
      } else if (itemChoice == '2') {
        currentOrder.addItem(menu[1]);
      } else if (itemChoice == '3') {
        currentOrder.addItem(menu[2]);
      } else if (itemChoice == '4') {
        currentOrder.addItem(menu[3]);
      } else if (itemChoice == '5') {
        currentOrder.addItem(menu[4]);
      } else if (itemChoice == '6') {
        currentOrder.addItem(menu[5]);
      } else {
        print('Invalid item number chosen.');
      }
    } 
    else if (choice == '3') {
      stdout.write('\nEnter the exact name of the item to remove: ');
      String? itemName = stdin.readLineSync();
      if (itemName != null && itemName.trim().isNotEmpty) {
        currentOrder.removeItem(itemName.trim());
      } else {
        print('Item name cannot be empty.');
      }
    } 
    else if (choice == '4') {
      currentOrder.printBill();
    } 
    else if (choice == '5') {
      print('Thank you for using our Restaurant Ordering System. Goodbye!');
      isRunning = false;
    } 
    else {
      print('Invalid selection. Please input a number from 1 to 5.');
    }
  }
}