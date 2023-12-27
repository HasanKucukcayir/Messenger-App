//
//  UsersViewModelDelegateSpy.swift
//  MessengerChallengeTests
//
//  Created by Hasan on 27/12/2023.
//

import XCTest
@testable import MessengerChallenge

final class UsersViewModelDelegateSpy: UIViewController, UsersViewModelDelegate {
  var didFailForGettingUsersExpectation: XCTestExpectation!
  var didGetUsersExpectation: XCTestExpectation!
  var dataSource: [UserTableViewCellModel]!

  func didGetUsers(dataSource: [UserTableViewCellModel]) {
    self.dataSource = dataSource
    didGetUsersExpectation.fulfill()
  }

  func didFailForGettingUsers() {
    didFailForGettingUsersExpectation.fulfill()
  }

}
