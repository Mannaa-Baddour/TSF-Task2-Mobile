import 'package:banking_app/database/banking_db.dart';
import 'package:flutter/material.dart';
import 'package:banking_app/models/customer_model.dart';
import 'package:banking_app/pages/transfers_amount.dart';

class TransfersUsersPage extends StatefulWidget {
  final Customer sender;

  const TransfersUsersPage({Key? key, required this.sender}) : super(key: key);

  @override
  State<TransfersUsersPage> createState() => _TransfersUsersPageState();
}

class _TransfersUsersPageState extends State<TransfersUsersPage> {
  late Future<List<Customer>> futureCustomers;
  final bankingDB = BankingDB();

  @override
  void initState() {
    super.initState();
    getAllCustomers();
  }

  void getAllCustomers() {
    setState(() {
      futureCustomers = bankingDB.getAllCustomers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer To Account'),
        foregroundColor: const Color(0xFF00214E),
        titleSpacing: 0.0,
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                opacity: 0.3,
                image: AssetImage('images/users.jpg')
            )
        ),
        child: FutureBuilder<List<Customer>>(
            future: futureCustomers,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                final users = snapshot.data!;
                final customers =
                    users.where((user) => user.id != widget.sender.id).toList();

                return customers.isEmpty
                    ? const Center(
                        child: Text(
                          'There are no accounts to transfer to...',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                            color: Color(0xFFEE0000),
                          ),
                        ),
                      )
                    : Column(children: [
                         Container(
                            margin: const EdgeInsets.symmetric(horizontal: 25,),
                            child: const Text(
                              'Please choose an account to transfer money to',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF00214E),
                              ),
                        )),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                // leading: const Icon(Icons.person),
                                leading: CircleAvatar(
                                  radius: 25,
                                  backgroundImage: AssetImage(customers[index].profileImage),
                                ),
                                title: Text(customers[index].name),
                                subtitle: Text(customers[index].email),
                                onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (_) {
                                    return TransfersAmountPage(
                                        sender: widget.sender, receiver: customers[index]);
                                  }));
                                },
                              );
                            },
                            separatorBuilder: (BuildContext context, int index) =>
                                const SizedBox(height: 10),
                            itemCount: customers.length,
                          ),
                        ),
                      ]
                );
              }
            }),
      ),
    );
  }
}
