import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pwa_gerador_cupom/widgets/custom_cupom.dart';
import 'package:pwa_gerador_cupom/widgets/custom_dialog.dart';
import '../models/cupom.dart';
import '../services/custom_firebase_db.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String desconto = "";
  String key = "";
  bool _state = false;

  final TextEditingController _name = TextEditingController();
  final TextEditingController _namber = TextEditingController();
  final TextEditingController _cpf = TextEditingController();
  final TextEditingController _nf = TextEditingController();
  final _fromKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Gerador de cupom'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            tooltip: 'Importante',
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return const CustomDialogInfo();
                  });
            },
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              "https://www.brasilnaweb.com.br/wp-content/uploads/2016/12/cupons-de-desconto-black-friday-brasileira.png",
              width: 120,
              height: 120,
            ),
            const Text(
              'Preencher os campos para liberar o seu cupom de desconto!',
              style: TextStyle(fontSize: 16),
            ),
            Expanded(
                child: Form(
              key: _fromKey,
              child: SizedBox(
                width: MediaQuery.of(context).size.width > 600 ? 900 : 450,
                height: MediaQuery.of(context).size.height > 600 ? 900 : 450,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: _name,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "Preencha o nome, para continuar.";
                          }
                        },
                        decoration: const InputDecoration(
                          label: Text("Nome:"),
                          helperText: "Ex: Ana Maria",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: _namber,
                        keyboardType: TextInputType.phone,
                        validator: (String? value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length != 15) {
                            return "Preencha o telefone, para continuar.";
                          }
                        },
                        decoration: const InputDecoration(
                          label: Text("Telefone:"),
                          helperText: "Ex: (83) 99999-9999",
                          border: OutlineInputBorder(),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          TelefoneInputFormatter(),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: _cpf,
                        keyboardType: TextInputType.number,
                        validator: (String? value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length != 14) {
                            return "Preencha o CPF, para continuar.";
                          }
                        },
                        decoration: const InputDecoration(
                          label: Text("CPF:"),
                          border: OutlineInputBorder(),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CpfInputFormatter(),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: _nf,
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        validator: (String? value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length != 4) {
                            return "Preencha os 4 números do cupom, para continuar.";
                          }
                        },
                        decoration: const InputDecoration(
                          label: Text("Número nota fiscal:"),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          child: ElevatedButton(
                              onPressed: _state
                                  ? null
                                  : () async {
                                      if (_fromKey.currentState!.validate()) {
                                        Cupom cupom = Cupom(
                                          nome: _name.text,
                                          telefone: _namber.text,
                                          cpf: _cpf.text,
                                          compra: _nf.text,
                                        );

                                        if (CPFValidator.isValid(_cpf.text)) {
                                          if (await validarCpf(
                                              cupom, _cpf.text)) {
                                            salvarDB(cupom);
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        "Este CPF já foi utilizado.")));
                                          }
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      "CPF invalido, preencha com um valido.")));
                                        }
                                      }
                                    },
                              child: const Text('GERAR CUPOM'))),
                      const SizedBox(
                        height: 8,
                      ),
                      Visibility(
                        visible: _state,
                        child: CustomCupomCode(
                          code: key, desconto: desconto,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

  void salvarDB(Cupom cupom) {
    setState(() {
      desconto = cupom.geradorDesconto().toString();
      cupom.desconto = desconto;
      cupom.validade = true;
      _state = true;

      key = FirebaseDb(cupom: cupom).salvar();
    });
  }

  Future<bool> validarCpf(Cupom cupom, String cpf) async {
    List<Cupom> cupoms = await FirebaseDb(cupom: cupom).getCupoms();

    for (int i = 0; i < cupoms.length; i++) {
      if (cupoms[i].cpf!.contains(cpf)) {
        return false;
      }
    }

    return true;
  }
}
