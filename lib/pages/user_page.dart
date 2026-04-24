import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqlite_pam/domain/entities/user_entity.dart';

import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';

class UserFormPage extends StatefulWidget {
  final UserEntity? user;

  const UserFormPage({super.key, this.user});

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _nameController.text = widget.user!.name;
      _emailController.text = widget.user!.email;
      _phoneController.text = widget.user!.phone;
      _addressController.text = widget.user!.address;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.user != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit User" : "Tambah User")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Nama Lengkap", 
                border: OutlineInputBorder()
                ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Email", 
                border: OutlineInputBorder()
              ),
            ),
            const SizedBox(height: 20),
            TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone, // Memunculkan keyboard angka/telepon
            decoration: const InputDecoration(
              labelText: "No Telpon", 
              hintText: "+62...", // Petunjuk format untuk user
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _addressController,
            maxLines: 3, // Agar kotak alamat lebih tinggi (bisa multi-baris)
            decoration: const InputDecoration(
              labelText: "Alamat", 
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  final phoneText = _phoneController.text.trim();

                if (!phoneText.startsWith('+62')) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No Telpon harus diawali dengan +62')),
                  );
                  return; // Hentikan proses jika salah
                }

                if (phoneText.length > 15) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No Telpon maksimal 15 karakter')),
                  );
                  return; // Hentikan proses jika salah
                }
                  final newUser = UserEntity(
                    id: isEdit ? widget.user!.id : DateTime.now().millisecondsSinceEpoch.toString(),
                    name: _nameController.text,
                    email: _emailController.text,
                    phone: phoneText,        
                    address: _addressController.text.trim(),

                  );

                  if (isEdit) {
                    context.read<UserBloc>().add(UpdateUserEvent(newUser));
                  } else {
                    context.read<UserBloc>().add(AddUserEvent(newUser));
                  }

                  Navigator.pop(context);
                },
                child: Text(isEdit ? "Simpan Perubahan" : "Simpan User Baru"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}