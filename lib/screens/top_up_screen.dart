import 'package:flutter/material.dart';

class TopUpScreen extends StatefulWidget {
  const TopUpScreen({super.key});

  @override
  State<TopUpScreen> createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  final TextEditingController _amountController = TextEditingController();
  int _selectedMethodIndex = 0; // index metode yang dipilih

  final List<Map<String, dynamic>> _methods = [
    {'name': 'Demz Bank', 'icon': Icons.account_balance},
    {'name': 'Dana', 'icon': Icons.account_balance_wallet},
    {'name': 'OVO', 'icon': Icons.payment},
    {'name': 'GoPay', 'icon': Icons.mobile_friendly},
    {'name': 'LinkAja', 'icon': Icons.wallet_giftcard},
  ];

  String _formatRupiah(String nominal) {
    if (nominal.isEmpty) return 'Rp0';
    final double amount = double.tryParse(nominal) ?? 0;
    return 'Rp${amount.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.')}';
  }

  Widget _quickNominalChip(String nominalText) {
    String rawNominal = nominalText.replaceAll('Rp', '').replaceAll('.', '');
    return GestureDetector(
      onTap: () {
        _amountController.text = rawNominal;
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE3F2FD),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF1976D2), width: 1.5),
        ),
        alignment: Alignment.center,
        child: Text(
          nominalText,
          style: const TextStyle(
            color: Color(0xFF0D47A1),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  void _processTopUp() {
    String nominalText = _amountController.text;
    final nominal = double.tryParse(nominalText);

    if (nominal == null || nominal < 10000) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan nominal Top Up minimal Rp10.000'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final method = _methods[_selectedMethodIndex]['name'];
    final formattedAmount = _formatRupiah(nominalText);

    // Kembalikan data ke HomeScreen
    Navigator.pop(context, {
      'nominal': nominal,
      'method': method,
    });

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 10),
            Text('Top Up Berhasil!'),
          ],
        ),
        content: Text('Top Up sebesar $formattedAmount via $method berhasil diproses.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('SELESAI'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Top Up Saldo',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0D47A1),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih Metode Top Up',
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF0D47A1)),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 100,
              child: PageView.builder(
                itemCount: _methods.length,
                onPageChanged: (index) {
                  setState(() {
                    _selectedMethodIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final method = _methods[index];
                  final isSelected = _selectedMethodIndex == index;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF1976D2) : const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF1976D2)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          method['icon'],
                          size: 40,
                          color: isSelected ? Colors.white : const Color(0xFF0D47A1),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          method['name'],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : const Color(0xFF0D47A1),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Masukkan Nominal Top Up (Rp)',
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
            const SizedBox(height: 30),
            const Text(
              'Pilihan Nominal Cepat',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0D47A1),
              ),
            ),
            const SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _quickNominalChip('Rp50.000'),
                _quickNominalChip('Rp100.000'),
                _quickNominalChip('Rp250.000'),
                _quickNominalChip('Rp500.000'),
                _quickNominalChip('Rp1.000.000'),
                _quickNominalChip('Rp2.000.000'),
              ],
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: _processTopUp,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1976D2),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'LANJUTKAN TOP UP',
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
