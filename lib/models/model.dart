import 'package:equatable/equatable.dart';

abstract class Model extends Equatable {
  final String? id;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Model(
    this.id, {
      DateTime? createdAt,
      this.updatedAt                                                            // Probabilmente "DateTime? updateDate" potrebbe essere nullable in quanto in fase di creazione un modello è vuoto non ha una informazione relativamente al suo aggiornamento.
    }) : createdAt = createdAt ?? DateTime.now();                               // Purtroppo non possiamo passare la parola "DateTime.now()" come costante pertanto dobbiamo inventarci questo ARTEFIZIO per impostare un valore di DEFAULT a "createdAt"
                                                                                // Quindi abbiamo gestito il fatto che magari la data di creazione di quell'elemento non venga passata, ma se non vienme passata allora passeremo la data corrente.

  @override                                                                     // Adesso facciamo @override della props per gestire ObjectEquality
  List<Object?> get props => [id, updatedAt, createdAt];                        // In questa maniera diremo che un modello si distingue dall'altro in base a questi tre attributi.
}