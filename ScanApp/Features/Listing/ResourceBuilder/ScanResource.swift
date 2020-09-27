//
//  ScanResource.swift
//  ScanApp
//
//  Created by Niraj Kumar Jha on 27/09/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import Foundation

class ScanResource {
    func buildScanResource() -> Resource<ScanResponseModel>? {
        let scanURL: String = "https://mp-android-challenge.herokuapp.com/data"
        guard let url = URL(string: scanURL) else { return nil }
        
        let resource = Resource<ScanResponseModel>(url: url, parseJSON: { json in
            do {
                guard let jsonData = json as? [Any] else { return nil }
                let model = try EncoderDecoder().decode(ScanResponseModel.self, from: jsonData)
                return model
            } catch let error {
                debugPrint("Parsing Error: \(error)")
                return nil
            }
        }, method: .get)
        return resource
    }
}
