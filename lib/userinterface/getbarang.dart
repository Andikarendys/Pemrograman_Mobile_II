import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import '../database/barang.dart';

class GetBarang extends StatefulWidget {
  const GetBarang({super.key});

  @override
  State<GetBarang> createState() => _GetBarangState();
}

class _GetBarangState extends State<GetBarang> {
  List<Barang> barangList = [];
  bool _isLoading = false;

  File? imageFile;

  @override
  void initState() {
    super.initState();
    _fetchBarang();
  }

  Future<void> _fetchBarang() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response =
          await http.get(Uri.parse('http://andika.mobilekelasa.my.id/barang'));

      if (response.statusCode == 200) {
        final List<Barang> loadedBarang = barangFromJson(response.body);
        setState(() {
          barangList = loadedBarang;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load barang');
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

  Future<void> _addBarang() async {
    final result = await showDialog<Barang>(
      context: context,
      builder: (BuildContext context) {
        final namaBarangController = TextEditingController();
        final kodeBarangController = TextEditingController();
        final hargaBarangController = TextEditingController();
        final stokBarangController = TextEditingController();

        return AlertDialog(
          title: const Text('Tambah Barang',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(
                    namaBarangController, 'Nama Barang', Icons.label),
                const SizedBox(height: 10),
                _buildTextField(
                    kodeBarangController, 'Kode Barang', Icons.code),
                const SizedBox(height: 10),
                _buildTextField(
                    hargaBarangController, 'Harga Barang', Icons.attach_money,
                    keyboardType: TextInputType.number),
                const SizedBox(height: 10),
                _buildTextField(
                    stokBarangController, 'Stok Barang', Icons.inventory,
                    keyboardType: TextInputType.number),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                    onPressed: () {
                      PickImageFromGallery();
                    },
                    label: Text('Gambar'),
                    icon: Icon(Icons.image))
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Hanya menutup dialog tanpa menyimpan data
                Navigator.of(context).pop();
                // Reset form fields jika diperlukan
                namaBarangController.clear();
                kodeBarangController.clear();
                hargaBarangController.clear();
                stokBarangController.clear();
              },
              child: const Text('Batal',
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              onPressed: () async {
                if (namaBarangController.text.isEmpty ||
                    kodeBarangController.text.isEmpty ||
                    hargaBarangController.text.isEmpty ||
                    stokBarangController.text.isEmpty) {
                  _showCustomSnackBar('Semua field harus diisi!',
                      isError: true);
                  return;
                }

                try {
                  final response = await http.post(
                    Uri.parse('http://andika.mobilekelasa.my.id/barang/simpan'),
                    body: {
                      'namabarang': namaBarangController.text,
                      'kodebarang': kodeBarangController.text,
                      'hargabarang': hargaBarangController.text.isEmpty
                          ? '0'
                          : int.parse(hargaBarangController.text).toString(),
                      'stokbarang': stokBarangController.text.isEmpty
                          ? '0'
                          : int.parse(stokBarangController.text).toString(),
                      'gambarbarang': 'default.jpg',
                    },
                  );

                  if (response.statusCode == 200) {
                    if (response.body.isNotEmpty) {
                      final Map<String, dynamic> jsonResponse =
                          jsonDecode(response.body);

                      // Pastikan nilai numerik diparse dengan benar
                      jsonResponse['hargabarang'] = int.tryParse(
                              jsonResponse['hargabarang'].toString()) ??
                          0;
                      jsonResponse['stokbarang'] =
                          int.tryParse(jsonResponse['stokbarang'].toString()) ??
                              0;

                      final newBarang = Barang.fromJson(jsonResponse);
                      Navigator.pop(context, newBarang);

                      // Clear controllers setelah sukses
                      namaBarangController.clear();
                      kodeBarangController.clear();
                      hargaBarangController.clear();
                      stokBarangController.clear();

                      _showCustomSnackBar('Barang berhasil ditambahkan');
                    } else {
                      throw Exception('Response body is empty');
                    }
                  } else {
                    throw Exception(
                        'Failed to add barang: ${response.statusCode}');
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
        barangList.add(result);
      });
      _showCustomSnackBar('Barang berhasil ditambahkan');
    } else {
      await _fetchBarang();
    }
  }

  // Fungsi untuk menghapus barang
  Future<void> _deleteBarang(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('http://andika.mobilekelasa.my.id/barang/hapus/$id'),
      );

      if (response.statusCode == 200) {
        await _fetchBarang(); // Refresh data setelah menghapus
        _showCustomSnackBar('Barang berhasil dihapus');
      } else {
        throw Exception('Failed to delete barang');
      }
    } catch (e) {
      _showCustomSnackBar('Error: ${e.toString()}', isError: true);
    }
  }

// Fungsi untuk mengedit barang
  Future<void> _editBarang(Barang barang) async {
    await showDialog<Barang>(
      context: context,
      builder: (BuildContext context) {
        final namaBarangController =
            TextEditingController(text: barang.namabarang);
        final kodeBarangController =
            TextEditingController(text: barang.kodebarang);
        final hargaBarangController =
            TextEditingController(text: barang.hargabarang.toString());
        final stokBarangController =
            TextEditingController(text: barang.stokbarang.toString());

        return AlertDialog(
          title: const Text('Edit Barang',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(
                    namaBarangController, 'Nama Barang', Icons.label),
                const SizedBox(height: 10),
                _buildTextField(
                    kodeBarangController, 'Kode Barang', Icons.code),
                const SizedBox(height: 10),
                _buildTextField(
                    hargaBarangController, 'Harga Barang', Icons.attach_money,
                    keyboardType: TextInputType.number),
                const SizedBox(height: 10),
                _buildTextField(
                    stokBarangController, 'Stok Barang', Icons.inventory,
                    keyboardType: TextInputType.number),
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
                        'http://andika.mobilekelasa.my.id/barang/ubah/${barang.id}'),
                    body: {
                      'namabarang': namaBarangController.text,
                      'kodebarang': kodeBarangController.text,
                      'hargabarang': hargaBarangController.text,
                      'stokbarang': stokBarangController.text,
                      'gambarbarang': barang.gambarbarang,
                    },
                  );

                  if (response.statusCode == 200) {
                    Navigator.pop(context);
                    await _fetchBarang(); // Refresh data setelah edit
                    _showCustomSnackBar('Barang berhasil diubah');
                  } else {
                    throw Exception('Failed to edit barang');
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

  Future<void> PickImageFromGallery() async {
    final picker = ImagePicker();
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path);
        });
        _showCustomSnackBar('Gambar berhasil dipilih');
      }
    } catch (e) {
      _showCustomSnackBar('Error saat memilih gambar: $e', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Center(child: Text('Daftar Sayur')),
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
                  itemCount: barangList.length,
                  itemBuilder: (context, index) {
                    final barang = barangList[index];
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
                              image: AssetImage('lib/images/box_veggie.png'),
                              width: 50,
                              height: 50,
                            )),
                        title: Text(
                          barang.namabarang,
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
                              'Kode: ${barang.kodebarang}',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                            Text(
                              'Stok: ${barang.stokbarang}',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Rp ${barang.hargabarang.toString()}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 16),
                            IconButton(
                              icon:
                                  const Icon(Icons.edit, color: Colors.orange),
                              onPressed: () => _editBarang(barang),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Konfirmasi'),
                                    content: const Text(
                                        'Yakin ingin menghapus barang ini?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Batal'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          _deleteBarang(barang.id);
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
        onPressed: _addBarang,
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
