import 'counter_home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// (1) Events Parent Abstract Class
abstract class CounterEvent {}

// (2) Events Child Class
class Increment extends CounterEvent {}

class Reset extends CounterEvent {}

class Decrement extends CounterEvent {}

// (3) Create Class Component Bloc<Event,DataType>
class CounterBloC extends Bloc<CounterEvent, int> {
  // (4) Write Your Variable According to DataType
  int counter = 0;

  //(4) Create Constructor With Initial Value
  CounterBloC() : super(0) {
    //(5) Assign Event With Function Inside Constructor
    on<Increment>(onIncrement);
    on<Reset>(onReset);
    on<Decrement>(onDecrement);
  }

  //(6) Value Changes Private Function
  //(7) Params: Specific Event , Emitter
  onIncrement(Increment event, Emitter<int> emit) {
    counter++;
    emit(counter);
  }

  onDecrement(Decrement event, Emitter<int> emit) {
    counter--;
    emit(counter);
  }

  onReset(Reset event, Emitter<int> emit) {
    counter = 0;
    emit(counter);
  }
}
