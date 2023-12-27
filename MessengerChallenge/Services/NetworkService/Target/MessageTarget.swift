//
//  MessageTarget.swift
//  Messenger Challenge
//
//  Created by Hasan on 25/12/2023.
//

import Foundation

enum MessageTarget {
  case message(String)
  case addMessage(Message, String)
}

extension MessageTarget: NetworkTarget {
  var baseURL: URL {
    URL(string: "https://messenger-3d9c1-default-rtdb.europe-west1.firebasedatabase.app/")!
  }

  var path: String {
    switch self {
    case let .addMessage(_, sessionNumber):
      return "messages/\(sessionNumber).json"
    case let .message(sessionNumber):
      return "messages/\(sessionNumber).json"
    }
  }

  var methodType: MethodType {
    switch self {
    case .message:
      return .get
    case .addMessage:
      return .post
    }
  }

  var contentType: ContentType {
    .applicationJson
  }

  var workType: WorkType {
    switch self {
    case .message:
      return .requestPlain

    case let .addMessage(message, _):
      let paramaters: Parameters = [
        "text": message.text,
        "sender": message.sender,
        "receiver": message.receiver,
      ]

      return .requestWithBodyParameters(parameters: paramaters)
    }
  }

}
