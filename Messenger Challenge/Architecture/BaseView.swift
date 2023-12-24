//
//  BaseView.swift
//  Messenger Challenge
//
//  Created by Hasan on 24/12/2023.
//

import UIKit

class BaseView: UIView {

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  @available (*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
