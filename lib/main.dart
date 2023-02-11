import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      home: const MyHomePage(),
    );
  }
}

final currentDate = Provider((ref) => 'Ansh'); // 1

// extension OptionalInfixAddition<TT extends num> on TT? {
//   TT? operator +(TT? other) {
//     final shadow = this;
//     if (shadow != null) {
//       return shadow + (other ?? 0) as TT;
//     } else {
//       return null;
//     }
//   }
// }

class CounterNotifier extends StateNotifier<int> {
  CounterNotifier() : super(0);

  void increment() {
    state = state == null ? 1 : state! + 1;
  }

  void decrement() {
    state = state == null ? 1 : state! - 1;
  }
}

final counterProvider = StateNotifierProvider<CounterNotifier, int?>((ref) {
  return CounterNotifier();
});

class MyHomePage extends ConsumerWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final count = ref.watch(counterProvider);
          final text = count ?? 'Press the Button';
          return Text(text.toString());
        },
      )),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: ref.read(counterProvider.notifier).increment,
            child: const Text('Increment'),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: ref.watch(counterProvider.notifier).decrement,
              child: const Text('Decrement'))
        ],
      ),
    );
  }
}
