//
//  ScanListingVMSpec.swift
//  ScanAppTests
//
//  Created by Niraj Kumar Jha on 28/09/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import Quick
import Nimble

@testable import ScanApp

class ScanListingVMSpec: QuickSpec {
    
    override func spec() {
        var mockUrlSession: MockURLSession!
        var listingVM: ScanListingViewModel!
        
        listingVM = ScanListingViewModel()
        
        describe("Scan Listing") {
            beforeEach {
                let urlSessionInfo = MockUrlInfo()
                urlSessionInfo.urlMockResponseDict["mp-android-challenge"] = "ScanSample"
                mockUrlSession = MockURLSession(mockUrlInfo: urlSessionInfo)
            }
            
            afterEach {
                mockUrlSession.stopMocking()
                mockUrlSession = nil
            }
            
            it("completes with response") {
                listingVM.fetchScanData()
                waitUntil(timeout: 4.0) { done in
                    expect(listingVM.scanModels).toNot((beNil()))
                    done()
                }
            }
            
            it("maps to correct properties") {
                expect(listingVM.numOfRows(in: 0)) == 10 // 5 scans + 5 separators
                let testRow: Int = 2
                let rowModel = listingVM.scanCellModel(at: testRow)
                expect(rowModel).toNot((beNil()))
                expect(rowModel?.rowType) == .scanInfo
                
                if let (criterias, name) = listingVM.scanCriteria(at: testRow) {
                    expect(name).to(equal("Intraday buying seen in last 15 minutes"))
                    expect(criterias?.count) == 3
                    expect(criterias?.first?.scanType) == .plainText
                }
            }
        }
    }
}
