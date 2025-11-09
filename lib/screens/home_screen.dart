import 'package:flutter/material.dart';
import '../widgets/atm_card.dart';
import '../widgets/transaction_item.dart';
import '../models/transaction.dart';
import '../widgets/grid_menu_item.dart';
import '../screens/top_up_screen.dart';
import '../screens/transfer_screen.dart';
import '../screens/notification_screen.dart';
import 'all_cards_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedCardIndex = 0;
  // Index 0: Home, 1: (Dihapus: Mutasi), 2: QRIS (Visual/FAB), 3: (Dihapus: Aktivitas), 4: Akun
  int _currentNavIndex = 0;

  List<Map<String, dynamic>> atmCards = [
    {
      'bankName': 'Demz Bank',
      'cardNumber': '**** **** **** 2345',
      'cardHolder': 'Demas Nurjaman',
      'balance': 12500000.0,
      'image': 'assets/images/demzbank_card.png',
    },
    {
      'bankName': 'Finance Corp',
      'cardNumber': '**** **** **** 8765',
      'cardHolder': 'Demas Nurjaman',
      'balance': 5350000.0,
      'image': 'assets/images/demzbank_card.png',
    },
    // Kartu ATM Baru 1
    {
      'bankName': 'Mega Credit',
      'cardNumber': '**** **** **** 1001',
      'cardHolder': 'Demas Nurjaman',
      'balance': 7800000.0,
      'image': 'assets/images/demzbank_card.png',
    },
    // Kartu ATM Baru 2
    {
      'bankName': 'Saving Plus',
      'cardNumber': '**** **** **** 4321',
      'cardHolder': 'Demas Nurjaman',
      'balance': 2100000.0,
      'image': 'assets/images/demzbank_card.png',
    },
  ];

  List<String> unreadNotifications = [
    'Selamat datang kembali di Finance Mate!',
    'Pembaruan saldo berhasil pada pagi hari.',
  ];

  // Menambahkan transaksi dengan kategori Health
  List<TransactionModel> transactions = [
    TransactionModel('Coffee Shop', '-Rp35.000', 'Food'),
    TransactionModel('Grab Ride', '-Rp25.000', 'Travel'),
    TransactionModel('Puskesmas Raya', '-Rp150.000', 'Health'), // Transaksi Health baru
    TransactionModel('Salary', '+Rp5.000.000', 'Income'),
  ];

  String _formatRupiah(double amount) {
    final String formatted = amount.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.');
    return 'Rp$formatted';
  }
  
  // Fungsi _getCategoryIcon dihapus seperti yang diminta

  void _addTransaction(String title, String amount, String category) {
    setState(() {
      transactions.insert(0, TransactionModel(title, amount, category));
      if (transactions.length > 10) transactions.removeLast();
    });
  }

  void _deleteTransaction(int index) {
    final transactionToDelete = transactions[index];

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Transaksi "${transactionToDelete.title}" dihapus.'),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              transactions.insert(index, transactionToDelete);
              unreadNotifications.add(
                  'UNDO: Transaksi "${transactionToDelete.title}" dikembalikan.');
            });
          },
        ),
      ),
    );

    setState(() {
      transactions.removeAt(index);
      unreadNotifications
          .add('Transaksi dihapus: "${transactionToDelete.title}"');
    });
  }

  void _navigateToNotifications() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            NotificationScreen(notifications: unreadNotifications),
      ),
    );
  }

  void _navigateAndReceiveTopUpResult() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TopUpScreen()),
    );

    if (result != null && result is Map<String, dynamic>) {
      double nominal = result['nominal'];
      String method = result['method'];
      String bankName = atmCards[selectedCardIndex]['bankName']; 

      setState(() {
        atmCards[selectedCardIndex]['balance'] += nominal;
        
        // Tambah Notifikasi Top Up
        final formattedNominal = _formatRupiah(nominal);
        unreadNotifications.insert(
            0,
            'Top Up sebesar $formattedNominal ke $bankName via $method berhasil!'
        );
      });

      _addTransaction('Top Up via $method', '+${_formatRupiah(nominal)}', 'Income');
    }
  }

  void _navigateAndReceiveTransferResult() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TransferScreen()),
    );

    if (result != null && result is Map<String, dynamic>) {
      double nominal = result['nominal'];
      String rekening = result['rekening'];

      if (nominal > atmCards[selectedCardIndex]['balance']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transfer gagal: saldo tidak mencukupi.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        atmCards[selectedCardIndex]['balance'] -= nominal;
        final formattedNominal = _formatRupiah(nominal);
        unreadNotifications.insert(
            0, 'Transfer $formattedNominal ke rek. $rekening berhasil diproses.');
      });

      _addTransaction('Transfer ke Rek. $rekening', '-${_formatRupiah(nominal)}', 'Transfer');
    }
  }

  void _showUnderDevelopment(String featureName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Fitur "$featureName" masih dalam tahap pengembangan.'),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }

  void _navigateToAllCards() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllCardsScreen(atmCards: atmCards),
      ),
    );

    if (result != null && result is int) {
      setState(() {
        selectedCardIndex = result;
      });
    }
  }

  Widget _buildBody() {
    final selectedCard = atmCards[selectedCardIndex];

    if (_currentNavIndex == 0) {
      // Home
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('My Card',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D47A1))),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _navigateToAllCards,
              child: AtmCard(
                bankName: selectedCard['bankName'],
                cardNumber: selectedCard['cardNumber'],
                cardHolder: selectedCard['cardHolder'],
                balance: _formatRupiah(selectedCard['balance']),
                backgroundImage: selectedCard['image'],
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: _navigateToAllCards,
                child: const Text(
                  'Lihat Semua Kartu',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Categories',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D47A1))),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                GestureDetector(
                  onTap: () => _showUnderDevelopment('Health'),
                  child: const GridMenuItem(
                      icon: Icons.health_and_safety,
                      label: 'Health',
                      gradientStart: Color(0xFF42A5F5),
                      gradientEnd: Color(0xFF1976D2)),
                ),
                GestureDetector(
                  onTap: () => _showUnderDevelopment('Travel'),
                  child: const GridMenuItem(
                      icon: Icons.travel_explore,
                      label: 'Travel',
                      gradientStart: Color(0xFF64B5F6),
                      gradientEnd: Color(0xFF0D47A1)),
                ),
                GestureDetector(
                  onTap: () => _showUnderDevelopment('Food'),
                  child: const GridMenuItem(
                      icon: Icons.fastfood,
                      label: 'Food',
                      gradientStart: Color(0xFFFFA726),
                      gradientEnd: Color(0xFFFF7043)),
                ),
                GestureDetector(
                  onTap: _navigateAndReceiveTopUpResult,
                  child: const GridMenuItem(
                      icon: Icons.account_balance_wallet,
                      label: 'Top Up',
                      gradientStart: Color(0xFF42A5F5),
                      gradientEnd: Color(0xFF0D47A1)),
                ),
                GestureDetector(
                  onTap: _navigateAndReceiveTransferResult,
                  child: const GridMenuItem(
                      icon: Icons.send,
                      label: 'Transfer',
                      gradientStart: Color(0xFF90CAF9),
                      gradientEnd: Color(0xFF42A5F5)),
                ),
                GestureDetector(
                  onTap: () => _showUnderDevelopment('Event'),
                  child: const GridMenuItem(
                      icon: Icons.event,
                      label: 'Event',
                      gradientStart: Color(0xFF66BB6A),
                      gradientEnd: Color(0xFF388E3C)),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Recent Transactions',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D47A1))),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.blueGrey.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3)),
                    ],
                  ),
                  child: TransactionItem(
                    transaction: transactions[index],
                    onDelete: () => _deleteTransaction(index),
                  ),
                );
              },
            ),
          ],
        ),
      );
    } else if (_currentNavIndex == 4) {
      // Akun (Index 4)
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.account_circle, size: 120, color: Color(0xFF0D47A1)),
            SizedBox(height: 20),
            Text('Profil Akun',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D47A1))),
          ],
        ),
      );
    }
    // Jika _currentNavIndex == 2 (QRIS), tampilkan body Home
    return _buildBody(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0D47A1),
        title: const Text(
          'Finance Mate',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 22),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _navigateToNotifications,
            icon: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.notifications_none,
                    color: Colors.white, size: 28),
                if (unreadNotifications.isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        unreadNotifications.length > 9
                            ? '9+'
                            : unreadNotifications.length.toString(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
      // Tampilkan body sesuai index navigasi
      body: _buildBody(),
      
      // Tombol QRIS (Floating Action Button)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showUnderDevelopment('QRIS Payment / Scan');
        },
        backgroundColor: const Color(0xFF0D47A1), 
        elevation: 6.0,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.qr_code_scanner, 
          color: Colors.white, 
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // BottomAppBar untuk navigasi
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(), 
        notchMargin: 6.0, 
        elevation: 10,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              // Home (Index 0)
              _buildNavItem(0, Icons.home, 'Home'),
              
              // Jarak/Placeholder untuk FAB QRIS
              const SizedBox(width: 40), 
              
              // Akun (Index 4)
              _buildNavItem(4, Icons.account_circle, 'Akun'),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function untuk membangun setiap item navigasi
  Widget _buildNavItem(int index, IconData icon, String label) {
    // Hanya izinkan navigasi ke Home (0) dan Akun (4). 
    // Indeks lain (1, 2, 3) diabaikan atau hanya untuk FAB.
    if (index != 0 && index != 4) return const SizedBox.shrink();

    final isSelected = _currentNavIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _currentNavIndex = index;
            // Tidak perlu _showUnderDevelopment karena Mutasi(1) & Aktivitas(3) sudah dihapus dari sini.
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              color: isSelected
                  ? const Color(0xFF0D47A1) 
                  : Colors.grey.shade600, 
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isSelected
                    ? const Color(0xFF0D47A1)
                    : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}