//
//  User.swift
//  Messenger Challenge
//
//  Created by Hasan on 24/12/2023.
//

import Foundation

typealias UserList = [User]

// MARK: - User
struct User: Codable {
  let userName: String
  let userNumber: String
  let avatarURL: URL?

  enum CodingKeys: String, CodingKey {
    case userName, userNumber
    case avatarURL = "avatarURL"
  }

}

// MARK: - Equatable
extension User: Equatable {
  static func == (lhs: User, rhs: User) -> Bool {
    lhs.userName == rhs.userName &&
    lhs.userNumber == rhs.userNumber &&
    lhs.avatarURL == rhs.avatarURL
  }
}
