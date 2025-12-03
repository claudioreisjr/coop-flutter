import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EventosPage extends StatefulWidget {
  const EventosPage({super.key});

  @override
  State<EventosPage> createState() => _EventosPageState();
}

class _EventosPageState extends State<EventosPage> {
  final nomeCtrl = TextEditingController();
  final telefoneCtrl = TextEditingController();
  File? imagem;

  Future<void> escolherImagem() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => imagem = File(picked.path));
    }
  }

  Future<void> enviarDados() async {
    if (nomeCtrl.text.isEmpty || telefoneCtrl.text.isEmpty) return;

    String? urlImagem;

    // Envia imagem para o Firebase Storage
    if (imagem != null) {
      final ref = FirebaseStorage.instance
          .ref("eventos/${DateTime.now().millisecondsSinceEpoch}.jpg");

      await ref.putFile(imagem!);
      urlImagem = await ref.getDownloadURL();
    }

    // Envia dados para o Firestore
    await FirebaseFirestore.instance.collection("eventos").add({
      "nome": nomeCtrl.text,
      "telefone": telefoneCtrl.text,
      "imagem": urlImagem,
      "confirmado": true,
      "data": DateTime.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Presença confirmada!")),
    );

    nomeCtrl.clear();
    telefoneCtrl.clear();
    setState(() => imagem = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Eventos"),
        backgroundColor: Colors.green,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (imagem != null)
              Image.file(imagem!, height: 150)
            else
              const Icon(Icons.image, size: 100),

            ElevatedButton(
              onPressed: escolherImagem,
              child: const Text("Adicionar Foto do Evento"),
            ),

            TextField(
              controller: nomeCtrl,
              decoration: const InputDecoration(labelText: "Nome"),
            ),

            TextField(
              controller: telefoneCtrl,
              decoration: const InputDecoration(labelText: "Telefone"),
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: enviarDados,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text("Confirmar Presença"),
            ),
          ],
        ),
      ),
    );
  }
}
