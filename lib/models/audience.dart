import 'dart:convert';

class Audience{
  String audience_id,
      name,
      source_type,
      status,
      created_at,
      created_by,
      created_by_name,
      updated_by,
      updated_at,
      updated_by_name;
  List source_list;
  
  Audience(
      {
        this.audience_id='',
        this.name='',
        this.source_type='',
        this.source_list= const [],
        this.status='Waiting for source',
        this.created_at='',
        this.created_by='',
        this.created_by_name='',
        this.updated_by='',
        this.updated_at='',
        this.updated_by_name='',
      }
      );
  factory Audience.fromJson(Map<String, dynamic>json){
    return Audience(
        audience_id: json['audience_id'].toString(),
        name: json['name'].toString(),
        source_type: json['source_type'].toString(),
        source_list: jsonDecode(json['source_list']),
        status: json['status'].toString(),
        created_at: json['created_at'].toString(),
        created_by: json['created_by'].toString(),
        created_by_name: json['created_by_name'].toString(),
        updated_by: json['updated_by:'].toString(),
        updated_at: json['updated_at'].toString(),
        updated_by_name: json['updated_by_name'].toString()
    );
  }
  factory Audience.fromMap(Map<String, dynamic> json){
    return Audience(
      audience_id: json['audience_id'].toString(),
      name: json['name'].toString(),
      source_type: json['source_type'].toString(),
      source_list: jsonDecode(json['source_list']),
      status: json['status'].toString(),
      created_at: json['created_at'].toString(),
      created_by: json['created_by'].toString(),
      created_by_name: json['created_by_name'].toString(),
      updated_by: json['updated_by'].toString(),
      updated_at: json['updated_at'].toString(),
      updated_by_name: json['updated_by_name'].toString(),

    );

  }
  Map<String, dynamic> toMap() => {
    "audience_id": audience_id,
    "name": name,
    "source_type":source_type,
    "source_list":jsonEncode(source_list),
    "status":status,
    "created_by": created_by,
    "created_at": created_at,
    "created_by_name": created_by_name,
    "updated_by": updated_by,
    "updated_at": updated_at,
    "updated_by_name": updated_by_name,
  };
}