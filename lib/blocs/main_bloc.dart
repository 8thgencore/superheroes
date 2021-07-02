import 'dart:async';

class MainBloc {
  final StreamController<MainPageState> stateController = StreamController.broadcast();
  StreamSubscription<MainPageState>? stateSubscription;

  Stream<MainPageState> observeMainPageState() => stateController.stream;

  MainBloc() {
    stateController.sink.add(MainPageState.noFavorites);
  }

  // Stream<MainPageState> observeMainPageState() {
  //   return Stream.periodic(Duration(seconds: 2), (tick) => tick)
  //       .map((tick) => MainPageState.values[tick % MainPageState.values.length]);
  // }

  void nextState() {
    stateSubscription?.cancel();
    stateSubscription = stateController.stream.take(1).listen((currentState) {
      final nextState = MainPageState
          .values[(MainPageState.values.indexOf(currentState) + 1) % MainPageState.values.length];
      stateController.sink.add(nextState);
    });
  }

  void dispose() {
    stateController.close();
    stateSubscription?.cancel();
  }
}

enum MainPageState {
  noFavorites,
  minSymbols,
  loading,
  nothingFound,
  loadingError,
  searchResults,
  favorites,
}
