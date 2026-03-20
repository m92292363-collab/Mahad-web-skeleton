import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// QR Code Painter - Creates a realistic black QR code pattern
class QRCodePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    
    final blockSize = size.width / 33;
    
    final pattern = <Rect>[];
    
    // Position markers (the big squares in corners) - Top Left
    for (int i = 0; i < 7; i++) {
      for (int j = 0; j < 7; j++) {
        if ((i == 0 || i == 6 || j == 0 || j == 6) || 
            (i >= 2 && i <= 4 && j >= 2 && j <= 4)) {
          pattern.add(Rect.fromLTWH(i * blockSize, j * blockSize, blockSize, blockSize));
        }
      }
    }
    
    // Position markers - Top Right
    for (int i = 0; i < 7; i++) {
      for (int j = 0; j < 7; j++) {
        if ((i == 0 || i == 6 || j == 0 || j == 6) || 
            (i >= 2 && i <= 4 && j >= 2 && j <= 4)) {
          pattern.add(Rect.fromLTWH((26 + i) * blockSize, j * blockSize, blockSize, blockSize));
        }
      }
    }
    
    // Position markers - Bottom Left
    for (int i = 0; i < 7; i++) {
      for (int j = 0; j < 7; j++) {
        if ((i == 0 || i == 6 || j == 0 || j == 6) || 
            (i >= 2 && i <= 4 && j >= 2 && j <= 4)) {
          pattern.add(Rect.fromLTWH(i * blockSize, (26 + j) * blockSize, blockSize, blockSize));
        }
      }
    }
    
    // Timing patterns
    for (int i = 8; i < 25; i++) {
      if (i.isEven) {
        pattern.add(Rect.fromLTWH(i * blockSize, 6 * blockSize, blockSize, blockSize));
        pattern.add(Rect.fromLTWH(6 * blockSize, i * blockSize, blockSize, blockSize));
      }
    }
    
    // Alignment pattern (center)
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 5; j++) {
        if ((i == 0 || i == 4 || j == 0 || j == 4) || (i == 2 && j == 2)) {
          pattern.add(Rect.fromLTWH((14 + i) * blockSize, (14 + j) * blockSize, blockSize, blockSize));
        }
      }
    }
    
    // Random data modules
    for (int i = 0; i < 33; i++) {
      for (int j = 0; j < 33; j++) {
        if ((i < 7 && j < 7) || (i < 7 && j > 25) || (i > 25 && j < 7) || 
            (i > 13 && i < 19 && j > 13 && j < 19)) {
          continue;
        }
        if ((i * j) % 3 == 0 || (i + j) % 5 == 2 || (i * j) % 7 == 1) {
          pattern.add(Rect.fromLTWH(i * blockSize, j * blockSize, blockSize, blockSize));
        }
      }
    }
    
    for (var rect in pattern) {
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

void main() {
  runApp(const FlowFinanceApp());
}

class FlowFinanceApp extends StatelessWidget {
  const FlowFinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flow Finance',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        fontFamily: GoogleFonts.inter().fontFamily,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF4CAF50),
          secondary: Color(0xFF2E7D32),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _isBalanceHidden = false;

  final List<Map<String, dynamic>> _transactions = [
    {'icon': Icons.shopping_bag, 'name': 'Grocery Store', 'date': 'Today', 'amount': 45.50, 'isPositive': false},
    {'icon': Icons.bolt, 'name': 'Electric Bill', 'date': 'Yesterday', 'amount': 89.99, 'isPositive': false},
    {'icon': Icons.account_balance, 'name': 'Salary Deposit', 'date': 'Mar 15', 'amount': 2500.00, 'isPositive': true},
    {'icon': Icons.restaurant, 'name': 'Lunch Cafe', 'date': 'Mar 14', 'amount': 23.50, 'isPositive': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomePage(),
          _buildHistoryPage(),
          _buildPayPage(),
          _buildCardsPage(),
          _buildProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF4CAF50),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: 'Pay'),
          BottomNavigationBarItem(icon: Icon(Icons.credit_card), label: 'Cards'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildHomePage() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back,',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'John Doe',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2E7D32),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.notifications_outlined,
                      color: Color(0xFF2E7D32),
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Balance Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Balance',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 36),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            _isBalanceHidden ? '••••••' : 'D12,450.00',
                            style: GoogleFonts.inter(
                              fontSize: 40,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: -0.5,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isBalanceHidden = !_isBalanceHidden;
                              });
                            },
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                _isBalanceHidden ? Icons.visibility_off : Icons.visibility,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.qr_code_scanner,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Scan to pay',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Quick and secure',
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    color: Colors.white54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),

            // Quick Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Actions',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1B5E20),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildQuickAction(Icons.send, 'Send', const Color(0xFF4CAF50)),
                      _buildQuickAction(Icons.bolt, 'Bills', const Color(0xFF4CAF50)),
                      _buildQuickAction(Icons.phone_android, 'Mobile', const Color(0xFF4CAF50)),
                      _buildQuickAction(Icons.shopping_cart, 'Shop', const Color(0xFF4CAF50)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Recent Transactions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Transactions',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1B5E20),
                    ),
                  ),
                  TextButton(
                    onPressed: () => setState(() => _selectedIndex = 1),
                    child: Text(
                      'See All',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF4CAF50),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _transactions.length,
              itemBuilder: (context, index) => _buildTransaction(_transactions[index]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryPage() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _transactions.length,
      itemBuilder: (context, index) => _buildTransaction(_transactions[index]),
    );
  }

  Widget _buildPayPage() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Pay',
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1B5E20),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Scan QR code to pay securely',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            
            // QR Code Card
            Center(
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 350),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                  ),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // QR Code
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: CustomPaint(
                            size: const Size(160, 160),
                            painter: QRCodePainter(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Scan Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _showComingSoon('Scan QR Code');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF2E7D32),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'Open Scanner',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Enter Amount Manually Link
                      GestureDetector(
                        onTap: () => _showComingSoon('Enter Amount Manually'),
                        child: Text(
                          'Enter amount manually',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.white70,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Recent Contacts Section
            Text(
              'Recent Contacts',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1B5E20),
              ),
            ),
            const SizedBox(height: 12),
            
            // Contacts Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildContactAvatar('JD', 'John'),
                  _buildContactAvatar('SD', 'Sarah'),
                  _buildContactAvatar('MK', 'Mike'),
                  _buildContactAvatar('AL', 'Alice'),
                  _buildContactAvatar('RJ', 'Raj'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardsPage() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.credit_card, size: 80, color: Color(0xFF4CAF50)),
          SizedBox(height: 20),
          Text('Your Cards', style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          Text('Coming Soon', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildProfilePage() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Color(0xFFE8F5E9),
            child: Icon(Icons.person, size: 50, color: Color(0xFF2E7D32)),
          ),
          SizedBox(height: 20),
          Text('John Doe', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          Text('john.doe@email.com', style: TextStyle(color: Colors.grey)),
          SizedBox(height: 20),
          Text('Profile Settings Coming Soon'),
        ],
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 65,
          height: 65,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            icon,
            color: color,
            size: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF2E7D32),
          ),
        ),
      ],
    );
  }

  Widget _buildTransaction(Map<String, dynamic> t) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(t['icon'], color: const Color(0xFF2E7D32), size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t['name'],
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  t['date'],
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${t['isPositive'] ? '+' : '-'}D${t['amount']}',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: t['isPositive'] ? const Color(0xFF4CAF50) : Colors.red[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactAvatar(String initials, String name) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF4CAF50),
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                initials,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2E7D32),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature coming soon!'),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}