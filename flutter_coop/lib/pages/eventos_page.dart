import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventosPage extends StatefulWidget {
  const EventosPage({super.key});

  @override
  State<EventosPage> createState() => _EventosPageState();
}

class _EventosPageState extends State<EventosPage> {
  final TextEditingController nomeCtrl = TextEditingController();
  final TextEditingController telCtrl = TextEditingController();

  Future<void> confirmarPresenca() async {
    await FirebaseFirestore.instance.collection("eventos_confirmados").add({
      "nome": nomeCtrl.text,
      "telefone": telCtrl.text,
      "data": DateTime.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Presença confirmada!")),
    );

    nomeCtrl.clear();
    telCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Evento"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // FOTO FIXA
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                "https://media.istockphoto.com/id/1411574348/pt/foto/cup-of-aromatic-coffee-and-beans-on-grey-table-space-for-text.jpg?s=1024x1024&w=is&k=20&c=8UBxw5qKdDoqXrw1CPYfV7yV--yjjT0F7Q0AyclX0Kg=", // TROCAR
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),

            // TÍTULO DO EVENTO
            const Text(
              "Coffe Break",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // DATA / HORÁRIO / LOCAL COM ÍCONES
            Column(
              children: const [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today, size: 20),
                    SizedBox(width: 6),
                    Text("21/11/2025"),
                  ],
                ),
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.access_time, size: 20),
                    SizedBox(width: 6),
                    Text("A partir das 20h"),
                  ],
                ),
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on, size: 20),
                    SizedBox(width: 6),
                    Text("Pizzaria Veneza"),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Divider(height: 30),

            const Text(
              "Confirmar Presença",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // FORMULÁRIO
            TextField(
              controller: nomeCtrl,
              decoration: const InputDecoration(
                labelText: "Nome",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: telCtrl,
              decoration: const InputDecoration(
                labelText: "Telefone",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: confirmarPresenca,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              ),
              icon: const Icon(Icons.check),
              label: const Text("Confirmar"),
            ),
          ],
        ),
      ),
    );
  }
}
