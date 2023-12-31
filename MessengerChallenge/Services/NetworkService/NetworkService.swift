//
//  NetworkService.swift
//  Messenger Challenge
//
//  Created by Hasan on 24/12/2023.
//

import Foundation

class NetworkService<T: NetworkTarget> { }

// MARK: - Public
extension NetworkService {

  /// Makes a request for a Decodable Response
  /// - Parameters:
  ///   - target: TargetType to be targeted
  @MainActor
  func request<D: Decodable>(target: T) async throws -> D {
    return try await withCheckedThrowingContinuation { continuation in
        let request = self.prepareRequest(from: target)

        URLSession.shared.dataTask(with: request) { (data, response, error) in
          guard response != nil, let data1 = data else {
            if let error = error {
              continuation.resume(with: .failure(NetworkError.sessionError(error)))
            } else {
              continuation.resume(with: .failure(NetworkError.unknown))
            }
            return
          }
          do {

            let model = try JSONDecoder().decode(D.self, from: data1)

            continuation.resume(with: .success(model))
          } catch {
            continuation.resume(with: .failure(NetworkError
              .decodingError(error)))
          }
        }.resume()

    }
  }

  /// Makes a request
  /// - Parameters:
  ///   - target: TargetType to be targeted
  @MainActor
  func requestPlain(target: T) async throws {
    return try await withCheckedThrowingContinuation { continuation in
      let request = self.prepareRequest(from: target)

      URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard let response1 = response as? HTTPURLResponse else {
          if let error = error {
            continuation.resume(with: .failure(NetworkError.sessionError(error)))
          } else {
            continuation.resume(with: .failure(NetworkError.unknown))
          }
          return
        }
        if (200..<300).contains(response1.statusCode) {
          continuation.resume(with: .success(()))
        } else {
          continuation.resume(with: .failure(NetworkError.unsucessfulStatusCode(code: response1.statusCode)))
        }
      }.resume()
    }
  }
}

// MARK: - Private
private extension NetworkService {

  /// Prepares request  from TargetType
  /// - Parameter target: TargetType to be prepared
  /// - Returns: Prepared Request
  func prepareRequest(from target: T) -> URLRequest {
    var request: URLRequest!
    let pathAppended = target.baseURL.appendingPathComponent(target.path)

    switch target.workType {
    case .requestPlain:
      request = URLRequest(url: pathAppended)

    case let .requestWithUrlParameters(parameters):
      let queryGeneratedURL = pathAppended.generateUrlWithQuery(with: parameters)
      request = URLRequest(url: queryGeneratedURL)

    case let .requestWithBodyParameters(parameters):
      let data = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
      request = URLRequest(url: pathAppended)
      request.httpBody = data
    }
    request.httpMethod = target.methodType.rawValue
    request.addValue(target.methodType.rawValue, forHTTPHeaderField: "Content-Type")
    return request
  }

}
