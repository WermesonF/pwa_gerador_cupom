import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cupom.dart';

class FirebaseDb {
  final CollectionReference clienteCollection = FirebaseFirestore.instance.collection('Clientes');

  FirebaseDb({required this.cupom});
  Cupom cupom;

  String salvar() {
    String id = geratorId();

    clienteCollection.doc(id).set({
      "id": id,
      "nome": cupom.nome,
      "telefone": cupom.telefone,
      "cpf": cupom.cpf,
      "compra": cupom.compra,
      "desconto" : cupom.desconto,
      "validade": cupom.validade,
    });

    return id;
  }

  Future<List<Cupom>> getCupoms() async {
    QuerySnapshot querySnapshot;
    List<Cupom> docs = [];
    
    querySnapshot = await clienteCollection.get();

    if(querySnapshot.docs.isNotEmpty) {
      for(var doc in querySnapshot.docs.toList()) {
        docs.add(Cupom.fromJson(doc.data() as Map<String, dynamic>));
      }
    }

    return docs;
  }

  String geratorId() {
    final Random random = Random.secure();

    var values = List<int>.generate(32, (i) => random.nextInt(256));

    return base64Url.encode(values);
  }
}