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

  /// Adds message to the firebase database
  func addMessage(sessionNumber: String, message: Message)

  /// Encrypts the message before posting to database
  func encryptMessage(dataString: String, senderId: String, receiverId: String) -> String?
}

final class MessagesViewModel: ViewModel {
  weak var delegate: MessagesViewModelDelegate?

  private let messageAPIService: MessageApiServiceProtocol
  private let keyChainHelper: KeyChainHelper

  let cryptographyManager = CryptographyManager()

  private var messageList: MessageList = [:]
  
  init(
    messageApiService: MessageApiServiceProtocol,
    keyChainHelper: KeyChainHelper
  ) {
    self.messageAPIService = messageApiService
    self.keyChainHelper = keyChainHelper
  }

}

// MARK: - MessagesViewModelProtocol
extension MessagesViewModel: MessagesViewModelProtocol {

  func fetchAllMessages(sessionNumber: String) {
    cleanDataSource()

    Task {
      let result = await messageAPIService.fetchAllMessages(sessionNumber: sessionNumber)

      switch result {
      case .failure(let error):
        if error.localizedDescription == NetworkError.decodingError(error).localizedDescription {
          return
        }

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

    Task {
      let result = await messageAPIService.addMessage(
        sessionNumber: sessionNumber,
        message: message
      )

      switch result {
      case .failure(let error):
        print("An error accured while adding a the message. \(error)")
      case .success():
        print("The message added successfully")
      }
    }

  }

  func encryptMessage(
    dataString: String,
    senderId: String,
    receiverId: String
  ) -> String? {
    guard let encryptedData = cryptographyManager.encrypt(
      dataString: dataString,
      senderId: senderId,
      receiverId: receiverId
    ) else {
      return nil
    }
    return encryptedData
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

    var sorted = dataSource.sorted {$0.text < $1.text}

    let myId = keyChainHelper.retrieveData()!

    for i in 0 ..< sorted.count {
      let model = sorted[i]

      let key = cryptographyManager.generateKey(senderId: model.senderID,
                                                receiverId: model.receiverId)

      if dataSource[i].senderID == myId {
        if let text = cryptographyManager.decryptSentMessage(
          base64EncodedString: model.text,
          key: key) {
          sorted[i].text = text
        }

      } else {
        if let text = cryptographyManager.decryptReceivedMessage(
          base64EncodedString: model.text,
          key: key) {
          sorted[i].text = text
        }
      }

    }

    return sorted
  }

}
