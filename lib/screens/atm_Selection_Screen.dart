import 'package:flutter/material.dart';
import '../widgets/atm_card.dart';

class AtmCardData {
  final String bankName;
  final String cardNumber;
  final String cardHolder;
  final double balance;
  final String image;

  AtmCardData({
    required this.bankName,
    required this.cardNumber,
    required this.cardHolder,
    required this.balance,
    required this.image,
  });
}

class AtmSelectionScreen extends StatelessWidget {
  final List<AtmCardData> cards;
  final int selectedIndex;

  const AtmSelectionScreen({
    super.key,
    required this.cards,
    required this.selectedIndex,
  });

  String _formatRupiah(double amount) {
    final String formatted = amount.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.');
    return 'Rp$formatted';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      appBar: AppBar(
        title: const Text(
          'Pilih Kartu ATM',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF0D47A1),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: cards.length,
          itemBuilder: (context, index) {
            final card = cards[index];
            final isSelected = index == selectedIndex;

            return GestureDetector(
              onTap: () {
                Navigator.pop(context, index);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: Stack(
                  children: [
                    AtmCard(
                      bankName: card.bankName,
                      cardNumber: isSelected
                          ? card.cardNumber
                          : '**** **** **** ${card.cardNumber.substring(card.cardNumber.length - 4)}',
                      cardHolder: card.cardHolder,
                      balance: _formatRupiah(card.balance),
                      backgroundImage: card.image,
                    ),
                    if (isSelected)
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.check,
                              color: Colors.white, size: 20),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
