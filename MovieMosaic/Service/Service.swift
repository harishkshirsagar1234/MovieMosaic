//
//  Service.swift
//  MovieMosaic
//
//  Created by Harish Kshirsagar on 25/02/25.
//

import Foundation
import Combine
import Security

enum NetworkError: Error {
    case unknownError
    case invalidRequest
    case invalidResponse
    case decodingFailed
    case invalidURL
}

protocol ServiceProvider {
    func perform<T: Decodable>(from urlString: String) -> AnyPublisher<T, Error>
}
            
public class Service: NSObject, ServiceProvider {
    
    var session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func perform<T: Decodable>(from urlString: String) -> AnyPublisher<T, Error> {
        self.session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return self.session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

}

extension Service: URLSessionDelegate {
    
//    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//        
//        // Ensure we have server trust
//        guard let serverTrust = challenge.protectionSpace.serverTrust else {
//            completionHandler(.cancelAuthenticationChallenge, nil)
//            return
//        }
//        
//        // Get the server's certificate chain
//        guard let certificateChain = SecTrustCopyCertificateChain(serverTrust) as? [SecCertificate],
//              let serverCertificate = certificateChain.first else {
//            completionHandler(.cancelAuthenticationChallenge, nil)
//            return
//        }
//        
//        // Convert server certificate to Data
//        let serverCertificateData = SecCertificateCopyData(serverCertificate) as Data
//        
//        // Load the pinned certificate from the app bundle
//        guard let certPath = Bundle.main.path(forResource: "omdbapi.com", ofType: "cer"),
//              let localCertData = try? Data(contentsOf: URL(fileURLWithPath: certPath)) else {
//            completionHandler(.cancelAuthenticationChallenge, nil)
//            return
//        }
//        
//        // Compare the certificates
//        if serverCertificateData == localCertData {
//            let credential = URLCredential(trust: serverTrust)
//            completionHandler(.useCredential, credential)
//        } else {
//            completionHandler(.cancelAuthenticationChallenge, nil)
//        }
//        
//    }
}
