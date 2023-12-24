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

final class UsersViewController: BaseViewController, ViewControllerProtocol{

  typealias ViewModelType = UsersViewModel
  typealias ViewType = UsersView

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
  }

}

// MARK: - UsersViewDelegate
extension UsersViewController: UsersViewDelegate {

  func didSelectItem(at indexPath: IndexPath) {
    // TODO: use this value for getting messages
    let user = viewModel.selectItem(at: indexPath)
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
