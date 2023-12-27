//
//  UsersViewModelTests.swift
//  MessengerChallengeTests
//
//  Created by Hasan on 27/12/2023.
//

import XCTest
@testable import Messenger_Challenge

final class UsersViewModelTests: XCTestCase {
  private var sut: UsersViewModel!
  private var userAPIServiceSpy: UserApiServiceSpy!
  private var viewControllerSpy: UsersViewModelDelegateSpy!
  private var testDataSource: UserList!

  override func setUp() {
    super.setUp()
    testDataSource = ["key1" : User(userName: "Hasan", userId: "0113H"),
                      "key2" : User(userName: "iPhone 15", userId: "0113I")]
    userAPIServiceSpy = UserApiServiceSpy()
    sut = UsersViewModel(userAPIService: userAPIServiceSpy)
    viewControllerSpy = UsersViewModelDelegateSpy()
    sut.delegate = viewControllerSpy
  }

  override func tearDown() {
    userAPIServiceSpy = nil
    viewControllerSpy = nil
    sut = nil
    testDataSource = nil
    super.tearDown()
  }

}

// MARK: - Tests
extension UsersViewModelTests {

  func testFetchAllUsers() {
    fetchAllUsers()
  }

  func testFetchAllUsersFailure() {
    viewControllerSpy.didFailForGettingUsersExpectation = expectation(description: "didFailForGettingUsersExpectation")
    userAPIServiceSpy.isFailingActive = true
    sut.fetchAllUsers()
    wait(for: [viewControllerSpy.didFailForGettingUsersExpectation], timeout: 0.1)
  }

}


// MARK: - Private
private extension UsersViewModelTests {

  func compareTestDataSource(userList: UserList,
                             expectedDataSource: [UserTableViewCellModel]) {

    let user = userList.map {
      return UserTableViewCellModel(
        userName: $0.value.userName,
        userId: $0.value.userId
      )
    }

    for i in 0..<expectedDataSource.count {
      let expectedCellModel = expectedDataSource[i]
      let userName = user[i].userName
      let userId = user[i].userId
      XCTAssertEqual(userName, expectedCellModel.userName)
      XCTAssertEqual(userId, expectedCellModel.userId)
    }
  }

  func fetchAllUsers() {
    userAPIServiceSpy.providedDataSource = testDataSource
    viewControllerSpy.didGetUsersExpectation = expectation(description: "didGetUsersExpectation")
    sut.fetchAllUsers()
    wait(for: [viewControllerSpy.didGetUsersExpectation], timeout: 0.1)
    guard testDataSource.count == viewControllerSpy.dataSource.count else {
      XCTFail("DataSource amount should be equal")
      return
    }
    compareTestDataSource(userList: testDataSource,
                          expectedDataSource: viewControllerSpy.dataSource)
  }

}
