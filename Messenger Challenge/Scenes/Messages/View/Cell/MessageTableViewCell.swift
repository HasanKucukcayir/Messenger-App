//
//  MessageTableViewCell.swift
//  Messenger Challenge
//
//  Created by Hasan on 25/12/2023.
//

import UIKit

final class MessageTableViewCell: UITableViewCell {

  private lazy var containerView: UIView = {
    let view = UIView()
    view.backgroundColor = ColorHelper.lightGray
    view.layer.cornerRadius = 15
    view.clipsToBounds = true
    return view
  }()

  private lazy var messageText: UILabel = {
    let label = UILabel()
    label.text = "test"
    label.textColor = ColorHelper.strong
    label.backgroundColor = .clear
    label.font = .systemFont(ofSize: 16, weight: .semibold)
    label.textAlignment = .left
    return label
  }()

  enum ViewTrait {
    static let defaultPadding: CGFloat = 16
    static let contentPadding: CGFloat = 8
  }

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUIComponents()
    setupConstraints()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

// MARK: - Public
extension MessageTableViewCell {
  func prepareCell(with model: MessageTableViewCellModel) {
    messageText.text = model.text
  }
}

// MARK: - Private
private extension MessageTableViewCell {
  func setupUIComponents() {
    selectionStyle = .none

    contentView.addSubviewVC(containerView)
    containerView.addSubviewVC(messageText)
  }

  func setupConstraints() {
    NSLayoutConstraint.activate([
      containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: ViewTrait.contentPadding),
      containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
    ])
    setupContainerViewConstraints()
  }

  func setupContainerViewConstraints() {
    NSLayoutConstraint.activate([
      messageText.heightAnchor.constraint(equalTo: containerView.heightAnchor),
      messageText.topAnchor.constraint(equalTo: containerView.topAnchor),
      messageText.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: ViewTrait.defaultPadding),
      messageText.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
    ])
  }

}

struct MessageTableViewCellModel {
  var text: String
  var senderID: String
  var receiverId: String
}
