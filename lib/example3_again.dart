import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

enum City { stockholm, paris, tokyo, kolkata }

typedef WeatherEmoji = String;

Future<WeatherEmoji> getWeather(City city) {
  return Future.delayed(
      // Later I will see
      const Duration(seconds: 1),
      () =>
          {
            City.stockholm: '⛈',
            City.paris: '🌨',
            City.tokyo: '🍃',
          }[city] ??
          '🔥');
}

final cityGetStateProvider = StateProvider<City?>((ref) => null);

final currentCityProvider = FutureProvider((ref) {
  final city = ref.watch(cityGetStateProvider);
  if (city != null) {
    return getWeather(city);
  } else {
    return '🦄';
  }
});

class MyApp extends ConsumerWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final city = ref.watch(currentCityProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      home: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              SizedBox(
                height: 67,
                child: Center(
                  child: city.when(
                      data: (Object data) {
                        return Text(
                          data.toString(),
                          style: const TextStyle(fontSize: 50),
                        );
                      },
                      error: (Object error, StackTrace stackTrace) {},
                      loading: () => const CircularProgressIndicator()),
                ),
              ),
              SizedBox(
                height: 400,
                child: ListView.builder(
                    itemCount: City.values.length,
                    itemBuilder: (context, index) {
                      final city = City.values[index];
                      return ListTile(
                        title: Text(city.toString()),
                        onTap: () {
                          ref.read(cityGetStateProvider.notifier).state = city;
                        },
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
