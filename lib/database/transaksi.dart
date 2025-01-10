import 'dart:convert';

List<Transaksi> transaksiFromJson(String str) =>
    List<Transaksi>.from(json.decode(str).map((x) => Transaksi.fromJson(x)));

String transaksiToJson(List<Transaksi> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Transaksi {
  final int id;
  final String kodetransaksi;
  final String namapelanggan;
  final String nohp;
  final String namabarang;
  final int hargabarang;
  final int jumlahbarang;
  final int totalharga;
  final DateTime createdAt;
  final DateTime updatedAt;

  Transaksi({
    required this.id,
    required this.kodetransaksi,
    required this.namapelanggan,
    required this.nohp,
    required this.namabarang,
    required this.hargabarang,
    required this.jumlahbarang,
    required this.totalharga,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Transaksi.fromJson(Map<String, dynamic> json) => Transaksi(
        id: json["id"] ?? 0,
        kodetransaksi: json["kodetransaksi"] ?? '',
        namapelanggan: json["namapelanggan"] ?? '',
        nohp: json["nohp"] ?? '',
        namabarang: json["namabarang"] ?? '',
        hargabarang: int.tryParse(json["hargabarang"].toString()) ?? 0,
        jumlahbarang: int.tryParse(json["jumlahbarang"].toString()) ?? 0,
        totalharga: int.tryParse(json["totalharga"].toString()) ?? 0,
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : DateTime.now(),
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "kodetransaksi": kodetransaksi,
        "namapelanggan": namapelanggan,
        "nohp": nohp,
        "namabarang": namabarang,
        "hargabarang": hargabarang,
        "jumlahbarang": jumlahbarang,
        "totalharga": totalharga,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };

  Transaksi copyWith({
    int? id,
    String? kodetransaksi,
    String? namapelanggan,
    String? nohp,
    String? namabarang,
    int? hargabarang,
    int? jumlahbarang,
    int? totalharga,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Transaksi(
      id: id ?? this.id,
      kodetransaksi: kodetransaksi ?? this.kodetransaksi,
      namapelanggan: namapelanggan ?? this.namapelanggan,
      nohp: nohp ?? this.nohp,
      namabarang: namabarang ?? this.namabarang,
      hargabarang: hargabarang ?? this.hargabarang,
      jumlahbarang: jumlahbarang ?? this.jumlahbarang,
      totalharga: totalharga ?? this.totalharga,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}