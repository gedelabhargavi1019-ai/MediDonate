import 'package:flutter/material.dart';
import 'receiver_form.dart';
import 'medicine_request.dart';
import 'medicine_result.dart';
import 'login_screen.dart';
import '../database/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReceiverDashboard extends StatefulWidget {
  const ReceiverDashboard({super.key});

  @override
  State<ReceiverDashboard> createState() => _ReceiverDashboardState();
}

class _ReceiverDashboardState extends State<ReceiverDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const ReceiverHomeScreen(),
    const ReceiverForm(),
    const MedicineRequest(),
    const MedicineResult(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receiver Dashboard'),
        backgroundColor: const Color(0xFF4A90E2),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showLogoutDialog();
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4A90E2), Color(0xFFFFD93D)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          backgroundColor: Colors.transparent,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_add),
              label: 'Register',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Request',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.medical_services),
              label: 'Results',
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF4A90E2))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            child: const Text('Logout', style: TextStyle(color: Color(0xFFFF6B35))),
          ),
        ],
      ),
    );
  }
}

class ReceiverHomeScreen extends StatefulWidget {
  const ReceiverHomeScreen({super.key});

  @override
  State<ReceiverHomeScreen> createState() => _ReceiverHomeScreenState();
}

class _ReceiverHomeScreenState extends State<ReceiverHomeScreen> {
  int _requestCount = 0;
  int _approvedCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userEmail = prefs.getString('userEmail');
      
      if (userEmail != null) {
        final requests = await DatabaseHelper.instance.getRequestsByReceiver(userEmail);
        if (mounted) {
          setState(() {
            _requestCount = requests.length;
            _approvedCount = requests.where((r) => r.status == 'Approved').length;
            _isLoading = false;
          });
        }
      } else {
        final allRequests = await DatabaseHelper.instance.getAllRequests();
        if (mounted) {
          setState(() {
            _requestCount = allRequests.length;
            _approvedCount = allRequests.where((r) => r.status == 'Approved').length;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFE3F2FD),
            Color(0xFFFFF3E0),
          ],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A90E2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.health_and_safety,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome, Receiver!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A90E2),
                          ),
                        ),
                        Text(
                          'Find the medicine you need',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFFFF6B35),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              _buildStatCard(
                'Requests Made',
                _isLoading ? '...' : _requestCount.toString(),
                Icons.request_page,
                const Color(0xFF4A90E2),
              ),
              const SizedBox(height: 20),
              _buildStatCard(
                'Medicines Received',
                _isLoading ? '...' : _approvedCount.toString(),
                Icons.check_circle,
                const Color(0xFFFF6B35),
              ),
              const SizedBox(height: 30),
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A90E2),
                ),
              ),
              const SizedBox(height: 15),
              _buildQuickAction(
                context,
                'Register as Receiver',
                Icons.person_add,
                const Color(0xFF4A90E2),
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ReceiverForm()),
                ),
              ),
              const SizedBox(height: 15),
              _buildQuickAction(
                context,
                'Request Medicine',
                Icons.search,
                const Color(0xFFFF6B35),
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MedicineRequest()),
                ),
              ),
              const SizedBox(height: 15),
              _buildQuickAction(
                context,
                'View Results',
                Icons.medical_services,
                const Color(0xFFFFD93D),
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MedicineResult()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.05)],
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [color.withValues(alpha: 0.8), color.withValues(alpha: 0.6)],
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 32),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
