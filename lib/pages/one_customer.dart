import 'package:flutter/material.dart';
import 'package:banking_app/models/customer_model.dart';
import 'package:banking_app/models/transfer_model.dart';
import 'package:banking_app/database/banking_db.dart';
import 'package:banking_app/pages/transfers_users.dart';

class CustomerProfile extends StatefulWidget {
  final int id;

  const CustomerProfile({Key? key, required this.id}) : super(key: key);

  @override
  State<CustomerProfile> createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {
  late final Future<Customer> futureCustomer;
  late final Future<List<Transfer>> futureTransfers;
  final bankingDB = BankingDB();

  @override
  void initState() {
    super.initState();
    getCustomer();
  }

  void getCustomer() {
    setState(() {
      futureCustomer = bankingDB.getCustomerByID(id: widget.id);
      futureTransfers = bankingDB.getUserTransfers(id: widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Profile'),
        foregroundColor: const Color(0xFF00214E),
        titleSpacing: 0.0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            opacity: 0.3,
            image: AssetImage('images/banking.jpeg'),
          ),
        ),
        child: FutureBuilder<Customer>(
            future: futureCustomer,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                final customer = snapshot.data!;

                return Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 150.0,
                            child: Image.asset(
                              customer.backgroundImage,
                              alignment: const Alignment(0, 0.5),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            bottom: -50.0,
                            left: (MediaQuery.of(context).size.width / 2) - 50,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: AssetImage(customer.profileImage),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          left: 25,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Name:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF00214E),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  customer.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFF282460),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Email:',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF00214E),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  customer.email,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFF282460),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Balance:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF00214E),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '${customer.balance} \$',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFF282460),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              'Transfers History:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF00214E),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            FutureBuilder<List<Transfer>>(
                                future: futureTransfers,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const SizedBox(
                                      height: 180,
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  } else {
                                    // final customers = snapshot.data!;
                                    final transfers = snapshot.data ?? [];

                                    return Container(
                                      margin: const EdgeInsets.only(right: 25,),
                                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: const Color(0xFF00214E),
                                            width: 1,
                                          )
                                      ),
                                      height: 180,
                                          child: transfers.isEmpty
                                              ? const Center(
                                              child: Text(
                                                "There are no transfers to show",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Color(0xFFEE0000),
                                                ),
                                              ),
                                            )
                                        : ListView.separated(
                                              itemBuilder:
                                                  (BuildContext context, int index) {
                                                return Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          '- ${transfers[index].destination == 'sender' ? 'Sent' : 'Received'} at:',
                                                          style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.bold,
                                                            color: Color(0xFF00214E),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          transfers[index].date,
                                                          style: const TextStyle(
                                                            fontSize: 16,
                                                            color: Color(0xFF282460),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      children: [
                                                        const SizedBox(
                                                          width: 12,
                                                        ),
                                                        const Text(
                                                          'Transfer ID:',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.bold,
                                                            color: Color(0xFF00214E),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          '${transfers[index].id}',
                                                          style: const TextStyle(
                                                            fontSize: 16,
                                                            color: Color(0xFF282460),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      children: [
                                                        const SizedBox(
                                                          width: 12,
                                                        ),
                                                        Text(
                                                          '${transfers[index].destination == 'sender' ? 'Receiver' : 'Sender'}:',
                                                          style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.bold,
                                                            color: Color(0xFF00214E),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          '${transfers[index].toName}',
                                                          style: const TextStyle(
                                                            fontSize: 16,
                                                            color: Color(0xFF282460),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      children: [
                                                        const SizedBox(
                                                          width: 12,
                                                        ),
                                                        const Text(
                                                          'Amount:',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.bold,
                                                            color: Color(0xFF00214E),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          '${transfers[index].amount} \$',
                                                          style: const TextStyle(
                                                            fontSize: 16,
                                                            color: Color(0xFF282460),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              },
                                              separatorBuilder:
                                                  (BuildContext context, int index) =>
                                                      const SizedBox(height: 20),
                                              itemCount: transfers.length,
                                            ),
                                        );
                                  }
                                }),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                right: 25,
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (_) {
                                    return TransfersUsersPage(sender: customer);
                                  }));
                                },
                                style: ElevatedButton.styleFrom(
                                    textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF00214E),
                                )),
                                child: const Text('Transfer Money'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
              }
            }),
      ),
    );
  }
}
