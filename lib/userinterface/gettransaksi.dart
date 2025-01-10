import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../database/transaksi.dart';

class GetTransaksi extends StatefulWidget {
  const GetTransaksi({super.key});

  @override
  State<GetTransaksi> createState() => _GetTransaksiState();
}

class _GetTransaksiState extends State<GetTransaksi> {
  List<Transaksi> transaksiList = [];
  bool _isLoading = false;

  File? imageFile;

  @override
  void initState() {
    super.initState();
    _fetchTransaksi();
  }

  Future<void> _fetchTransaksi() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http
          .get(Uri.parse('http://andika.mobilekelasa.my.id/transaksi'));

      if (response.statusCode == 200) {
        final List<Transaksi> loadedTransaksi =
            transaksiFromJson(response.body);
        setState(() {
          transaksiList = loadedTransaksi;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load Transaksi');
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

  Future<void> _addTransaksi() async {
    final result = await showDialog<Transaksi>(
      context: context,
      builder: (BuildContext context) {
        final kodeTransaksiController = TextEditingController();
        final namaPelangganController = TextEditingController();
        final noHpController = TextEditingController();
        final namaBarangController = TextEditingController();
        final hargaBarangController = TextEditingController();
        final jumlahBarangController = TextEditingController();
        final totalHargaController = TextEditingController();

        return AlertDialog(
          title: const Text('Tambah Transaksi',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                _buildTextField(
                    kodeTransaksiController, 'Kode Transaksi', Icons.label),
                const SizedBox(height: 10),
                _buildTextField(
                    namaPelangganController, 'Nama Pelanggan', Icons.code),
                const SizedBox(height: 10),
                _buildTextField(noHpController, 'No Hp', Icons.attach_money,
                    keyboardType: TextInputType.number),
                const SizedBox(height: 10),
                _buildTextField(
                  namaBarangController,
                  'Nama Barang',
                  Icons.inventory,
                ),
                const SizedBox(height: 10),
                _buildTextField(
                    hargaBarangController, 'Harga Barang', Icons.inventory,
                    keyboardType: TextInputType.number),
                const SizedBox(height: 10),
                _buildTextField(
                    jumlahBarangController, 'Jumlah Barang', Icons.inventory,
                    keyboardType: TextInputType.number),
                const SizedBox(height: 10),
                _buildTextField(
                    totalHargaController, 'Total Harga', Icons.inventory,
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
                kodeTransaksiController.clear();
                namaPelangganController.clear();
                noHpController.clear();
                namaBarangController.clear();
                hargaBarangController.clear();
                jumlahBarangController.clear();
                totalHargaController.clear();
              },
              child: const Text('Batal',
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              onPressed: () async {
                if (kodeTransaksiController.text.isEmpty ||
                    namaPelangganController.text.isEmpty ||
                    noHpController.text.isEmpty ||
                    namaBarangController.text.isEmpty ||
                    hargaBarangController.text.isEmpty ||
                    jumlahBarangController.text.isEmpty ||
                    totalHargaController.text.isEmpty) {
                  _showCustomSnackBar('Semua field harus diisi!',
                      isError: true);
                  return;
                }

                try {
                  final response = await http.post(
                    Uri.parse(
                        'http://andika.mobilekelasa.my.id/transaksi/simpan'),
                    body: {
                      'kodetransaksi': kodeTransaksiController.text,
                      'namapelanggan': namaPelangganController.text,
                      'nohp': noHpController.text,
                      'namabarang': namaBarangController.text,
                      'hargabarang': hargaBarangController.text.isEmpty
                          ? '0'
                          : int.parse(hargaBarangController.text).toString(),
                      'jumlahbarang': jumlahBarangController.text.isEmpty
                          ? '0'
                          : int.parse(jumlahBarangController.text).toString(),
                      'totalharga': totalHargaController.text.isEmpty
                          ? '0'
                          : int.parse(totalHargaController.text).toString(),
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
                      jsonResponse['jumlahbarang'] = int.tryParse(
                              jsonResponse['jumlahbarang'].toString()) ??
                          0;
                      jsonResponse['totalharga'] =
                          int.tryParse(jsonResponse['totalharga'].toString()) ??
                              0;

                      final newTransaksi = Transaksi.fromJson(jsonResponse);
                      Navigator.pop(context, newTransaksi);

                      // Clear controllers setelah sukses
                      kodeTransaksiController.clear();
                      namaPelangganController.clear();
                      noHpController.clear();
                      namaBarangController.clear();
                      hargaBarangController.clear();
                      jumlahBarangController.clear();
                      totalHargaController.clear();

                      _showCustomSnackBar('Transaksi berhasil ditambahkan');
                    } else {
                      throw Exception('Response body is empty');
                    }
                  } else {
                    throw Exception(
                        'Failed to add transaksi: ${response.statusCode}');
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
        transaksiList.add(result);
      });
      _showCustomSnackBar('Transaksi berhasil ditambahkan');
    } else {
      await _fetchTransaksi();
    }
  }

  // Fungsi untuk menghapus transaksi
  Future<void> _deleteTransaksi(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('http://andika.mobilekelasa.my.id/transaksi/hapus/$id'),
      );

      if (response.statusCode == 200) {
        await _fetchTransaksi(); // Refresh data setelah menghapus
        _showCustomSnackBar('Transaksi berhasil dihapus');
      } else {
        throw Exception('Failed to delete transaksi');
      }
    } catch (e) {
      _showCustomSnackBar('Error: ${e.toString()}', isError: true);
    }
  }

// Fungsi untuk mengedit transaksi
  Future<void> _editTransaksi(Transaksi transaksi) async {
    await showDialog<Transaksi>(
      context: context,
      builder: (BuildContext context) {
        final kodeTranasaksiController =
            TextEditingController(text: transaksi.kodetransaksi);
        final namaPelangganController =
            TextEditingController(text: transaksi.namapelanggan);
        final noHpController = TextEditingController(text: transaksi.nohp);
        final namaBarangController =
            TextEditingController(text: transaksi.namabarang);
        final hargaBarangController =
            TextEditingController(text: transaksi.hargabarang.toString());
        final jumlahBarangController =
            TextEditingController(text: transaksi.jumlahbarang.toString());
        final totalHargaController =
            TextEditingController(text: transaksi.totalharga.toString());

        return AlertDialog(
          title: const Text('Edit Transaksi',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(
                    kodeTranasaksiController, 'Kode Transaksi', Icons.code),
                const SizedBox(height: 10),
                _buildTextField(
                    namaPelangganController, 'Nama Pelanggan', Icons.label),
                const SizedBox(height: 10),
                _buildTextField(noHpController, 'No Hp', Icons.phone),
                const SizedBox(height: 10),
                _buildTextField(
                    namaBarangController, 'Nama Barang', Icons.label),
                const SizedBox(height: 10),
                _buildTextField(
                    hargaBarangController, 'Harga Barang', Icons.attach_money,
                    keyboardType: TextInputType.number),
                const SizedBox(height: 10),
                _buildTextField(
                    jumlahBarangController, 'Jumlah Barang', Icons.inventory,
                    keyboardType: TextInputType.number),
                const SizedBox(height: 10),
                _buildTextField(
                    totalHargaController, 'Total Harga', Icons.attach_money,
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
                        'http://andika.mobilekelasa.my.id/transaksi/ubah/${transaksi.id}'),
                    body: {
                      'kodetransaksi': kodeTranasaksiController.text,
                      'namapelanggan': namaPelangganController.text,
                      'nohp': noHpController.text,
                      'namabarang': namaBarangController.text,
                      'hargabarang': hargaBarangController.text,
                      'jumlahbarang': jumlahBarangController.text,
                      'totalharga': totalHargaController.text,
                    },
                  );

                  if (response.statusCode == 200) {
                    Navigator.pop(context);
                    await _fetchTransaksi(); // Refresh data setelah edit
                    _showCustomSnackBar('Transaksi berhasil diubah');
                  } else {
                    throw Exception('Failed to edit transaksi');
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
          title: const Center(child: Text('Daftar Transaksi')),
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
                  itemCount: transaksiList.length,
                  itemBuilder: (context, index) {
                    final transaksi = transaksiList[index];
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
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Image(
                              image: AssetImage('lib/images/Nota.png'),
                              width: 30,
                              height: 30,
                            )),
                        title: Text(
                          transaksi.kodetransaksi,
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
                              transaksi.namapelanggan,
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              'NoHp: ${transaksi.nohp}',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                            Text(
                              'Jumlah: ${transaksi.jumlahbarang}',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Rp ${transaksi.totalharga.toString()}',
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
                              onPressed: () => _editTransaksi(transaksi),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Konfirmasi'),
                                    content: const Text(
                                        'Yakin ingin menghapus Transaksi ini?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Batal'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          _deleteTransaksi(transaksi.id);
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
        onPressed: _addTransaksi,
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
