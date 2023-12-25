//
//  MessageView.swift
//  Messenger Challenge
//
//  Created by Hasan on 25/12/2023.
//

import UIKit

protocol MessageViewDelegate: UIViewController {
  func sendButtonTapped(_ text: String?)
}

final class MessageView: BaseView {

  private var dataSource: [MessageTableViewCellModel] = []
  weak var delegate: MessageViewDelegate?

  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.register(MessageTableViewCell.self,
                       forCellReuseIdentifier: MessageTableViewCell.identifier)
    tableView.dataSource = self
    tableView.rowHeight = 50
    tableView.separatorStyle = .singleLine
    return tableView
  }()

  private lazy var messageInputField: UITextField = {
    let textField = UITextField()
    textField.textColor = ColorHelper.darkGray
    textField.backgroundColor = ColorHelper.light
    textField.layer.cornerRadius = 10
    return textField
  }()

  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    return stackView
  }()

  private lazy var sendButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
    button.addTarget(self, action: #selector(didPressSendButton), for: .touchUpInside)
    return button
  }()


  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUIComponents()
    setupConstraints()
    messageInputField.delegate = self
  }

  enum ViewTrait {
    static let defaultPadding: CGFloat = 16
    static let contentPadding: CGFloat = 8
  }

}

// MARK: - Public
extension MessageView {
  func provideDataSource(_ dataSource: [MessageTableViewCellModel]) {
    self.dataSource = dataSource
    tableView.reloadData()
  }
}

// MARK: - UITableViewDataSource
extension MessageView: UITextFieldDelegate{
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    messageInputField.becomeFirstResponder()
  }

}

// MARK: - UITableViewDataSource
extension MessageView: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    dataSource.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.identifier, for: indexPath) as? MessageTableViewCell else {
      assertionFailure("Please provide a propper cell")
      return .init()
    }
    let model = dataSource[indexPath.row]
    cell.prepareCell(with: model)
    return cell
  }

}

// MARK: - Private
private extension MessageView {
  func setupUIComponents() {
    backgroundColor = ColorHelper.white

    stackView.addArrangedSubview(messageInputField)
    stackView.addArrangedSubview(sendButton)

    addSubviewVC(tableView)
    addSubviewVC(stackView)
    setupConstraints()
  }

  func setupConstraints() {
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: stackView.topAnchor),

      messageInputField.heightAnchor.constraint(equalToConstant: 44),
      sendButton.widthAnchor.constraint(equalToConstant: 44),

      stackView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
      stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: ViewTrait.defaultPadding),
      stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -ViewTrait.defaultPadding),
      stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -ViewTrait.defaultPadding)

    ])
  }

  @objc func didPressSendButton() {
    messageInputField.resignFirstResponder()
    delegate?.sendButtonTapped(messageInputField.text)
    clearDataSource()
  }

  private func clearDataSource() {
    messageInputField.text = ""
  }

}
