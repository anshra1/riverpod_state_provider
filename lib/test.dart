import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: Test()));
}

class Product {
  final String name;
  final int age;

  Product({required this.name, required this.age});
}

enum ProductSortType { name, age }

final _products = [
  Product(name: 'Ansh Raj', age: 26),
  Product(name: 'Gulsan', age: 25),
  Product(name: 'Atomic', age: 1000),
];

final productSortTypeProvider =
    StateProvider<ProductSortType>((ref) => ProductSortType.name);

final productsProvider = Provider<List<Product>>((ref) {
  final sortType = ref.watch(productSortTypeProvider);
  switch (sortType) {
    case ProductSortType.name:
      return _products.sorted((a, b) => a.name.compareTo(b.name));
    case ProductSortType.age:
      return _products.sorted((a, b) => a.age.compareTo(b.age));
  }
});

class Test extends ConsumerWidget {
  const Test({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
   final products =  ref.watch(productsProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('RiverPod Example'),
          actions: [
            DropdownButton<ProductSortType>(
              dropdownColor: Colors.green,
              value: ProductSortType.name,
              items: const [
                DropdownMenuItem(
                  value: ProductSortType.name,
                  child: Icon(Icons.sort_by_alpha),
                ),
                DropdownMenuItem(
                  value: ProductSortType.age,
                  child: Icon(Icons.sort),
                ),
              ],
              onChanged: (value) {
                print(value);
                ref.read(productSortTypeProvider.notifier).state = value!;
                print(productSortTypeProvider.name);
              },
            )
          ],
        ),
        body: ListView.builder(
            itemCount: ref.read(productsProvider).length,
            itemBuilder: (context, index) {
              final person = ref.read(productsProvider)[index];
              return ListTile(
                title: Text(person.name),
                subtitle: Text(person.age.toString()),
              );
            }),
      ),
    );
  }
}
