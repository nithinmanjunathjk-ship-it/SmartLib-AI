import 'package:flutter/material.dart';
import '../models.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _deptController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: sampleStudent.name);
    _emailController = TextEditingController(text: sampleStudent.email);
    _phoneController = TextEditingController(text: sampleStudent.phone);
    _deptController = TextEditingController(text: sampleStudent.department);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _deptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5FA),
        elevation: 0,
        title: const Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: const Color(0xFF5B67CA),
                    child: Text(sampleStudent.name[0],
                        style: const TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  Positioned(
                    bottom: 0, right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: Color(0xFF5B67CA), shape: BoxShape.circle),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text('Student ID: ${sampleStudent.usn}', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 28),

            _buildField('Full Name', _nameController, Icons.person_outline),
            const SizedBox(height: 16),
            _buildField('Email', _emailController, Icons.email_outlined, readOnly: true),
            const SizedBox(height: 16),
            _buildField('Phone', _phoneController, Icons.phone_outlined, keyboardType: TextInputType.phone),
            const SizedBox(height: 16),
            _buildField('Department', _deptController, Icons.school_outlined),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile updated successfully!'), backgroundColor: Color(0xFF5B67CA)),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B67CA),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Save Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, IconData icon,
      {bool readOnly = false, TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: Colors.grey)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: TextField(
            controller: controller,
            readOnly: readOnly,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: const Color(0xFF5B67CA), size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              suffixIcon: readOnly ? const Icon(Icons.lock_outline, size: 16, color: Colors.grey) : null,
            ),
          ),
        ),
      ],
    );
  }
}
