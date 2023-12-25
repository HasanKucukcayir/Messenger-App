//
//  Message.swift
//  Messenger Challenge
//
//  Created by Hasan on 25/12/2023.
//

import Foundation

typealias MessageList = [String: Message]

// MARK: - Message
struct Message: Codable {
  let sender: String
  let receiver: String
  let text: String

  enum CodingKeys: String, CodingKey {
    case sender, receiver, text
  }

}

// MARK: - Equatable
extension Message: Equatable {
  static func == (lhs: Message, rhs: Message) -> Bool {
    lhs.sender == rhs.sender &&
    lhs.receiver == rhs.receiver &&
    lhs.text == rhs.text
  }
}
