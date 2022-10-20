import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CustomCupomCode extends StatefulWidget {
  const CustomCupomCode({
    Key? key,
    required this.code,
    required this.desconto,
  }) : super(key: key);

  final String code;
  final String desconto;

  @override
  State<CustomCupomCode> createState() => _CustomCupomCodeState();
}

class _CustomCupomCodeState extends State<CustomCupomCode> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 400,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.purple,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Cupom liberado!",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(
            height: 8,
          ),
          SizedBox(
            width: 220,
            height: 220,
            child: QrImage(
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.circle,
              ),
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.circle,
              ),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              data: widget.code,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            "Desconto: ${widget.desconto}%",
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            "chave: ${widget.code}",
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.normal, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
