class Process {
  final url;
  final id;
  final name;
  final description;
  final processType;
  final contentType;
  final startedAt;
  final endedAt;
  final createdAt;
  final lastActivity;
  final batch;
  final units;

  Process(
  this.url,
  this.id,
  this.name,
  this.description,
  this.processType,
  this.contentType,
  this.startedAt,
  this.endedAt,
  this.createdAt,
  this.lastActivity,
  this.batch,
  this.units,
  );
}

class Batch {

  final id;
  final name;
  final started_at;
  final ended_at;
  final active;

  Batch(
    this.id,
    this.name,
    this.started_at,
    this.ended_at,
    this.active,
  );

  static Batch getBatch(Map batch) {

    if(batch == null) {
      return new Batch("", "UNDEFINED", "", "", "");
    } else {
      return new Batch(batch['id'], batch['name'], batch['started_at'], batch['ended_at'], batch['active']);
    }
  }
}

class Place {

  final id;
  final name;

  Place(
      this.id,
      this.name,
      );

  static Place getPlace(List place) {

    if(place.length == 0) {
      return new Place("", "UNDEFINED");
    } else {
      return new Place(place[0]['place']['name'], place[0]['place']['name']);
    }
  }
}

class Unit {

  final history_id;
  final id;
  final name;
  final unit_type;
  final total_volume;
  final process;
  final place;
  final devices;
  final reason;

  Unit(
  this.history_id,
  this.id,
  this.name,
  this.unit_type,
  this.total_volume,
  this.process,
  this.place,
  this.devices,
  this.reason,
      );

  static Unit getUnit(List unit) {
    /// TODO: devices is a List

    if(unit.length == 0) {
      return new Unit("", "", "UNDEFINED", "", "", "", "", "", "");
    } else {
      var aux = unit[0];
      return new Unit(aux['history_id'], aux['id'], aux['name'], aux['unit_type'], aux['total_volume'], aux['process'], aux['place'], aux['devices'], aux['reason']);
    }

  }

}

