//
//  MockURLProtocol.swift
//  AdminTests
//
//  Created by Mohamed Mahgoub on 18/09/2024.
//

import Foundation

class MockURLProtocol: URLProtocol {
    
    static var responseData: Data?
    static var statusCode: Int = 200
    static var error: Error?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let error = MockURLProtocol.error {
            self.client?.urlProtocol(self, didFailWithError: error)
        } else {
            let response = HTTPURLResponse(url: request.url!, statusCode: MockURLProtocol.statusCode, httpVersion: nil, headerFields: nil)!
            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            
            if let data = MockURLProtocol.responseData {
                self.client?.urlProtocol(self, didLoad: data)
            }
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {
    }
}
