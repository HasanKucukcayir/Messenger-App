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
  private let cryptographyManager = CryptographyManager()

  private var messageList: MessageList = [:]
  init(messageApiService: MessageApiServiceProtocol) {
    self.messageAPIService = messageApiService
  }

}

// MARK: - MessagesViewModelProtocol
extension MessagesViewModel: MessagesViewModelProtocol {

  func fetchAllMessages(sessionNumber: String) {
    cleanDataSource()

    Task {
      let result = await messageAPIService.fetchAllMessages(sessionNumber: sessionNumber)

      switch result {
      case .failure:
        self.delegate?.didFailForGettingMessages()

      case .success(let messageList):
        self.messageList = messageList
        let dataSource = self.generateMessageTableViewCellModel(from: messageList)

        let resolvedDataSource = self.resolveMessages(dataSource: dataSource)

        self.delegate?.didGetMessages(dataSource: resolvedDataSource)
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
        text: $0.value.text,
        senderID: $0.value.sender,
        receiverId: $0.value.receiver
      )
    }
  }

  func cleanDataSource() {
    messageList = [:]
  }

  func resolveMessages(dataSource: [MessageTableViewCellModel]) -> [MessageTableViewCellModel] {

    var sorted = dataSource.sorted { $0.text < $1.text}

    let myId = KeyChainHelper.retrieveData()!

    for i in 0 ..< sorted.count {

      let text = sorted[i].text

      if dataSource[i].senderID == myId {
        sorted[i].text = cryptographyManager.decryptSentMessage(
          base64EncodedString: text)!
      } else {
        let id = sorted[i].senderID
        let key = cryptographyManager.generateKey(with: id)
        sorted[i].text = cryptographyManager.decryptReceivedMessage(
          base64EncodedString: text,
          key: key!)!
      }

    }

    return sorted
  }

}
