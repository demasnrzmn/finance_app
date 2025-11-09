import 'package:flutter/material.dart';
import '../widgets/atm_card.dart';

class AllCardsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> atmCards;

  const AllCardsScreen({super.key, required this.atmCards});

  @override
  State<AllCardsScreen> createState() => _AllCardsScreenState();
}

class _AllCardsScreenState extends State<AllCardsScreen> {
  int selectedIndex = -1; // -1 artinya belum ada yang dipilih

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Cards'),
        backgroundColor: const Color(0xFF0D47A1),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.atmCards.length,
        itemBuilder: (context, index) {
          final card = widget.atmCards[index];
          bool isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index; // tandai kartu yang dipilih
              });
              // Kembalikan index ke HomeScreen setelah delay singkat supaya efek highlight terlihat
              Future.delayed(const Duration(milliseconds: 150), () {
                Navigator.pop(context, index);
              });
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: isSelected ? const EdgeInsets.all(4) : EdgeInsets.zero,
              decoration: isSelected
                  ? BoxDecoration(
                      border: Border.all(
                        color: Colors.blueAccent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    )
                  : null,
              child: AtmCard(
                bankName: card['bankName'],
                cardNumber: card['cardNumber'],
                cardHolder: card['cardHolder'],
                balance: 'Rp${card['balance'].toStringAsFixed(0)}',
                backgroundImage: card['image'],
              ),
            ),
          );
        },
      ),
    );
  }
}
