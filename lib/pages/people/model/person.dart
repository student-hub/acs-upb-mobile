class Person {
  Person(
      {this.name,
      this.email,
      this.phone,
      this.office,
      this.position,
      this.photo});

  final String name;
  final String email;
  final String phone;
  final String office;
  final String position;
  final String photo;

  String get lastName => name.trim().split(' ').last;

  @override
  int get hashCode => name.hashCode;

  @override
  bool operator ==(final Object other) {
    if (other is Person) {
      return other.name == name;
    }
    return false;
  }
}
