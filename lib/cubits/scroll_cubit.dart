import 'package:flutter_bloc/flutter_bloc.dart';

class ScrollCubit extends Cubit<bool> {
  ScrollCubit() : super(false);                                                 // costruttore  Lo stato ionizale è false quindi non sta scrollando

  void start() => emit(true);

  void stop() => emit(false);
}