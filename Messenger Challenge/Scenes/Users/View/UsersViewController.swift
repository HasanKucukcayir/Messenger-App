//
//  UsersViewController.swift
//  Messenger Challenge
//
//  Created by Hasan on 24/12/2023.
//

import UIKit

protocol UsersViewModelDelegate: UIViewController {
  func didGetUsers(dataSource: [UserTableViewCellModel])
  func didFailForGettingUsers()
}

final class UsersViewController: BaseViewController {
  private let mainView: UsersView
  private let viewModel: UsersViewModelProtocol

  init(view: UsersView, viewModel: UsersViewModel) {
    self.mainView = view
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    viewModel.delegate = self
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    mainView.delegate = self
    view = mainView
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    viewModel.fetchAllUsers()

    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add",
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(addTapped))

    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Refresh",
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(refreshButtonTapped))
  }

}

// MARK: - Actions
extension UsersViewController {
  @objc func addTapped() {
    let alert = UIAlertController(title: "Add User",
                                  message: nil,
                                  preferredStyle: .alert)

    alert.addTextField()

    alert.addAction(UIAlertAction(title: "OK",
                                  style: .default,
                                  handler: { [weak alert] (_) in
      let textField = alert?.textFields![0]
      let key = UUID().uuidString
      self.viewModel.addUser(user: User(userName: textField?.text ?? "User",
                                        userId: key))
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        self.viewModel.fetchAllUsers()
      }

    }))

    present(alert, animated: true, completion: nil)
  }

  @objc func refreshButtonTapped() {
    viewModel.fetchAllUsers()
  }

}

// MARK: - UsersViewDelegate
extension UsersViewController: UsersViewDelegate {
  func didSelectItem(at indexPath: IndexPath) {
    let receiver = viewModel.selectItem(at: indexPath)
    print(receiver.userName)
    print(receiver.userId)
    guard let senderUserId = KeyChainHelper.retrieveData() else {
      return
    }
    let userIds = [senderUserId, receiver.userId].sorted()
    let sessionNumber = viewModel.generateSessionCode(userIds: userIds)
    let viewController = MessageViewController(view: MessageView(),
                                               viewModel: MessagesViewModel(messageApiService: MessageApiService()),
                                               sessionNumber: sessionNumber)
    navigationController?.pushViewController(viewController, animated: true)
  }

}

// MARK: - UsersViewModelDelegate
extension UsersViewController: UsersViewModelDelegate {
  func didGetUsers(dataSource: [UserTableViewCellModel]) {
    DispatchQueue.main.async {
      self.mainView.provideDataSource(dataSource)
    }
  }

  func didFailForGettingUsers() {
    DispatchQueue.main.async {
      let title = "Failed To get Users"
      let description = "Ooops something went wrong :("
      let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
      alert.addAction(.init(title: "Cancel", style: .destructive))
      alert.addAction(.init(title: "Retry", style: .default, handler: { _ in
        self.viewModel.fetchAllUsers()
      }))
      self.present(alert, animated: true)
    }
  }

}
