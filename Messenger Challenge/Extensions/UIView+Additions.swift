//
//  UIView+Additions.swift
//  Messenger Challenge
//
//  Created by Hasan on 24/12/2023.
//

import UIKit

extension UIView {

  /// sets translatesAutoresizingMaskIntoConstraints to ´False´ and calls ´addSubview´
  func addSubviewVC(_ view: UIView) {
    view.translatesAutoresizingMaskIntoConstraints = false
    addSubview(view)
  }
}
