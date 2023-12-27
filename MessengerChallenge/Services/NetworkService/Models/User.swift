//
//  User.swift
//  Messenger Challenge
//
//  Created by Hasan on 24/12/2023.
//

import Foundation

typealias UserList = [String: User]

// MARK: - User
struct User: Codable {
  let userName: String
  let userId: String

  enum CodingKeys: String, CodingKey {
    case userName, userId
  }

}

// MARK: - Equatable
extension User: Equatable {
  static func == (lhs: User, rhs: User) -> Bool {
    lhs.userName == rhs.userName &&
    lhs.userId == rhs.userId
  }
}
