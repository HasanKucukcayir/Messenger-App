//
//  UserTarget.swift
//  Messenger Challenge
//
//  Created by Hasan on 24/12/2023.
//

import Foundation

enum UserTarget {
  case user
  case addUser(User)
}

extension UserTarget: NetworkTarget {
  var baseURL: URL {
    URL(string: "https://messenger-3d9c1-default-rtdb.europe-west1.firebasedatabase.app/")!
  }

  var path: String {
    switch self {
    case .user, .addUser:
      return "users.json"
    }
  }

  var methodType: MethodType {
    switch self {
    case .user:
      return .get
    case .addUser:
      return .post
    }
  }

  var contentType: ContentType {
    .applicationJson
  }

  var workType: WorkType {
    switch self {
    case .user:
      return .requestPlain

    case let .addUser(user):
      let paramaters: Parameters = [
        "userName": user.userName,
        "userId": user.userId
      ]

      return .requestWithBodyParameters(parameters: paramaters)
    }
  }

}
