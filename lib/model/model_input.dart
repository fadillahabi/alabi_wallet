// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ModelInput {
  final int? id;
  final String namaProject;
  final String dateProject;
  final int? labaProject;
  final String type;
  ModelInput({
    this.id,
    required this.namaProject,
    required this.dateProject,
    this.labaProject,
    required this.type,
  });

  factory ModelInput.empty() {
    return ModelInput(
      id: null,
      namaProject: '',
      dateProject: '',
      labaProject: null,
      type: 'income',
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nama_project': namaProject,
      'date_project': dateProject,
      'laba_project': labaProject,
      'type': type,
    };
  }

  factory ModelInput.fromMap(Map<String, dynamic> map) {
    return ModelInput(
      id: map['id'] != null ? map['id'] as int : null,
      namaProject: map['nama_project']?.toString() ?? '',
      dateProject: map['date_project']?.toString() ?? '',
      labaProject:
          map['laba_project'] != null
              ? (map['laba_project'] is int
                  ? map['laba_project'] as int
                  : int.tryParse(map['laba_project'].toString()))
              : null,
      type: map['type']?.toString() ?? 'income',
    );
  }

  String toJson() => json.encode(toMap());

  factory ModelInput.fromJson(String source) =>
      ModelInput.fromMap(json.decode(source) as Map<String, dynamic>);
}
