//
//  UsersView.swift
//  Messenger Challenge
//
//  Created by Hasan on 24/12/2023.
//

import UIKit

protocol UsersViewDelegate: UIViewController {
  func didSelectItem(at indexPath: IndexPath)
}

final class UsersView: BaseView {

  weak var delegate: UsersViewDelegate?

  private var dataSource: [UserTableViewCellModel] = []

  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifier)
    tableView.dataSource = self
    tableView.delegate = self
    tableView.rowHeight = 100
    tableView.separatorStyle = .singleLine
    return tableView
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUIComponents()
    setupConstraints()
  }

}

// MARK: - Public
extension UsersView {

  func provideDataSource(_ dataSource: [UserTableViewCellModel]) {
    self.dataSource = dataSource
    tableView.reloadData()
  }
}

// MARK: - UITableViewDataSource
extension UsersView: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    dataSource.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as? UserTableViewCell else {
      assertionFailure("Please provide a propper cell")
      return .init()
    }
    let model = dataSource[indexPath.row]
    cell.prepareCell(with: model)
    return cell
  }

}

// MARK: - UITableViewDelegate
extension UsersView: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    delegate?.didSelectItem(at: indexPath)
  }
}

// MARK: - Private
private extension UsersView {
  func setupUIComponents() {
    backgroundColor = ColorHelper.white

    addSubviewVC(tableView)
    setupConstraints()
  }

  func setupConstraints() {
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
    ])
  }

}
