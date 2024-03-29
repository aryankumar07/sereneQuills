import 'dart:io';
import 'package:blogapp/static_file/failure.dart';
import 'package:blogapp/static_file/providers/firebase_provider.dart';
import 'package:blogapp/static_file/type_defs.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final firebaseStorageProvider = Provider((ref) =>
 firebaseStorageRepo(firebaseStorage: ref.watch(storageProvider)));

class firebaseStorageRepo{
  final FirebaseStorage _firebaseStorage;
  firebaseStorageRepo({
    required FirebaseStorage firebaseStorage
  }):_firebaseStorage = firebaseStorage;

  FutureEither<String> storeFile({
    required String path,
    required String id,
    required File? file,
  }) async {
    try{
      final ref = _firebaseStorage.ref().child(path).child(id);
      UploadTask uploadTask = ref.putFile(file!);
      final snapshot = await uploadTask;
      return right( await snapshot.ref.getDownloadURL());
    }
    catch (e) {
      return left(Failure(e.toString()));
    }
  }
}