class Customer {
  final int id;
  final String name;
  final String email;
  final double balance;
  final String profileImage;
  final String backgroundImage;

  Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.balance,
    required this.profileImage,
    required this.backgroundImage,
  });

  factory Customer.formatData(Map<String, dynamic> data) => Customer(
      id: data['id'].toInt() ?? 0,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      balance: data['balance'].toDouble() ?? 0.0,
      profileImage: data['profileImage'] ?? '',
      backgroundImage: data['backgroundImage'] ?? '',
  );
}