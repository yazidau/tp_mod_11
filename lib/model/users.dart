class Users {
  int? id;
  String? name;

  Users({
    this.id,
    this.name,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        id: json['id'] as int?,
        name: json['name'] as String?,
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'Users{name: $name}';
  }
}
