// lib/screens/transfer_screen.dart - GANTI SELURUH KODE
import 'package:flutter/material.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _accountController = TextEditingController();
  String? _selectedBank;

  // Helper untuk memformat Rupiah
  String _formatRupiah(String nominal) {
    if (nominal.isEmpty) return 'Rp0';
    final double amount = double.parse(nominal);
    return 'Rp${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  // FUNGSI INTI: PROSES, TAMPILKAN HASIL, DAN KEMBALIKAN DATA
  void _processTransfer() {
    String nominalText = _amountController.text;
    String rekening = _accountController.text;
    final nominal = double.tryParse(nominalText);

    if (nominal != null && nominal >= 10000 && rekening.length >= 5 && _selectedBank != null) {
      // 1. Data valid. Lanjutkan simulasi sukses.
      final formattedAmount = _formatRupiah(nominalText);
      final recipientName = 'A/N Demas Nurjaman';

      // 2. Tampilkan Dialog Sukses di Halaman TransferScreen
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.done_all, color: Colors.green),
              SizedBox(width: 10),
              Text('Transfer Berhasil!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nominal: $formattedAmount'),
              Text('Tujuan: $recipientName'),
              Text('Bank: $_selectedBank'),
              Text('No. Rek: $rekening'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx); // Tutup dialog
                // KEMBALIKAN DATA ke HomeScreen
                Navigator.pop(context, {'nominal': nominal, 'rekening': rekening}); 
              },
              child: const Text('SELESAI'),
            ),
          ],
        ),
      );
    } else {
      // Data tidak valid
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon lengkapi semua data Transfer dengan benar (Min. Rp10.000, pilih Bank, No. Rek. min 5 digit)'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _accountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Transfer Dana',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0D47A1),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tujuan Transfer
            const Text(
              'Tujuan Transfer',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0D47A1),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Pilih Bank Tujuan',
                ),
                value: _selectedBank,
                items: ['Demz Bank (Sesama)', 'Bank Lain'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedBank = newValue;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),

            // Input Nomor Rekening
            const Text(
              'Nomor Rekening Tujuan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0D47A1),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _accountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Masukkan Nomor Rekening',
                suffixIcon:
                    const Icon(Icons.search, color: Color(0xFF0D47A1)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF0D47A1)),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Input Nominal
            const Text(
              'Nominal Transfer (Rp)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0D47A1),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                prefixText: 'Rp ',
                hintText: 'Min. 10.000',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF0D47A1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: Color(0xFF1976D2), width: 2.0),
                ),
              ),
            ),

            const SizedBox(height: 50),

            // Tombol Konfirmasi
            ElevatedButton(
              onPressed: _processTransfer,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1976D2),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'LANJUTKAN TRANSFER',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}