import 'dart:async';
import 'package:uts_toko_olahraga/Database/DbHelper.dart';
import 'package:uts_toko_olahraga/EntryForm/EntryForm.dart';
import 'package:uts_toko_olahraga/EntryForm/EntryFormKategori.dart';
import 'package:uts_toko_olahraga/Model/Kategori.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uts_toko_olahraga/Model/Item.dart';

class Home extends StatefulWidget {
      static String tag = 'home';
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  DbHelper dbHelper = DbHelper();
  int count = 0;
  List<Item> itemList;
  @override
  Widget build(BuildContext context) {
    if (itemList == null) {
      // ignore: deprecated_member_use
      itemList = List<Item>();
    }
    return Scaffold(
      appBar: AppBar(
        
        title: Text('Daftar Barang'),
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
                  int result = await dbHelper.insert(item);
                  if (result > 0) {
                    updateListView();
                  }
                }
              },
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: double.infinity,
            // ignore: deprecated_member_use
            child: RaisedButton(
              color: Colors.greenAccent.shade400,
              child: Text("Tambah Kategori"),
              onPressed: () async {
                var kategori = await navigateToEntry(context, null);
        if (kategori != null) {
          // ignore: unused_local_variable
          int result = await dbHelper.insertKategori(kategori);
        }
              },
            ),
          ),
        ),
      ]),
    );
  }

  Future<Item> navigateToEntryForm(BuildContext context, Item item) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return EntryForm(item);
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
                  padding: EdgeInsets.only(right: 10),
                  child: Text("|" + this.itemList[index].kode + "|",
                  style: TextStyle(fontWeight: FontWeight.bold,
                  fontSize: 18,
                  ),
                  ),
                ),
                Container(
                  child: Text(
                    this.itemList[index].name,
                    style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18,),
                  )
                )
              ],
            ),
            subtitle: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    "Rp.  " + this.itemList[index].price.toString(),
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
            trailing: GestureDetector(
              child: Icon(Icons.delete),
              onTap: () async {
                //TODO 3 Panggil Fungsi untuk Delete dari DB berdasarkan Item
                dbHelper.delete(this.itemList[index].id);
                updateListView();
              },
            ),
            onTap: () async {
              var item =
                  await navigateToEntryForm(context, this.itemList[index]);
              //TODO 4 Panggil Fungsi untuk Edit data
              dbHelper.update(item);//
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
      Future<List<Item>> itemListFuture = dbHelper.getItemList();
      itemListFuture.then((itemList) {
        setState(() {
          this.itemList = itemList;
          this.count = itemList.length;
        });
      });
    });
  }
}
Future<Kategori> navigateToEntry(BuildContext context, Kategori kategori) async {
  var result = await Navigator.push(context,
      MaterialPageRoute(builder: (BuildContext context) {
    return EntryFormKategori(kategori);
  }));
  return result;
}