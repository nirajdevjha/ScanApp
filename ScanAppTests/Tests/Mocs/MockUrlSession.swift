//
//  MockUrlSession.swift
//  ScanAppTests
//
//  Created by Niraj Kumar Jha on 28/09/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import Foundation

@testable import ScanApp

typealias MockDataTaskResult = (Data?, URLResponse?, Error?) -> Void

class MockUrlInfo {
    var urlMockResponseDict: [String: String] = [:]
}

class MockDataTask: URLSessionDataTask {
    var mockData: Data?
    var mockURLResponse: URLResponse?
    var completionHandler: MockDataTaskResult?
    var mockError: Error?
    
    override func resume() {
        completionHandler?(mockData, mockURLResponse, mockError)
    }
    
    override func cancel() {
        completionHandler?(nil, nil, nil)
    }
}


class MockURLSession: URLSessionProtocol {
    private let mockUrlInfo: MockUrlInfo?
    private let urlSession: URLSession = URLSession(configuration: configuration)
    private let currentSession: URLSessionProtocol
    
    init(mockUrlInfo: MockUrlInfo) {
        self.mockUrlInfo = mockUrlInfo
        currentSession = defaultSession
        defaultSession = self
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        if let url = request.url, let mockUrlInfo = self.mockUrlInfo {
            let urlString = url.absoluteString
            for (mockUrlString, path) in mockUrlInfo.urlMockResponseDict {
                
                if urlString.contains(mockUrlString),
                    let mockData = MockResourceUtility.data(named: path) {
                    let mockResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: [:])
                    let mockDataTask = MockDataTask()
                    mockDataTask.mockData = mockData
                    mockDataTask.mockURLResponse = mockResponse
                    mockDataTask.completionHandler = completionHandler
                    return mockDataTask
                }
            }
        }
        return urlSession.dataTask(with: request, completionHandler: completionHandler)
    }
    
    func stopMocking() {
        defaultSession = currentSession
    }
}


