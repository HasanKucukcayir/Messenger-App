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
  func fetchAllMessages(sessionNumber: String) async -> Result<MessageList, NetworkError>

  func addMessage(sessionNumber: String, message: Message, completion: @escaping (Result<Void, NetworkError>) -> Void)
}


final class MessageApiService: NetworkService<MessageTarget> { }


// MARK: - MessageApiServiceProtocol
extension MessageApiService: MessageApiServiceProtocol {
  func fetchAllMessages(sessionNumber: String) async -> Result<MessageList, NetworkError> {
    do {
        // Call the async function using await
      let result: MessageList = try await request(target: .message(sessionNumber))

        // Return the result as a success
        return .success(result)
    } catch {
        // Handle errors and return as a failure
      return .failure(NetworkError.sessionError(error))
    }
  }


  func addMessage(sessionNumber: String, message: Message, completion: @escaping (Result<Void, NetworkError>) -> Void) {
    requestPlain(target: .addMessage(message, sessionNumber), completion: completion)
  }

}
