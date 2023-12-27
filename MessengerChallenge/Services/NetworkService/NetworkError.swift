//
//  NetworkError.swift
//  Messenger Challenge
//
//  Created by Hasan on 24/12/2023.
//

import Foundation

enum NetworkError: Error {
  case unknown
  case sessionError(Error)
  case decodingError(Error)
  case unsucessfulStatusCode(code: Int)
}
