import 'package:flutter/material.dart';
import '../models/transaction.dart'; // Pastikan path ini benar

class TransactionItem extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback onDelete; 

  const TransactionItem({
    super.key,
    required this.transaction,
    required this.onDelete,
  });

  // Fungsi untuk menentukan ikon berdasarkan kategori transaksi
  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'travel':
        return Icons.flight_takeoff;
      case 'health':
        return Icons.health_and_safety;
      case 'income':
        return Icons.attach_money;
      case 'transfer':
        return Icons.send;
      default:
        return Icons.receipt;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isExpense = transaction.amount.startsWith('-');
    final Color amountColor = isExpense ? Colors.red.shade700 : Colors.green.shade700;
    final IconData iconData = _getCategoryIcon(transaction.category);
    final Color iconBackgroundColor = amountColor.withOpacity(0.1);

    return Dismissible(
      key: Key(transaction.title + transaction.amount + UniqueKey().toString()), // Kunci unik yang lebih aman
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white, size: 30),
      ),
      onDismissed: (direction) {
        onDelete(); // Panggil fungsi hapus dari parent (HomeScreen)
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconBackgroundColor,
          radius: 24,
          child: Icon(iconData, color: amountColor, size: 24),
        ),
        title: Text(
          transaction.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          transaction.category,
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: Text(
          transaction.amount,
          style: TextStyle(
            color: amountColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}