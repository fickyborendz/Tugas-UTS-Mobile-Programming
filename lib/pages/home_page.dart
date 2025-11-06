import 'package:flutter/material.dart';

class Item {
  final String name;
  final int qty;
  final int price;

  Item({required this.name, required this.qty, required this.price});

  int get subtotal => qty * price;
}

class Nota {
  final String buyerName;
  final DateTime date;
  final List<Item> items;

  Nota({required this.buyerName, required this.date, required this.items});

  int get total => items.fold(0, (s, i) => s + i.subtotal);

  int get totalQty => items.fold(0, (s, i) => s + i.qty);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'e-FishNote',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // For demo: store a list of saved notas in memory
  final List<Nota> savedNotas = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('e-FishNote - Vicky_Fish'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                final Nota? result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (c) => const AddNotaPage()),
                );
                if (result != null) {
                  setState(() => savedNotas.add(result));
                }
              },
              icon: const Icon(Icons.note_add),
              label: const Text('Buat Nota Baru'),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: savedNotas.isEmpty
                  ? const Center(child: Text('Belum ada nota. Buat nota baru.'))
                  : ListView.builder(
                      itemCount: savedNotas.length,
                      itemBuilder: (context, idx) {
                        final n = savedNotas[idx];
                        return Card(
                          child: ListTile(
                            title: Text(n.buyerName.isEmpty ? 'Pembeli Umum' : n.buyerName),
                            subtitle: Text('Tanggal: ${n.date.toLocal().toString().split(' ')[0]} • Items: ${n.items.length}'),
                            trailing: Text('Rp ${_formatNumber(n.total)}'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (c) => NotaDetailPage(nota: n)),
                              );
                            },
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}

class AddNotaPage extends StatefulWidget {
  const AddNotaPage({super.key});

  @override
  State<AddNotaPage> createState() => _AddNotaPageState();
}

class _AddNotaPageState extends State<AddNotaPage> {
  final TextEditingController buyerCtrl = TextEditingController();
  final List<Item> items = [];

  void _showAddItemDialog() {
    final nameCtrl = TextEditingController();
    final qtyCtrl = TextEditingController();
    final priceCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tambah Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nama ikan')),
              TextField(controller: qtyCtrl, decoration: const InputDecoration(labelText: 'Jumlah'), keyboardType: TextInputType.number),
              TextField(controller: priceCtrl, decoration: const InputDecoration(labelText: 'Harga satuan (Rp)'), keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              final name = nameCtrl.text.trim();
              final qty = int.tryParse(qtyCtrl.text.trim()) ?? 0;
              final price = int.tryParse(priceCtrl.text.trim()) ?? 0;
              if (name.isEmpty || qty <= 0 || price <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Isi data item dengan benar')));
                return;
              }
              setState(() => items.add(Item(name: name, qty: qty, price: price)));
              Navigator.pop(ctx);
            },
            child: const Text('Tambah'),
          )
        ],
      ),
    );
  }

  int get total => items.fold(0, (s, i) => s + i.subtotal);
  int get totalQty => items.fold(0, (s, i) => s + i.qty);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Nota')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(controller: buyerCtrl, decoration: const InputDecoration(labelText: 'Nama pembeli (opsional)')),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton.icon(onPressed: _showAddItemDialog, icon: const Icon(Icons.add), label: const Text('Tambah Item')),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: items.isEmpty ? null : () {
                    // hapus semua
                    setState(() => items.clear());
                  },
                  icon: const Icon(Icons.delete_forever),
                  label: const Text('Kosongkan'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                )
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: items.isEmpty
                  ? const Center(child: Text('Belum ada item. Tambah item untuk membuat nota.'))
                  : ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (c, i) {
                        final it = items[i];
                        return Card(
                          child: ListTile(
                            title: Text(it.name),
                            subtitle: Text('${it.qty} × Rp ${_formatNumber(it.price)} = Rp ${_formatNumber(it.subtotal)}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => setState(() => items.removeAt(i)),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Qty: $totalQty'),
                Text('Total: Rp ${_formatNumber(total)}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: items.isEmpty
                  ? null
                  : () {
                      final nota = Nota(buyerName: buyerCtrl.text.trim(), date: DateTime.now(), items: List.from(items));
                      Navigator.pop(context, nota);
                    },
              child: const Text('Simpan & Lihat Nota'),
            )
          ],
        ),
      ),
    );
  }
}

class NotaDetailPage extends StatelessWidget {
  final Nota nota;

  const NotaDetailPage({super.key, required this.nota});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Nota')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header toko
            Row(
              children: [
                // placeholder logo
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(6)),
                  child: const Icon(Icons.store, size: 40),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Vicky_Fish', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('Ds. Kadur, Kec. Kadur, Kab. Pamekasan'),
                      SizedBox(height: 2),
                      Text('085930231067'),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Tanggal: ${nota.date.toLocal().toString().split(' ')[0]}'),
                    const SizedBox(height: 6),
                    Text('Kepada: ${nota.buyerName.isEmpty ? 'Pelanggan' : nota.buyerName}'),
                  ],
                )
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            // Table header
            Row(
              children: const [
                Expanded(flex: 1, child: Text('NO', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text('BANYAKNYA', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 4, child: Text('NAMA ITEM', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 3, child: Text('HARGA', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 3, child: Text('JUMLAH', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
            const SizedBox(height: 6),
            const Divider(),
            // Items
            ...nota.items.asMap().entries.map((e) {
              final idx = e.key + 1;
              final it = e.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  children: [
                    Expanded(flex: 1, child: Text(idx.toString())),
                    Expanded(flex: 2, child: Text(it.qty.toString())),
                    Expanded(flex: 4, child: Text(it.name)),
                    Expanded(flex: 3, child: Text('Rp ${_formatNumber(it.price)}', textAlign: TextAlign.right)),
                    Expanded(flex: 3, child: Text('Rp ${_formatNumber(it.subtotal)}', textAlign: TextAlign.right)),
                  ],
                ),
              );
            }).toList(),
            const Divider(),
            const SizedBox(height: 12),
            // Totals
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Qty: ${nota.totalQty}'),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('TOTAL: Rp ${_formatNumber(nota.total)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text('BAYAR: Rp 0'),
                    Text('SISA: Rp ${_formatNumber(nota.total)}'),
                  ],
                )
              ],
            ),
            const SizedBox(height: 20),
            Center(child: Text('***Terimakasih, selamat berbelanja kembali***')),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: const [Text('Tanda Terima'), SizedBox(height: 40)],
                ),
                Column(
                  children: const [Text('Hormat Kami'), SizedBox(height: 40), Text('(ttd)')],
                )
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // future: export to PDF / share
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fitur cetak/ekspor PDF belum diimplementasikan')));
              },
              icon: const Icon(Icons.print),
              label: const Text('Cetak / Simpan PDF (coming soon)'),
            )
          ],
        ),
      ),
    );
  }
}

String _formatNumber(int value) {
  // simple thousand separator
  final s = value.toString();
  final buffer = StringBuffer();
  int count = 0;
  for (int i = s.length - 1; i >= 0; i--) {
    buffer.write(s[i]);
    count++;
    if (count == 3 && i != 0) {
      buffer.write('.');
      count = 0;
    }
  }
  return buffer.toString().split('').reversed.join();
}
