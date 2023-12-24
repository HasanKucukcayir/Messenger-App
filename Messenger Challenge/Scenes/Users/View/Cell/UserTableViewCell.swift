//
//  UserTableViewCell.swift
//  Messenger Challenge
//
//  Created by Hasan on 24/12/2023.
//

import UIKit

final class UserTableViewCell: UITableViewCell {

  private lazy var containerView: UIView = {
    let view = UIView()
    view.backgroundColor = ColorHelper.white
    view.layer.cornerRadius = 15
    view.clipsToBounds = true
    return view
  }()

  private lazy var avatarImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(systemName: "person")
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()

  private lazy var userLabel: UILabel = {
    let label = UILabel()
    label.textColor = ColorHelper.light
    label.font = .systemFont(ofSize: 16, weight: .semibold)
    label.textAlignment = .left
    return label
  }()


  enum ViewTrait {
    static let defaultPadding: CGFloat = 16
    static let contentPadding: CGFloat = 8
    static let cellHeight: CGFloat = 120
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
extension UserTableViewCell {
  func prepareCell(with model: UserTableViewCellModel) {
    userLabel.text = model.userName
    avatarImageView.image = UIImage(systemName: "person")
  }
}

// MARK: - Private
private extension UserTableViewCell {
  func setupUIComponents() {
    selectionStyle = .none

    contentView.addSubviewVC(containerView)

    containerView.addSubviewVC(avatarImageView)
    containerView.addSubviewVC(userLabel)
  }

  func setupConstraints() {
    NSLayoutConstraint.activate([
      containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: ViewTrait.defaultPadding),
      containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ViewTrait.defaultPadding),
      containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -ViewTrait.defaultPadding),
      containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -ViewTrait.defaultPadding),
    ])
    setupContainerViewConstraints()
  }

  func setupContainerViewConstraints() {
    NSLayoutConstraint.activate([
      avatarImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      avatarImageView.widthAnchor.constraint(equalToConstant: 50),
      avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
      avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

      userLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: ViewTrait.defaultPadding),
      userLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: ViewTrait.defaultPadding),
      userLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -ViewTrait.defaultPadding)
    ])
  }

}

struct UserTableViewCellModel {
  let avatarUrl: URL?
  let userName: String?
}
