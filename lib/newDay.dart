import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

final productList = [
  Product(name: 'Laptop', age: 6),
  Product(name: 'Monitor', age: 2),
  Product(name: 'Keyboard', age: 1),
  Product(name: 'Mouse', age: 3)
];

final productListStateProvider = StateProvider<ProductSortType>((ref) {
  return ProductSortType.name;
});

final productProvider = Provider<List<Product>>((ref) {
  final sortType = ref.watch(productListStateProvider);
  switch (sortType) {
    case ProductSortType.name:
      return productList.sorted((a, b) => a.name.compareTo(b.name));
    case ProductSortType.age:
      return productList.sorted((a, b) => a.age.compareTo(b.age));
  }
});

class MyApp extends ConsumerWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('RiverPod Test'),
            actions: [
              IconButton(
                icon: const Icon(Icons.sort_by_alpha),
                tooltip: 'Sort by Name',
                onPressed: () {
                  ref.watch(productListStateProvider.notifier).state =
                      ProductSortType.name;
                  print(ref.read(productListStateProvider.notifier).state);
                },
              ),
              IconButton(
                icon: const Icon(Icons.sort_sharp),
                tooltip: 'Sort by Age',
                onPressed: () {
                  ref.watch(productListStateProvider.notifier).state =
                      ProductSortType.age;
                  print(ref.read(productListStateProvider.notifier).state);
                },
              ),
            ],
          ),
          body: ListView.builder(
            itemCount: productList.length,
            itemBuilder: (BuildContext context, int index) {
              Product product = ref.watch(productProvider)[index];
              return ListTile(
                title: Text(product.name),
                subtitle: Text(product.age.toString()),
              );
            },
          ),
        ),
      ),
    );
  }
}

class Product {
  String name;
  int age;

  Product({required this.name, required this.age});
}

enum ProductSortType { name, age }
