//
//  Service.swift
//  SSL-Pinning
//
//  Created by Harish Kshirsagar on 08/03/25.
//
import Foundation
import Security

class SSLPinningService: NSObject, URLSessionDelegate {
    
    static let sharedInstance = SSLPinningService()
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        // Ensure we have server trust
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        // Get the server's certificate chain
        guard let certificateChain = SecTrustCopyCertificateChain(serverTrust) as? [SecCertificate],
              let serverCertificate = certificateChain.first else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        // Convert server certificate to Data
        let serverCertificateData = SecCertificateCopyData(serverCertificate) as Data
        
        // Load the pinned certificate from the app bundle
        guard let certPath = Bundle.main.path(forResource: "certificate", ofType: "cer"),
              let localCertData = try? Data(contentsOf: URL(fileURLWithPath: certPath)) else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        // Compare the certificates
        if serverCertificateData == localCertData {
            let credential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, credential)
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
        
    }
    
}
