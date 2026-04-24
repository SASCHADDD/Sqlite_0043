import 'package:sqlite_pam/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<List<UserEntity>> getAllUsers();
  Future<void> addUser(UserEntity user);
  Future<void> upadateUser(UserEntity user);
  Future<void> deleteUser(String id);
}
