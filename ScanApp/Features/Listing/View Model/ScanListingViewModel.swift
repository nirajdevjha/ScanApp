//
//  ScanListingViewModel.swift
//  ScanApp
//
//  Created by Niraj Kumar Jha on 27/09/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import Foundation

enum ScanAPIError: Error {
    case failed(error: Error)
    case emptyResponse
    case failedWith(errorMessage: String, errorCode: String)
}


class ScanListingViewModel {
    
    private var scanModel: ScanResponseModel?

    
    
    private func getScanData(completion: @escaping(_ result: Result<ScanResponseModel, ScanAPIError>) -> Void) {
        guard let resource = ScanResource().buildScanResource() else {
            return
        }
        WebServiceManager().load(resource: resource) { response, error in
            DispatchQueue.main.async { [weak self] in
                guard self != nil else { return }
                
                if let error = error {
                    completion(.failure(.failed(error: error)))
                    return
                }
                
                guard let response = response  else {
                    completion(.failure(.emptyResponse))
                    return
                }
                completion(.success(response))
            }
        }
    }
}

extension ScanListingViewModel {
    
    func fetchScanData() {
        self.getScanData(completion: { (result: Result<ScanResponseModel, ScanAPIError>) in
            switch result {
            case .success(let responseModel):
                self.scanModel = responseModel
               
                
            case .failure(let error):
                debugPrint(error)
            }
        })
    }
}
