//
//  Identifiable.swift
//  Messenger Challenge
//
//  Created by Hasan on 24/12/2023.
//

import UIKit

protocol Identifiable {
  static var identifier: String { get }
}

extension Identifiable {
  static var identifier: String {
    String(describing: Self.self)
  }
}

extension UITableViewCell: Identifiable { }
