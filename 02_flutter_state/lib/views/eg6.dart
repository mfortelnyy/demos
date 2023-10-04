/* Topics to demonstrate:
 * - Using the `provider` package to disseminate a ChangeNotifier
 */

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:provider/provider.dart';
//providing data down the widget tree

class App6 extends StatelessWidget {
  const App6({super.key});

  @override
  Widget build(BuildContext context) {
    // The ChangeNotifierProvider is a widget that provides a model to all
    // children widgets. gives access ti change notifier
    return ChangeNotifierProvider(
      //happens once
      create: (context) => CountersModel(), 
      //all children are descendents of changenotifier and can access it 
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SumDisplay(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(3, (i) => CounterDisplay(index: i))
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(3, (i) => Incrementer(index: i, increment: i+1))
          ),
        ],
      )
    );
  }
}

//widget context is the element
//.of goes up the element tree but the cost of using this mechanism over listebalebuilder is worse 
class CountersModel with ChangeNotifier {
  final Map<int,int> _counts = {};

  int get sum => _counts.values.sum;
  
  int getCount(int index) {
    return _counts[index] ?? 0;
  }

  void increment(int index, int inc) {
    _counts[index] = getCount(index) + inc;
    notifyListeners();
  }
}


class SumDisplay extends StatelessWidget {
  const SumDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CountersModel>(
      builder: (context, counters, _) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Sum: ${counters.sum}'),
        );
      }
    );
  }
}


class CounterDisplay extends StatelessWidget {
  final int index;

  const CounterDisplay({required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CountersModel>(
      builder: (context, counters, _) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Counter: ${counters.getCount(index)}'),
        );
      }
    );
  }
}


class Incrementer extends StatelessWidget {
  final int index;
  final int? increment;

  const Incrementer({required this.index, this.increment, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          Provider.of<CountersModel>(context, listen: false)
          .increment(index, increment ?? 1);
        },
        child: Text('+${increment ?? 1}')
      ),
    );
  }
}
