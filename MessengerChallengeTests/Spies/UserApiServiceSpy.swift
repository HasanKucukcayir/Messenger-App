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

  func fetchAllUsers() async -> Result<MessengerChallenge.UserList, MessengerChallenge.NetworkError> {
    if isFailingActive {
      return .failure(.unknown)
    } else {
      return .success(providedDataSource)
    }
  }

  func addUser(user: MessengerChallenge.User) async -> (Result<Void, MessengerChallenge.NetworkError>) {
    if isSuccessfull {
      return .success(())
    } else {
      return .failure(.unknown)
    }
  }

}
