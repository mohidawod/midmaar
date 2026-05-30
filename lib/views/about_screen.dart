import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/main_viewmodel.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('عن التطبيق'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // أيقونة التطبيق
            Icon(
              Icons.quiz,
              size: 80,
              color: Colors.greenAccent.shade400,
            ),
            const SizedBox(height: 16),
            // اسم التطبيق
            Text(
              'مضمار',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.greenAccent.shade400,
              ),
            ),
            const SizedBox(height: 8),
            // الوصف
            const Text(
              'Arcade Quiz Game',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            // معلومات المطور
            _buildInfoRow(Icons.person, 'المطور', 'Mohammed Dawood'),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.email, 'تواصل معي', 'mohidawod@gmail.com'),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.code, 'الإصدار', '1.0.0'),
            const SizedBox(height: 40),
            // جملة السودان
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🇸🇩', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 8),
                const Text(
                  'هذا التطبيق صُنع بحب من السودان',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Divider(color: Colors.grey),
            const SizedBox(height: 16),
            // زر إعادة تعيين النقاط
            GestureDetector(
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('إعادة تعيين النقاط'),
                    content: const Text('هل أنت متأكد؟ سيتم مسح كل نقاطك.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('إلغاء'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('نعم', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
                
                if (confirm == true) {
                  final mainVm = Provider.of<MainViewModel>(context, listen: false);
                  await mainVm.resetScore();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم إعادة تعيين النقاط إلى 0')),
                    );
                  }
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade700),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.refresh, size: 20, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      'إعادة تعيين النقاط',
                      style: TextStyle(color: Colors.grey.shade400),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Colors.greenAccent.shade400),
        const SizedBox(width: 16),
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}