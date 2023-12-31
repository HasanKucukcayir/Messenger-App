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
  func fetchAllMessages(
    sessionNumber: String
  ) async -> Result<MessageList, NetworkError>

  func addMessage(
    sessionNumber: String,
    message: Message) async -> Result<Void, NetworkError>
}


final class MessageApiService: NetworkService<MessageTarget> { }


// MARK: - MessageApiServiceProtocol
extension MessageApiService: MessageApiServiceProtocol {
  
  func fetchAllMessages(
    sessionNumber: String
  ) async -> Result<MessageList, NetworkError> {
    do {
      let result: MessageList = try await request(target: .message(sessionNumber))
        return .success(result)
    } catch {
      return .failure(error as! NetworkError)
    }
  }

  func addMessage(sessionNumber: String, message: Message) async -> Result<Void, NetworkError> {
    do {
      try await requestPlain(target: .addMessage(message, sessionNumber))
      return .success(())
    } catch(let error) {
      return .failure(error as! NetworkError)
    }
  }

}
