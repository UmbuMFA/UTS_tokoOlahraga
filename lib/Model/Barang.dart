class Barang{
  int _id;
  String _kode;
  String _name;
  int _price;
  int _stock;
  String _kategori;

 int get id => this._id;

  get kode => this._kode;

 set kode( value) => this._kode = value;

  get name => this._name;

 set name( value) => this._name = value;

  get price => this._price;

 set price( value) => this._price = value;

  get stock => this._stock;

 set stock( value) => this._stock = value;

  get kategori => this._kategori;

Barang(this._kode,this._name,this._price,this._stock); //,this._kategori ,this._id,

Barang.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._kode = map['kode'];
    this._name = map['name'];
    this._price = map['price'];
    this._stock = map['stock'];
    this._stock = map['kategori'];
  }

// konversi dari Barang ke Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this._id;
    map['kode'] = kode;
    map['name'] = name;
    map['price'] = price;
    map['stock'] = stock;
    map['kategori'] = this._kategori;
    return map;
  }

}