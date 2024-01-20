import 'package:flutter/material.dart';
import 'package:banking_app/models/customer_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:banking_app/pages/root.dart';
import 'package:banking_app/database/banking_db.dart';

enum ButtonState { init, transferring, done, failed }

class TransfersAmountPage extends StatefulWidget {
  final Customer sender;
  final Customer receiver;

  const TransfersAmountPage({Key? key, required this.sender, required this.receiver}) : super(key: key);

  @override
  State<TransfersAmountPage> createState() => _TransfersAmountPageState();
}

class _TransfersAmountPageState extends State<TransfersAmountPage> {
  String _amount = '';
  bool _isAnimating = true;
  ButtonState state = ButtonState.init;
  final bankingDB = BankingDB();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isInit = _isAnimating || state == ButtonState.init;
    final isDone = state == ButtonState.done;
    final isFailed = state == ButtonState.failed;

    void showToast(String message, Color backgroundColor) => Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: backgroundColor,
        textColor: Colors.white,
        fontSize: 16.0
    );

    Widget stretchedButton() => ElevatedButton(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF00214E),
        )),
      onPressed: _amount == '' ? null : () async {
        if (_amount == '0' || _amount == '0.0') {
          showToast("Transfer amount can't be zero", const Color(0xFFEE0000));
        } else if (double.parse(_amount) < 0) {
          showToast("Please enter a valid amount to transfer", const Color(0xFFEE0000));
        } else if (double.parse(_amount) > widget.sender.balance) {
          showToast("Transfer amount can't be more than your balance", const Color(0xFFEE0000));
        } else {
          setState(() => state = ButtonState.transferring);
          final result = await bankingDB.createTransfer(sender: widget.sender.id, receiver: widget.receiver.id, amount: double.parse(_amount));
          await Future.delayed(const Duration(seconds: 3));
          if (result == 0) {
            setState(() => state = ButtonState.done);
          } else {
            setState(() => state = ButtonState.failed);
          }
          await Future.delayed(const Duration(seconds: 2));
          if (!context.mounted) return;
          if (result == 0) {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) {
              return const RootPage(page: 1);
            }), (Route<dynamic> route) => false);
          }
        }
      },
      child: const FittedBox(
          child: Text('Transfer'),
      ),
    );

    Widget smallButton(bool isDone, bool isFailed) {
      final color = isFailed ? const Color(0xFFEE0000) : isDone ? const Color(0xFF0ABB85) : const Color(0xFF282460);

      return Container(
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        child: Center(
          child: isFailed
              ? const Icon(
                  Icons.clear,
                  size: 52,
                  color: Colors.white,
                )
            : isDone
              ? const Icon(
                  Icons.done,
                  size: 52,
                  color: Colors.white,
                )
              : const CircularProgressIndicator(
            color: Colors.white,
          )
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer Amount'),
        foregroundColor: const Color(0xFF00214E),
        titleSpacing: 0.0,
      ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              opacity: 0.3,
              image: AssetImage('images/transfer.webp')
            ),
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 25,),
          child: Column(
            children: [
              const Text(
                "Please specify the amount you'd like to transfer",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00214E)
                ),
              ),
              const SizedBox(height: 50,),
              Text(
                'Your balance: ${widget.sender.balance} \$',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00214E)
                ),
              ),
              const SizedBox(height: 20,),
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "Enter Amount",
                ),
                onChanged: (amount) {
                  setState(() {
                    _amount = amount;
                  });
                },
              ),
              const SizedBox(height: 50,),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
                width: state == ButtonState.init ? width : 70,
                height: 70,
                onEnd: () => setState(() => _isAnimating = !_isAnimating),
                child: isInit ? stretchedButton() : smallButton(isDone, isFailed),
              ),
            ],
          ),
        )
    );
  }
}