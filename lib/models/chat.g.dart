// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ChatCWProxy {
  Chat id(String? id);

  Chat user(User? user);

  Chat lastMessage(String lastMessage);

  Chat createdAt(DateTime? createdAt);

  Chat updatedAt(DateTime? updatedAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Chat(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Chat(...).copyWith(id: 12, name: "My name")
  /// ````
  Chat call({
    String? id,
    User? user,
    String? lastMessage,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfChat.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfChat.copyWith.fieldName(...)`
class _$ChatCWProxyImpl implements _$ChatCWProxy {
  const _$ChatCWProxyImpl(this._value);

  final Chat _value;

  @override
  Chat id(String? id) => this(id: id);

  @override
  Chat user(User? user) => this(user: user);

  @override
  Chat lastMessage(String lastMessage) => this(lastMessage: lastMessage);

  @override
  Chat createdAt(DateTime? createdAt) => this(createdAt: createdAt);

  @override
  Chat updatedAt(DateTime? updatedAt) => this(updatedAt: updatedAt);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Chat(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Chat(...).copyWith(id: 12, name: "My name")
  /// ````
  Chat call({
    Object? id = const $CopyWithPlaceholder(),
    Object? user = const $CopyWithPlaceholder(),
    Object? lastMessage = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
  }) {
    return Chat(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String?,
      user: user == const $CopyWithPlaceholder()
          ? _value.user
          // ignore: cast_nullable_to_non_nullable
          : user as User?,
      lastMessage:
          lastMessage == const $CopyWithPlaceholder() || lastMessage == null
              // ignore: unnecessary_non_null_assertion
              ? _value.lastMessage!
              // ignore: cast_nullable_to_non_nullable
              : lastMessage as String,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime?,
      updatedAt: updatedAt == const $CopyWithPlaceholder()
          ? _value.updatedAt
          // ignore: cast_nullable_to_non_nullable
          : updatedAt as DateTime?,
    );
  }
}

extension $ChatCopyWith on Chat {
  /// Returns a callable class that can be used as follows: `instanceOfChat.copyWith(...)` or like so:`instanceOfChat.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ChatCWProxy get copyWith => _$ChatCWProxyImpl(this);
}
