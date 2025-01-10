import 'dart:convert';

List<Barang> barangFromJson(String str) =>
    List<Barang>.from(json.decode(str).map((x) => Barang.fromJson(x)));

String barangToJson(List<Barang> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Barang {
  final int id;
  final String kodebarang;
  final String namabarang;
  final int hargabarang;
  final int stokbarang;
  final String gambarbarang;
  final DateTime createdAt;
  final DateTime updatedAt;

  Barang({
    required this.id,
    required this.kodebarang,
    required this.namabarang,
    required this.hargabarang,
    required this.stokbarang,
    required this.gambarbarang,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Barang.fromJson(Map<String, dynamic> json) => Barang(
        id: json["id"] ?? 0,
        kodebarang: json["kodebarang"] ?? '',
        namabarang: json["namabarang"] ?? '',
        hargabarang: int.tryParse(json["hargabarang"].toString()) ?? 0,
        stokbarang: int.tryParse(json["stokbarang"].toString()) ?? 0,
        gambarbarang: json["gambarbarang"] ?? 'default.jpg',
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : DateTime.now(),
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "kodebarang": kodebarang,
        "namabarang": namabarang,
        "hargabarang": hargabarang,
        "stokbarang": stokbarang,
        "gambarbarang": gambarbarang,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };

  // Helper method untuk membuat salinan objek dengan nilai yang diperbarui
  Barang copyWith({
    int? id,
    String? kodebarang,
    String? namabarang,
    int? hargabarang,
    int? stokbarang,
    String? gambarbarang,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Barang(
      id: id ?? this.id,
      kodebarang: kodebarang ?? this.kodebarang,
      namabarang: namabarang ?? this.namabarang,
      hargabarang: hargabarang ?? this.hargabarang,
      stokbarang: stokbarang ?? this.stokbarang,
      gambarbarang: gambarbarang ?? this.gambarbarang,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}