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
  func fetchAllUsers() async -> Result<UserList, NetworkError>

  func addUser(user: User, completion: @escaping (Result<Void, NetworkError>) -> Void)
}


final class UserApiService: NetworkService<UserTarget> { }


// MARK: - UserApiServiceProtocol
extension UserApiService: UserApiServiceProtocol {
  func fetchAllUsers() async -> Result<UserList, NetworkError> {
    do {
      let result: UserList = try await request(target: .user)
      return .success(result)
    } catch {
      return .failure(NetworkError.sessionError(error))
    }

  }

  func addUser(user: User, completion: @escaping (Result<Void, NetworkError>) -> Void) {
    requestPlain(target: .addUser(user),
                 completion: completion)
  }

}
