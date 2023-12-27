//
//  UserApiServiceSpy.swift
//  MessengerChallengeTests
//
//  Created by Hasan on 26/12/2023.
//

import Foundation
@testable import MessengerChallenge

final class UserApiServiceSpy: NetworkService<UserTarget>, UserApiServiceProtocol {

  var providedDataSource: UserList!

  var isFailingActive: Bool = false
  var isSuccessfull: Bool = false

  func fetchAllUsers(completion: @escaping (Result<UserList, NetworkError>) -> Void) {
    if isFailingActive {
      completion(.failure(.unknown))
    } else {
      completion(.success(providedDataSource))
    }
  }

  func addUser(user: User, completion: @escaping (Result<Void, NetworkError>) -> Void) {
    isSuccessfull ? completion(.success(())) : completion(.failure(.unknown))
  }

}
