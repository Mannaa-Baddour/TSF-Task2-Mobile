class Transfer {
  final int id;
  final int sender;
  final int receiver;
  late String? toName;
  final double amount;
  final String date;
  late String? destination;

  Transfer({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.amount,
    required this.date,
    this.toName,
    this.destination,
  });

  static List<Transfer> formatData(List<Map<String, dynamic>> data, List<dynamic> names, String destination) {
    List<Transfer> transfers = [];
    for (var index = 0; index < data.length; index++) {
      transfers.add(Transfer(
        id: data[index]['id'].toInt() ?? 0,
        sender: data[index]['sender'].toInt() ?? 0,
        receiver: data[index]['receiver'].toInt() ?? 0,
        amount: data[index]['amount'].toDouble() ?? 0.0,
        date: data[index]['date'].split('.')[0].split(' ').join(', ') ?? '',
        toName: names[index] ?? '',
        destination: destination,
      ));
    }
    return transfers;
  }
}