import 'package:sqflite/sqflite.dart';
import 'package:banking_app/database/database_service.dart';
import 'package:banking_app/models/customer_model.dart';
import 'package:banking_app/models/transfer_model.dart';

class BankingDB {

  final customers = [
    {
      'name': 'Person 0', 'email': 'person0@example.com', 'balance': 5000.0,
      'profileImage': 'images/profiles/image-0.jpg',
      'backgroundImage': 'images/background/image-0.jpeg',
    },
    {
      'name': 'Person 1', 'email': 'person1@example.com', 'balance': 5000.0,
      'profileImage': 'images/profiles/image-1.png',
      'backgroundImage': 'images/background/image-1.jpg',
    },
    {
      'name': 'Person 2', 'email': 'person2@example.com', 'balance': 5000.0,
      'profileImage': 'images/profiles/image-2.webp',
      'backgroundImage': 'images/background/image-2.jpeg',
    },
    {
      'name': 'Person 3', 'email': 'person3@example.com', 'balance': 5000.0,
      'profileImage': 'images/profiles/image-3.webp',
      'backgroundImage': 'images/background/image-3.jpg',
    },
    {
      'name': 'Person 4', 'email': 'person4@example.com', 'balance': 5000.0,
      'profileImage': 'images/profiles/image-4.jpeg',
      'backgroundImage': 'images/background/image-4.jpg',
    },
    {
      'name': 'Person 5', 'email': 'person5@example.com', 'balance': 5000.0,
      'profileImage': 'images/profiles/image-5.jpg',
      'backgroundImage': 'images/background/image-5.jpeg',
    },
    {
      'name': 'Person 6', 'email': 'person6@example.com', 'balance': 5000.0,
      'profileImage': 'images/profiles/image-6.webp',
      'backgroundImage': 'images/background/image-6.jpeg',
    },
    {
      'name': 'Person 7', 'email': 'person7@example.com', 'balance': 5000.0,
      'profileImage': 'images/profiles/image-7.jpg',
      'backgroundImage': 'images/background/image-7.jpg',
    },
    {
      'name': 'Person 8', 'email': 'person8@example.com', 'balance': 5000.0,
      'profileImage': 'images/profiles/image-8.webp',
      'backgroundImage': 'images/background/image-8.jpg',
    },
    {
      'name': 'Person 9', 'email': 'person9@example.com', 'balance': 5000.0,
      'profileImage': 'images/profiles/image-9.jpeg',
      'backgroundImage': 'images/background/image-9.jpg',
    },
  ];
  
  Future<void> createTables(Database database) async {
    await database.execute("""
      CREATE TABLE IF NOT EXISTS customers (
        id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE NOT NULL,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        balance REAL NOT NULL,
        profileImage TEXT NOT NULL,
        backgroundImage TEXT NOT NULL
      );
    """);

    await database.execute("""
      CREATE TABLE IF NOT EXISTS transfers (
        id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE NOT NULL,
        sender INTEGER NOT NULL,
        receiver INTEGER NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        FOREIGN KEY (sender) REFERENCES customers(id),
        FOREIGN KEY (receiver) REFERENCES customers(id)
      );
    """);

    Batch batch = database.batch();
    for (final customer in customers) {
      batch.insert('customers', customer);
    }
    batch.commit();
  }

  Future<void> configure(Database database) async {
    await database.execute("PRAGMA foreign_keys = ON");
  }

  Future<List<Customer>> getAllCustomers() async {
    final database = await DatabaseService().database;
    final customers = await database.query('customers', orderBy: 'name');
    return customers.map((customer) => Customer.formatData(customer)).toList();
  }

  Future<Customer> getCustomerByID({required int id}) async {
    final database = await DatabaseService().database;
    final customer = await database.query('customers', where: 'id = ?', whereArgs: [id], limit: 1);
    return Customer.formatData(customer.first);
  }

  Future<void> _updateCustomersBalance(Database database, {required int sender, required int receiver, required double amount}) async {
    // final database = await DatabaseService().database;
    List<Map<String, dynamic>> senderBalanceList = await database.query('customers', columns: ['balance'], where: 'id = ?', whereArgs: [sender], limit: 1);
    double newSenderBalance = senderBalanceList.first['balance'].toDouble() - amount;
    await database.update('customers', {'balance': newSenderBalance}, where: 'id = ?', whereArgs: [sender]);
    List<Map<String, dynamic>> receiverBalanceList = await database.query('customers', columns: ['balance'], where: 'id = ?', whereArgs: [receiver], limit: 1);
    double newReceiverBalance = receiverBalanceList.first['balance'].toDouble() + amount;
    await database.update('customers', {'balance': newReceiverBalance}, where: 'id = ?', whereArgs: [receiver]);
  }

  Future<int> createTransfer({required int sender, required int receiver, required double amount}) async {
    final database = await DatabaseService().database;
    _updateCustomersBalance(database, sender: sender, receiver: receiver, amount: amount);
    try {
      await database.insert('transfers', {
        'sender': sender,
        'receiver': receiver,
        'amount': amount,
        'date': DateTime.now().toString(),
      });
      return 0;
    } on DatabaseException {
      return 500;
    }
  }

  Future<List<Transfer>> _getUserTransfersByDestination({required int id, required String destination}) async {
    final database = await DatabaseService().database;
    final List<Map<String, dynamic>> transfers = await database.query('transfers', where: '$destination = ?', whereArgs: [id]);
    List<String> names = [];

    for (var index = 0; index < transfers.length; index++) {
      final List<Map<String, dynamic>> customer = await database.query('customers', columns: ['name'], where: 'id = ?', whereArgs: [transfers[index]['receiver']], limit: 1);
      final singleCustomer = customer.first;
      names.add(singleCustomer['name']);
    }
    return Transfer.formatData(transfers, names, destination);
  }

  Future<List<Transfer>> getUserTransfers({required int id}) async {
    List<Transfer> twoWayTransfers = await _getUserTransfersByDestination(id: id, destination: 'sender');
    twoWayTransfers.addAll(await _getUserTransfersByDestination(id: id, destination: 'receiver'));
    return twoWayTransfers;
  }
}