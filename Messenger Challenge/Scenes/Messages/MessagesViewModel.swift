//
//  MessagesViewModel.swift
//  Messenger Challenge
//
//  Created by Hasan on 25/12/2023.
//

import Foundation
import CommonCrypto

protocol MessagesViewModelProtocol: ViewModel {
  /// Fetches All Messages
  func fetchAllMessages(sessionNumber: String)

  /// Adds message to the database
  func addMessage(sessionNumber: String, message: Message)
}

final class MessagesViewModel: ViewModel {
  weak var delegate: MessagesViewModelDelegate?

  private let messageAPIService: MessageApiServiceProtocol

  private var messageList: MessageList = [:]
  init(messageApiService: MessageApiServiceProtocol) {
    self.messageAPIService = messageApiService
  }

}

// MARK: - MessagesViewModelProtocol
extension MessagesViewModel: MessagesViewModelProtocol {

  func fetchAllMessages(sessionNumber: String) {
    cleanDataSource()
    messageAPIService.fetchAllMessages(sessionNumber: sessionNumber) { result in
      switch result {
      case .failure:
        self.delegate?.didFailForGettingMessages()

      case .success(let messageList):
        self.messageList = messageList
        let dataSource = self.generateMessageTableViewCellModel(from: messageList)
        self.delegate?.didGetMessages(dataSource: dataSource)
      }
    }
  }

  func addMessage(sessionNumber: String, message: Message) {
    messageAPIService.addMessage(sessionNumber: sessionNumber,
                                 message: Message(sender: message.sender,
                                                  receiver: message.receiver,
                                                  text: message.text)) { result in
      switch result {
      case .failure:
        print("An error accured while adding a the user data.")
      case .success():
        print("User data added successfully")
      }
    }
  }

}

// MARK: - Private
private extension MessagesViewModel {
  func generateMessageTableViewCellModel(from dataSource: MessageList) -> [MessageTableViewCellModel] {
    dataSource.map {
      return MessageTableViewCellModel(
        text: $0.value.text
      )
    }
  }

  func cleanDataSource() {
    messageList = [:]
  }
}