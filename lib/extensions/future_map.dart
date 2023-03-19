/*
In SOSTANZA è una sorta di map() che invoca delle funzioni asyncrone, le infila all'interno della "collezione items"
e al termine di Future.forEach(), quando tutte le funzioni di mapping saranno state invocate restituisce la collezione
di DATI MAPPATI.
*/

extension FutureMap<E> on List<E> {
  Future<List<T>> futureMap<T>(Future<T> f(E e)) async {
  // Future<List<T>> futureMap<T>(Future<T> Function(E e) f) async {            // Flutter mi dice di impostare il codice in questo modo, però io imposto il codice come il prof perchè questo non è un errore grave
    final List<T> items = [];

    await Future.forEach<E>(this, (element) async {
      final o = await f(element);
      items.add(o);
    });

    return items;
  }
}