//
//  ScanCriteriaVMSPec.swift
//  ScanAppTests
//
//  Created by Niraj Kumar Jha on 28/09/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import ScanApp

class ScanCriteriaVMSPec: QuickSpec {
    
    override func spec() {
        var criteriaVM: ScanCriteriaViewModel!
        
        let mockData = MockResourceUtility.data(named: "CriteriaSample")
        let model =  try? EncoderDecoder().decode(ScanResponseModel.self, from: mockData!)
        let criteras = model?.first?.criteria
        let name = model?.first?.name
        
        describe("Scan Criteria") {
            
            beforeEach {
                if let criteras = criteras, let name = name {
                    criteriaVM = ScanCriteriaViewModel(criteras, title: name)
                }
            }
            
            afterEach {
                criteriaVM = nil
            }
            
            it("There is a title") {
                expect(criteriaVM.title) == "RSI Overbought"
            }
            
            it("maps to correct properties") {
                criteriaVM.reloadData()
                let testIndexPath = IndexPath(row: 1, section: 0)
                expect(criteriaVM.numOfRows(in: testIndexPath.row)) == 3
                if let rowM = criteriaVM.criteriaRowModel(at: testIndexPath.row) {
                    expect(rowM.rowType) == .criteria
                    expect(rowM.attributedText?.string) == "Today's Volume > prev 10.0 Vol SMA by 1.5 x"
                }
            }
            
            it("scan variable for index") {
                let variable = criteriaVM.getScanCriteriaVariable(at: 0, key: "$1")
                expect(variable?.variableType) == .value
                expect(variable?.values?.count) == 4
            }
            
            it("variable indicator") {
                let variable = criteriaVM.getScanCriteriaVariable(at: 2, key: "$4")
                expect(variable?.variableType) == .indicator
                expect(variable?.parameterName).to(equal("period"))
                expect(variable?.defaultValue).to(equal(14))
            }
            
            it("default value to be in b/w min and max") {
                let variable = criteriaVM.getScanCriteriaVariable(at: 2, key: "$4")
                if let defaultV = variable?.defaultValue, let minV = variable?.minValue, let maxV = variable?.maxValue {
                    expect(defaultV >= minV).to(beTrue())
                    expect(defaultV <= maxV).to(beTrue())
                }
               
            }
        }
    }
}
