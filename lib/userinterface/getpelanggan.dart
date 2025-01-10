import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../database/pelanggan.dart';

class GetPelanggan extends StatefulWidget {
  const GetPelanggan({super.key});

  @override
  State<GetPelanggan> createState() => _GetPelangganState();
}

class _GetPelangganState extends State<GetPelanggan> {
  List<Pelanggan> pelangganList = [];
  bool _isLoading = false;

  File? imageFile;

  @override
  void initState() {
    super.initState();
    _fetchPelanggan();
  }

  Future<void> _fetchPelanggan() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http
          .get(Uri.parse('http://andika.mobilekelasa.my.id/pelanggan'));

      if (response.statusCode == 200) {
        final List<Pelanggan> loadedPelanggan =
            pelangganFromJson(response.body);
        setState(() {
          pelangganList = loadedPelanggan;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load pelanggan');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showCustomSnackBar('Error: ${e.toString()}', isError: !true);
    }
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
    );
  }

  void _showCustomSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(10),
      ),
    );
  }

  Future<void> _addPelanggan() async {
    final result = await showDialog<Pelanggan>(
      context: context,
      builder: (BuildContext context) {
        final namaPelangganController = TextEditingController();
        final noHpController = TextEditingController();
        final eMailController = TextEditingController();

        return AlertDialog(
          title: const Text('Tambah Pelanggan',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(
                    namaPelangganController, 'Nama Pelanggan', Icons.label),
                const SizedBox(height: 10),
                _buildTextField(noHpController, 'No Hp', Icons.phone),
                const SizedBox(height: 10),
                _buildTextField(eMailController, 'E-Mail', Icons.email,
                    keyboardType: TextInputType.number),
                const SizedBox(height: 10),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Hanya menutup dialog tanpa menyimpan data
                Navigator.of(context).pop();
                // Reset form fields jika diperlukan
                namaPelangganController.clear();
                noHpController.clear();
                eMailController.clear();
              },
              child: const Text('Batal',
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              onPressed: () async {
                if (namaPelangganController.text.isEmpty ||
                    noHpController.text.isEmpty ||
                    eMailController.text.isEmpty) {
                  _showCustomSnackBar('Semua field harus diisi!',
                      isError: true);
                  return;
                }

                try {
                  final response = await http.post(
                    Uri.parse(
                        'http://andika.mobilekelasa.my.id/pelanggan/simpan'),
                    body: {
                      'namapelanggan': namaPelangganController.text,
                      'nohp': noHpController.text,
                      'email': eMailController.text
                    },
                  );

                  if (response.statusCode == 200) {
                    if (response.body.isNotEmpty) {
                      final Map<String, dynamic> jsonResponse =
                          jsonDecode(response.body);

                      final newPelanggan = Pelanggan.fromJson(jsonResponse);
                      Navigator.pop(context, newPelanggan);

                      // Clear controllers setelah sukses
                      namaPelangganController.clear();
                      noHpController.clear();
                      eMailController.clear();

                      _showCustomSnackBar('Pelanggan berhasil ditambahkan');
                    } else {
                      throw Exception('Response body is empty');
                    }
                  } else {
                    throw Exception(
                        'Failed to add pelanggan: ${response.statusCode}');
                  }
                } catch (e) {
                  print('Error detail: $e');
                  _showCustomSnackBar('Error: ${e.toString()}', isError: true);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3E7B27),
                foregroundColor: Colors.white,
              ),
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      setState(() {
        pelangganList.add(result);
      });
      _showCustomSnackBar('Pelanggan berhasil ditambahkan');
    } else {
      await _fetchPelanggan();
    }
  }

  // Fungsi untuk menghapus pelanggan
  Future<void> _deletePelanggan(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('http://andika.mobilekelasa.my.id/pelanggan/hapus/$id'),
      );

      if (response.statusCode == 200) {
        await _fetchPelanggan(); // Refresh data setelah menghapus
        _showCustomSnackBar('Pelanggan berhasil dihapus');
      } else {
        throw Exception('Failed to delete Pelanggan');
      }
    } catch (e) {
      _showCustomSnackBar('Error: ${e.toString()}', isError: true);
    }
  }

// Fungsi untuk mengedit pelanggan
  Future<void> _editPelanggan(Pelanggan pelanggan) async {
    await showDialog<Pelanggan>(
      context: context,
      builder: (BuildContext context) {
        final namaPelangganController =
            TextEditingController(text: pelanggan.namapelanggan);
        final noHpController = TextEditingController(text: pelanggan.nohp);
        final eMailController = TextEditingController(text: pelanggan.email);

        return AlertDialog(
          title: const Text('Edit Pelanggan',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(
                    namaPelangganController, 'Nama Pelanggan', Icons.label),
                const SizedBox(height: 10),
                _buildTextField(
                    noHpController, 'No Hp', Icons.phone),
                const SizedBox(height: 10),
                _buildTextField(
                    eMailController, 'E-Mail', Icons.email,
                    keyboardType: TextInputType.number),
                const SizedBox(height: 10),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal',
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final response = await http.put(
                    Uri.parse(
                        'http://andika.mobilekelasa.my.id/pelanggan/ubah/${pelanggan.id}'),
                    body: {
                      'namapelanggan': namaPelangganController.text,
                      'nohp': noHpController.text,
                      'email': eMailController.text,
                    },
                  );

                  if (response.statusCode == 200) {
                    Navigator.pop(context);
                    await _fetchPelanggan(); // Refresh data setelah edit
                    _showCustomSnackBar('Pelanggan berhasil diubah');
                  } else {
                    throw Exception('Failed to edit Pelanggan');
                  }
                } catch (e) {
                  _showCustomSnackBar('Error: ${e.toString()}', isError: true);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3E7B27),
                foregroundColor: Colors.white,
              ),
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Center(child: Text('Daftar Pelanggan')),
          elevation: 2,
          backgroundColor: Color(0xFF3E7B27),
          foregroundColor: Color.fromARGB(255, 239, 227, 194)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              color: Color(0xFFa7c957),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: pelangganList.length,
                  itemBuilder: (context, index) {
                    final pelanggan = pelangganList[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 0),
                      child: ListTile(
                        tileColor: Color(0xFFEFE3C2),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        leading: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Image(
                              image: AssetImage('lib/images/Pelanggan.png'),
                              width: 100,
                              height: 100,
                            )),
                        title: Text(
                          pelanggan.namapelanggan,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              'No Hp: ${pelanggan.nohp}',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                            Text(
                              'E-Mail: ${pelanggan.email}',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon:
                                  const Icon(Icons.edit, color: Colors.orange),
                              onPressed: () => _editPelanggan(pelanggan),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Konfirmasi'),
                                    content: const Text(
                                        'Yakin ingin menghapus pelanggan ini?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Batal'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          _deletePelanggan(pelanggan.id);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                        ),
                                        child: const Text('Hapus'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPelanggan,
        backgroundColor: Color(0xFF3E7B27),
        foregroundColor: Color(0xFFEFE3C2),
        child: Icon(Icons.add),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
