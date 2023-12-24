//
//  BaseViewController.swift
//  Messenger Challenge
//
//  Created by Hasan on 24/12/2023.
//

import UIKit

class BaseViewController: UIViewController {
  var isNavigationBarHiddden: Bool = false

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(isNavigationBarHiddden, animated: true)
  }

}
