//
//  MessageViewController.swift
//  Messenger Challenge
//
//  Created by Hasan on 25/12/2023.
//

import UIKit

protocol MessagesViewModelDelegate: UIViewController {
  func didGetMessages(dataSource: [MessageTableViewCellModel])
  func didFailForGettingMessages()
}

final class MessageViewController: BaseViewController {
  private let mainView: MessageView
  private let viewModel: MessagesViewModelProtocol

  var sessionNumber: String

  init(view: MessageView, viewModel: MessagesViewModel, sessionNumber: String) {
    self.mainView = view
    self.viewModel = viewModel
    self.sessionNumber = sessionNumber
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

    viewModel.fetchAllMessages(sessionNumber: sessionNumber)

    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Refresh",
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(refreshButtonTapped))

    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(
      self,
      selector: #selector(keyboardWillShow),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )

    notificationCenter.addObserver(
      self,
      selector: #selector(keyboardWillHide),
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

}

// MARK: - Private
private extension MessageViewController {
  @objc func keyboardWillShow(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {

      if self.view.frame.origin.y == 0 {
        self.view.frame.origin.y -= (keyboardSize.height)
      }

    }
  }

  @objc func keyboardWillHide(notification: NSNotification) {
    if self.view.frame.origin.y != 0 {
      self.view.frame.origin.y = 0
    }
  }

  @objc func refreshButtonTapped() {
    viewModel.fetchAllMessages(sessionNumber: sessionNumber)
  }

}

// MARK: - UsersViewModelDelegate
extension MessageViewController: MessageViewDelegate {
  func sendButtonTapped(_ text: String?) {
    guard let message = text else { return }

    viewModel.addMessage(sessionNumber: sessionNumber,
                         message: Message(sender: "Hasan",
                                          receiver: "TestUser",
                                          text: message))
  }
}

// MARK: - UsersViewModelDelegate
extension MessageViewController: MessagesViewModelDelegate {
  func didGetMessages(dataSource: [MessageTableViewCellModel]) {
    DispatchQueue.main.async {
      self.mainView.provideDataSource(dataSource)
    }
  }

  func didFailForGettingMessages() {
    DispatchQueue.main.async {
      let title = "Failed to get Messages"
      let description = "Ooops something went wrong :("
      let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
      alert.addAction(.init(title: "Cancel", style: .destructive))
      alert.addAction(.init(title: "Retry", style: .default, handler: { _ in
        self.viewModel.fetchAllMessages(sessionNumber: self.sessionNumber)
      }))
      self.present(alert, animated: true)
    }
  }

}
