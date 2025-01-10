import 'dart:convert';

List<Pelanggan> pelangganFromJson(String str) =>
    List<Pelanggan>.from(json.decode(str).map((x) => Pelanggan.fromJson(x)));

String pelangganToJson(List<Pelanggan> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Pelanggan {
  final int id;
  final String namapelanggan;
  final String nohp;
  final String email;
  final DateTime createdAt;
  final DateTime updatedAt;

  Pelanggan({
    required this.id,
    required this.namapelanggan,
    required this.nohp,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Pelanggan.fromJson(Map<String, dynamic> json) => Pelanggan(
        id: json["id"] ?? 0,
        namapelanggan: json["namapelanggan"] ?? '',
        nohp: json["nohp"] ?? '',
        email: json["email"] ?? '',
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : DateTime.now(),
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "namapelanggan": namapelanggan,
        "nohp": nohp,
        "email": email,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };

  // Helper method untuk membuat salinan objek dengan nilai yang diperbarui
  Pelanggan copyWith({
    int? id,
    String? namapelanggan,
    String? nohp,
    String? email,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Pelanggan(
      id: id ?? this.id,
      namapelanggan: namapelanggan ?? this.namapelanggan,
      nohp: nohp ?? this.nohp,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}