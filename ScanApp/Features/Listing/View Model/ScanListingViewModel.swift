//
//  ScanListingViewModel.swift
//  ScanApp
//
//  Created by Niraj Kumar Jha on 27/09/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import UIKit

enum ScanAPIError: Error {
    case failed(error: Error)
    case emptyResponse
    case failedWith(errorMessage: String, errorCode: String)
}

class ScanListingViewModel {
    
    private var scanModels: ScanResponseModel?
    private(set) var dataSource = [ScanListingRowModel]()
    
    /// VM Output Callbacks
    var reloadTable: () -> () = {}
    var showActivityIndicator: () -> () = {}
    var showErrorMessage: (String) -> () = { _ in }

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
    
    private func prepareCellModels() {
        dataSource.removeAll()
        guard let scanModels = scanModels, scanModels.count > 0 else {
            return
        }
        for scanModel in scanModels {
            if let name = scanModel.name, let tag = scanModel.tag {
                let scanInfoModel = ScanListingInfoCellModel(rowType: .scanInfo, scanName: name, scanTag: tag, tagColor: scanModel.color)
                dataSource.append(scanInfoModel)
                
                let separatorModel = ScanSeparatorCellModel(rowType: .separator)
                dataSource.append(separatorModel)
            }
        }
    }
}

extension ScanListingViewModel {
    
    func fetchScanData() {
        self.showActivityIndicator()
        self.getScanData(completion: { (result: Result<ScanResponseModel, ScanAPIError>) in
            switch result {
            case .success(let responseModel):
                self.scanModels = responseModel
                self.prepareCellModels()
                self.reloadTable()
    
            case .failure(let error):
                debugPrint(error)
            }
        })
    }
    
    func numOfRows(in section: Int) -> Int {
        return dataSource.count
    }
    
    func scanCellModel(at index: Int) -> ScanListingRowModel? {
        guard index < dataSource.count else { return nil }
        return dataSource[index]
    }
}
