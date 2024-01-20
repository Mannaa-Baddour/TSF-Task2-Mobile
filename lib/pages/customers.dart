import 'package:banking_app/database/banking_db.dart';
import 'package:banking_app/pages/one_customer.dart';
import 'package:flutter/material.dart';
import 'package:banking_app/models/customer_model.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({Key? key}) : super(key: key);

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
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
    return Container(
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
              // final customers = snapshot.data!;
              final customers = snapshot.data ?? [];

              return customers.isEmpty
                  ?  const Center(
                      child: Text(
                        'There are no accounts to display...',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          color: Color(0xFFEE0000),
                        ),
                      ),
                    )
                  :  ListView.separated(
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            // leading: const Icon(Icons.person),
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundImage: AssetImage(customers[index].profileImage),
                            ),
                            title: Text(customers[index].name),
                            subtitle: Text(customers[index].email),
                            trailing: Text(
                              '${customers[index].balance} \$',
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                                return CustomerProfile(id: customers[index].id);
                              }));
                            },
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const SizedBox(height: 10),
                        itemCount: customers.length,
                    );
            }
          }),
    );
  }
}
