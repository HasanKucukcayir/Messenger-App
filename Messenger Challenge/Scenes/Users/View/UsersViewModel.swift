//
//  UsersViewModel.swift
//  Messenger Challenge
//
//  Created by Hasan on 24/12/2023.
//

import UIKit

protocol UsersViewModelProtocol: ViewModel {
  /// Fetches All Users
  func fetchAllUsers()

  /// Selects an item from Datasource
  /// - Parameter indexPath: indexPath of  Item
  func selectItem(at indexPath: IndexPath) -> User

  /// Adds a user to the database
  func addUser(user: User)

  /// Generates session number
  func generateSessionCode(userIds: [String]) -> String
}

final class UsersViewModel: ViewModel {
  weak var delegate: UsersViewModelDelegate?

  private let userAPIService: UserApiServiceProtocol

  private var userList: UserList = [:]
  init(userAPIService: UserApiServiceProtocol) {
    self.userAPIService = userAPIService
  }

}

// MARK: - UsersViewModelProtocol
extension UsersViewModel: UsersViewModelProtocol {
  func fetchAllUsers() {
    cleanDataSource()
    userAPIService.fetchAllUsers { result in
      switch result {
      case .failure:
        self.delegate?.didFailForGettingUsers()

      case .success(let userList):
        self.userList = self.filterCurrentUserName(userList: userList)
        let dataSource = self.generateUserTableViewCellModel(from: self.userList)
        self.delegate?.didGetUsers(dataSource: dataSource)
      }
    }
  }

  func addUser(user: User) {
    userAPIService.addUser(user: user) { result in
      switch result {
      case .failure:
        print("An error accured while adding a the user data.")
      case .success():
        self.storeKey(user: user)
        print("User data added successfully")
      }
    }
  }

  func storeKey(user: User) {
    let password = user.userId.data(using: .utf8)!

    print(password)
    do {
      try KeyChainHelper.storeData(password: password)
    } catch {
      print(KeychainError.keySavingError.localizedDescription)
    }

  }

  func selectItem(at indexPath: IndexPath) -> User {
    let row = indexPath.row

    let keysArray = Array(userList.keys)

    let key = keysArray[row]
    guard let value = userList[key] else {
      return userList.first?.value ?? User(userName: "TestUser", userId: "TestUserId")
    }
    return value
  }

  func generateSessionCode(userIds: [String]) -> String {
    return userIds.joined(separator: "*")
  }

}

// MARK: - Private
private extension UsersViewModel {

  func generateUserTableViewCellModel(from dataSource: UserList) -> [UserTableViewCellModel] {
    dataSource.map {
      return UserTableViewCellModel(
        userName: $0.value.userName,
        userId: $0.value.userId
      )
    }
  }

  func filterCurrentUserName(userList: UserList) -> UserList {
    guard let userID = KeyChainHelper.retrieveData() else {
      return UserList()
    }

    let filtered = userList.filter { $0.value.userId != userID }

    return filtered
  }

  func cleanDataSource() {
    userList = [:]
  }

}
