
import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;

class AESCrypto {
  static final _key = encrypt.Key.fromUtf8('aU9pLckW9mv7XxYx93uFbSgZ1aDkWy0z');
  static final _iv = encrypt.IV.fromLength(16);

  static Uint8List decryptIfEncrypted(Uint8List bytes) {
    final marker = utf8.encode("ENC:");
    if (bytes.length >= 4 &&
        bytes[0] == marker[0] &&
        bytes[1] == marker[1] &&
        bytes[2] == marker[2] &&
        bytes[3] == marker[3]) {
      final encryptedData = bytes.sublist(4);
      final encrypter =
          encrypt.Encrypter(encrypt.AES(_key, mode: encrypt.AESMode.cbc));
      final decrypted = encrypter.decryptBytes(
          encrypt.Encrypted(encryptedData),
          iv: _iv);
      return Uint8List.fromList(decrypted);
    }
    return bytes;
  }

  static Uint8List encryptConfig(Uint8List plainBytes) {
    final encrypter =
        encrypt.Encrypter(encrypt.AES(_key, mode: encrypt.AESMode.cbc));
    final encrypted = encrypter.encryptBytes(plainBytes, iv: _iv);
    final marker = utf8.encode("ENC:");
    return Uint8List.fromList(marker + encrypted.bytes);
  }
}
