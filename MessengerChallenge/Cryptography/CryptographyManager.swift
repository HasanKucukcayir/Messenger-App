//
//  CryptographyManager.swift
//  Messenger Challenge
//
//  Created by Hasan on 25/12/2023.
//

import Foundation
import CommonCrypto
import CryptoKit

final class CryptographyManager {

  private func hash(keyString: String) -> String {
    let data = Data(keyString.utf8)
    let digest = SHA256.hash(data: data)
    let hashString = digest
      .compactMap { String(format: "%02x", $0) }
      .joined()
    return hashString
  }

  func generateKey(senderId: String,
                   receiverId: String) -> String {

    let keyPart1 = String(senderId.dropFirst(4))
    let keyPart2 = String(receiverId.dropFirst(4))

    let keyString = keyPart1 + keyPart2

    return hash(keyString: keyString)
  }

  func encrypt(dataString: String,
               senderId: String,
               receiverId: String) -> String? {
    let key: String = generateKey(senderId: senderId,
                                  receiverId: receiverId)
    let data = dataString.data(using: .utf8)!
    let keyData = key.data(using: .utf8)!
    let inputData = data as NSData
    let encryptedData = NSMutableData(length: Int(inputData.length) + kCCBlockSizeAES128)!
    let keyLength = size_t(kCCKeySizeAES128)
    let operation = CCOperation(kCCEncrypt)
    let algorithm = CCAlgorithm(kCCAlgorithmAES)
    let options = CCOptions(kCCOptionPKCS7Padding)

    var numBytesEncrypted: size_t = 0

    let cryptStatus = CCCrypt(
      operation,
      algorithm,
      options,
      (keyData as NSData).bytes, keyLength,
      nil,
      inputData.bytes, inputData.length,
      encryptedData.mutableBytes, encryptedData.length,
      &numBytesEncrypted
    )

    if cryptStatus == kCCSuccess {
      encryptedData.length = Int(numBytesEncrypted)
      let base64EncodedString = encryptedData.base64EncodedString()
      return base64EncodedString
    }

    return nil
  }

  func decryptReceivedMessage(base64EncodedString: String,
                              key: String) -> String? {
    let data = Data(base64Encoded: base64EncodedString)
    let keyData = key.data(using: .utf8)!
    let inputData = data! as NSData
    let decryptedData = NSMutableData(length: Int(inputData.length) + kCCBlockSizeAES128)!
    let keyLength = size_t(kCCKeySizeAES128)
    let operation = CCOperation(kCCDecrypt)
    let algorithm = CCAlgorithm(kCCAlgorithmAES)
    let options = CCOptions(kCCOptionPKCS7Padding)

    var numBytesDecrypted: size_t = 0

    let cryptStatus = CCCrypt(
      operation,
      algorithm,
      options,
      (keyData as NSData).bytes, keyLength,
      nil,
      inputData.bytes, inputData.length,
      decryptedData.mutableBytes, decryptedData.length,
      &numBytesDecrypted
    )

    if cryptStatus == kCCSuccess {
      decryptedData.length = Int(numBytesDecrypted)
      return String(decoding: decryptedData, as: UTF8.self)
    }

    return nil
  }

  func decryptSentMessage(base64EncodedString: String,
                          key: String) -> String? {
    let data = Data(base64Encoded: base64EncodedString)
    let keyData = key.data(using: .utf8)!
    let inputData = data! as NSData
    let decryptedData = NSMutableData(length: Int(inputData.length) + kCCBlockSizeAES128)!
    let keyLength = size_t(kCCKeySizeAES128)
    let operation = CCOperation(kCCDecrypt)
    let algorithm = CCAlgorithm(kCCAlgorithmAES)
    let options = CCOptions(kCCOptionPKCS7Padding)

    var numBytesDecrypted: size_t = 0

    let cryptStatus = CCCrypt(
      operation,
      algorithm,
      options,
      (keyData as NSData).bytes, keyLength,
      nil,
      inputData.bytes, inputData.length,
      decryptedData.mutableBytes, decryptedData.length,
      &numBytesDecrypted
    )

    if cryptStatus == kCCSuccess {
      decryptedData.length = Int(numBytesDecrypted)
      return String(decoding: decryptedData, as: UTF8.self)
    }

    return nil
  }

}
