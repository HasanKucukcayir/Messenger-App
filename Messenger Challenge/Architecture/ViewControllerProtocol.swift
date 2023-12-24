//
//  ViewControllerProtocol.swift
//  Messenger Challenge
//
//  Created by Hasan on 24/12/2023.
//

import UIKit

protocol ViewControllerProtocol: UIViewController {
  associatedtype ViewModelType: ViewModel
  associatedtype ViewType: BaseView

  init(view: ViewType, viewModel: ViewModelType)
}
