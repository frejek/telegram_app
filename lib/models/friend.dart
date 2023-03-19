import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:telegram_app/models/model.dart';
import 'package:telegram_app/models/user.dart';

part 'friend.g.dart';

@CopyWith()                                                                     // Pattern - // Notazione @CopyWith nel quale potremo costruire una copia esatta di questo oggetto con gli stessi attributi ma con valori diversi.
class Friend extends Model {
  final User? user;
  final bool allowed;


  Friend({
    String? id,
    this.user,
    required this.allowed,
    DateTime? createdAt,                                                        // Qui abbiamo impostato DateTime? nullabile in quanto non possiamo passare la parola "DateTime.now()" come costante pertanto dobbiamo inventarci questo ARTEFIZIO per impostare un valore di DEFAULT a "createdAt"
    DateTime? updatedAt                                                         // Probabilmente "DateTime? updateDate" potrebbe essere nullable in quanto in fase di creazione un modello è vuoto non ha una informazione relativamente al suo aggiornamento.
  }) : super(
      id,
      createdAt: createdAt,
      updatedAt: updatedAt
    );

  @override
  List<Object?> get props => [...super.props, user, allowed];
}