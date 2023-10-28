class DataModel {
  final bool edit;
  final String title;
  final List<TileModel> tiles;

  DataModel(this.edit, {this.tiles, this.title});
}

class TileModel {
  final String title;
  final dynamic data;

  TileModel(this.title, this.data);
}

class DataTestModel {
  final bool edit;
  final String title;
  final List<TileTestModel> tiles;

  DataTestModel(this.edit, {this.tiles, this.title});
}

class TileTestModel {
  final String title;
  final dynamic data;
  final String type;
  TileTestModel(
    this.title,
    this.data,
    this.type,
  );
}
