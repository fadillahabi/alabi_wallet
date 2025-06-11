import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ModelInput {
  final int? id;
  final String namaProject;
  final String dateProject;
  final int labaProject;
  final String type;

  ModelInput({
    this.id,
    required this.namaProject,
    required this.dateProject,
    required this.labaProject,
    required this.type,
  });

  ModelInput.empty()
    : id = null,
      namaProject = '',
      dateProject = '',
      labaProject = 0,
      type = 'income';

  Map<String, dynamic> toMap() {
    return {
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
      namaProject: map['nama_project'] as String,
      dateProject: map['date_project'] as String,
      labaProject:
          map['laba_project'] is int
              ? map['laba_project']
              : int.tryParse(map['laba_project'].toString()) ?? 0,

      type: map['type'] as String? ?? 'income',
    );
  }

  String toJson() => json.encode(toMap());

  factory ModelInput.fromJson(String source) =>
      ModelInput.fromMap(json.decode(source) as Map<String, dynamic>);
}
