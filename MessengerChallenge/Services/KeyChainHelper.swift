//
//  KeyChainHelper.swift
//  Messenger Challenge
//
//  Created by Hasan on 25/12/2023.
//

import Security
import Foundation

final class KeyChainHelper {
  var userName: String

  init(userName: String) {
    self.userName = userName
  }

  func storeData(password: Data) {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: userName,
      kSecValueData as String: password,
    ]

    _ = SecItemAdd(query as CFDictionary, nil)

    if SecItemAdd(query as CFDictionary, nil) == noErr {
      print("User saved successfully in the keychain")
    } else {
      print("Something went wrong trying to save the user in the keychain")
      update(password: password)
    }

  }

  func update(password: Data) {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: userName,
    ]

    let attributes: [String: Any] = [kSecValueData as String: password]

    if SecItemUpdate(query as CFDictionary, attributes as CFDictionary) == noErr {
      print("Password has changed")
    } else {
      print("Something went wrong trying to update the password")
    }
  }

  func retrieveData() -> String? {
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
         let _ = existingItem[kSecAttrAccount as String] as? String,
         let passwordData = existingItem[kSecValueData as String] as? Data,
         let password = String(data: passwordData, encoding: .utf8)
      {
        return password
      }
    } else {
      print("No user key found in the keychain. Please add a user.")
    }

    return nil
  }

}
