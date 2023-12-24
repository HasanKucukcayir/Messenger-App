//
//  UserApiService.swift
//  Messenger Challenge
//
//  Created by Hasan on 24/12/2023.
//

import Foundation

protocol UserApiServiceProtocol {
  /// Fetches all users
  /// - Parameter completion: Result with Success(User) or Failure(NetworkError)
  func fetchAllUsers(completion: @escaping (Result<UserList, NetworkError>) -> Void)
}


final class UserApiService: NetworkService<UserTarget> { }


// MARK: - UserApiServiceProtocol
extension UserApiService: UserApiServiceProtocol {
  func fetchAllUsers(completion: @escaping (Result<UserList, NetworkError>) -> Void) {
    request(target: .user, completion: completion)
  }

}
