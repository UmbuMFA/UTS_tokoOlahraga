import 'dart:async';
import 'package:uts_toko_olahraga/Database/DbHelper.dart';
import 'package:uts_toko_olahraga/EntryForm/EntryFormKategori.dart';
import 'package:uts_toko_olahraga/Model/Kategori.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class KategoriPage extends StatefulWidget {
      static String tag = 'KategoriPage';
  @override
  KategoriState createState() => KategoriState();
}

class KategoriState extends State<KategoriPage> {
  DbHelper dbHelper = DbHelper();
  int count = 0;
  List<Kategori> itemList;
  @override
  Widget build(BuildContext context) {
    if (itemList == null) {
      itemList = List<Kategori>();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Kategori'),
      ),
      body: Column(children: [
        Expanded(
          child: createListView(),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: double.infinity,
            // ignore: deprecated_member_use
            child: RaisedButton(
              child: Text("Tambah Item"),
              onPressed: () async {
                var item = await navigateToEntryForm(context, null);  
                if (item != null) {
                  //TODO 2 Panggil Fungsi untuk Insert ke DB
                  int result = await dbHelper.insertKategori(item);
                  if (result > 0) {
                    updateListView();
                  }
                }
              },
            ),
          ),
        ),
      ]),
    );
  }

  Future<Kategori> navigateToEntryForm(BuildContext context, Kategori item) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return EntryFormKategori(item);
    }));
    return result;
  }

  ListView createListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red,
              child: Icon(Icons.ad_units),
            ),
            title: Row(
              children: [
                Container(
                  child: Text(
                    this.itemList[index].name,
                    style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18,),
                  )
                )
              ],
            ),
            trailing: GestureDetector(
              child: Icon(Icons.delete),
              onTap: () async {
                //TODO 3 Panggil Fungsi untuk Delete dari DB berdasarkan Item
                dbHelper.deleteKategori(this.itemList[index].id);
                updateListView();
              },
            ),
            onTap: () async {
              var item =
                  await navigateToEntryForm(context, this.itemList[index]);
              //TODO 4 Panggil Fungsi untuk Edit data
              dbHelper.updateKategori(item);//
                updateListView();
            },
          ),
        );
      },
    );
  }

  //update List item
  void updateListView() {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
      //TODO 1 Select data dari DB
      Future<List<Kategori>> itemListFuture = dbHelper.getKategoriList();
      itemListFuture.then((itemList) {
        setState(() {
          this.itemList = itemList;
          this.count = itemList.length;
        });
      });
    });
  }
}
