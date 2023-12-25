//
//  KeyChainHelper.swift
//  Messenger Challenge
//
//  Created by Hasan on 25/12/2023.
//

import Security
import Foundation

class KeyChainHelper {

  static func storeData(password: Data) throws {
    let userName = "MessengerApp"
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: userName,
        kSecValueData as String: password,
    ]

    let status = SecItemAdd(query as CFDictionary, nil)

    guard status == errSecSuccess else {
      throw KeychainError.keySavingError
    }

  }

  static func retrieveData() -> String? {
    let userName = "MessengerApp"

    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: userName,
      kSecMatchLimit as String: kSecMatchLimitOne,
      kSecReturnAttributes as String: true,
      kSecReturnData as String: true,
    ]
    var item: CFTypeRef?

    if SecItemCopyMatching(query as CFDictionary, &item) == noErr {

      if let existingItem = item as? [String: Any],
         let username = existingItem[kSecAttrAccount as String] as? String,
         let passwordData = existingItem[kSecValueData as String] as? Data,
         let password = String(data: passwordData, encoding: .utf8)
      {
        print(username)
        print(password)
        return password
      }
    } else {
      print("Something went wrong trying to find the key in the keychain")
    }

    return nil
  }

}
