
class Spell {
  int id, isMaterial, isRitual, isVerbal, isSomatic, hasConcentration, level;
  String castTime, description, distance, duration, name, school, materials;

  Spell(
    this.id, 
    this.name, 
    this.level, 
    this.castTime, 
    this.duration, 
    this.distance, 
    this.description, 
    this.school,
    this.hasConcentration,
    this.isMaterial,
    this.isRitual, 
    this.isSomatic, 
    this.isVerbal,
    this.materials
  );

  Spell.fromMap(map)
    : id = map["id"],
      name = map["name"],
      level = map["level"],
      castTime = map["castTime"],
      duration = map["duration"],
      distance = map["distance"],
      description = map["description"],
      school = map["school"],
      materials = map["materials"],
      hasConcentration = map["hasConcentration"],
      isMaterial = map["isMaterial"],
      isRitual = map["isRitual"],
      isSomatic = map["isSomatic"],
      isVerbal = map["isVerbal"];

  String get levelString => (this.level == 0) ? 'Заговор' : 'Уровень ${this.level}';

  String get levelStrShort => (this.level == 0) ? 'заговор' : 'ур. ${this.level}';
}