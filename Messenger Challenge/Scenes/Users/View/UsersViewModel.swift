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
}

final class UsersViewModel: ViewModel {
  weak var delegate: UsersViewModelDelegate?

  private let userAPIService: UserApiServiceProtocol

  private var userList: UserList = []
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
        self.userList = userList
        let dataSource = self.generateUserTableViewCellModel(from: userList)
        self.delegate?.didGetUsers(dataSource: dataSource)
      }
    }
  }

  func selectItem(at indexPath: IndexPath) -> User {
    let row = indexPath.row
    return userList[row]
  }

}

// MARK: - Private
private extension UsersViewModel {

  func generateUserTableViewCellModel(from dataSource: UserList) -> [UserTableViewCellModel] {
    dataSource.map {
      return UserTableViewCellModel(
        avatarUrl: $0.avatarURL,
        userName: $0.userName
      )
    }
  }

  func cleanDataSource() {
    userList = []
  }

}
