//
//  MessageApiService.swift
//  Messenger Challenge
//
//  Created by Hasan on 25/12/2023.
//

import Foundation

protocol MessageApiServiceProtocol {
  /// Fetches all messages
  /// - Parameter completion: Result with Success(Message) or Failure(NetworkError)
  func fetchAllMessages(sessionNumber: String, completion: @escaping (Result<MessageList, NetworkError>) -> Void)

  func addMessage(sessionNumber: String, message: Message, completion: @escaping (Result<Void, NetworkError>) -> Void)
}


final class MessageApiService: NetworkService<MessageTarget> { }


// MARK: - MessageApiServiceProtocol
extension MessageApiService: MessageApiServiceProtocol {
  func fetchAllMessages(sessionNumber: String, completion: @escaping (Result<MessageList, NetworkError>) -> Void) {
    request(target: .message(sessionNumber), completion: completion)
  }

  func addMessage(sessionNumber: String, message: Message, completion: @escaping (Result<Void, NetworkError>) -> Void) {
    requestPlain(target: .addMessage(message, sessionNumber), completion: completion)
  }

}
