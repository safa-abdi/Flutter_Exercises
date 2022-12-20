class Formation {
  final int id;
  final String nom;
  final int duree;
  Formation(this.id, this.nom ,this.duree);
  factory Formation.fromMap(Map<String, dynamic> map) =>
      Formation(map['id'], map['nom'],map['duree']);
}
