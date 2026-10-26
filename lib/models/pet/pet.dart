/// A household pet. Local only until the Pets API is available.
class Pet {
  const Pet({required this.name, required this.type, this.breed = ''});

  final String name;
  final String type;
  final String breed;
}
