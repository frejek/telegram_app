// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$FriendCWProxy {
  Friend id(String? id);

  Friend user(User? user);

  Friend allowed(bool allowed);

  Friend createdAt(DateTime? createdAt);

  Friend updatedAt(DateTime? updatedAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Friend(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Friend(...).copyWith(id: 12, name: "My name")
  /// ````
  Friend call({
    String? id,
    User? user,
    bool? allowed,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfFriend.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfFriend.copyWith.fieldName(...)`
class _$FriendCWProxyImpl implements _$FriendCWProxy {
  const _$FriendCWProxyImpl(this._value);

  final Friend _value;

  @override
  Friend id(String? id) => this(id: id);

  @override
  Friend user(User? user) => this(user: user);

  @override
  Friend allowed(bool allowed) => this(allowed: allowed);

  @override
  Friend createdAt(DateTime? createdAt) => this(createdAt: createdAt);

  @override
  Friend updatedAt(DateTime? updatedAt) => this(updatedAt: updatedAt);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Friend(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Friend(...).copyWith(id: 12, name: "My name")
  /// ````
  Friend call({
    Object? id = const $CopyWithPlaceholder(),
    Object? user = const $CopyWithPlaceholder(),
    Object? allowed = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
  }) {
    return Friend(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String?,
      user: user == const $CopyWithPlaceholder()
          ? _value.user
          // ignore: cast_nullable_to_non_nullable
          : user as User?,
      allowed: allowed == const $CopyWithPlaceholder() || allowed == null
          // ignore: unnecessary_non_null_assertion
          ? _value.allowed!
          // ignore: cast_nullable_to_non_nullable
          : allowed as bool,
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

extension $FriendCopyWith on Friend {
  /// Returns a callable class that can be used as follows: `instanceOfFriend.copyWith(...)` or like so:`instanceOfFriend.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$FriendCWProxy get copyWith => _$FriendCWProxyImpl(this);
}
