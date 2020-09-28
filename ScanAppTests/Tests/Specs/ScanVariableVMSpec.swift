//
//  ScanVariableVMSpec.swift
//  ScanAppTests
//
//  Created by Niraj Kumar Jha on 28/09/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import Foundation


import Quick
import Nimble

@testable import ScanApp

class ScanVariableVMSpec: QuickSpec {
    
    override func spec() {
        var variableVM: ScanVariableViewModel!
        
        let mockData = MockResourceUtility.data(named: "CriteriaSample")
        let model =  try? EncoderDecoder().decode(ScanResponseModel.self, from: mockData!)
        
        describe("Scan Variable parameter") {
            
            context("values") {
                beforeEach {
                    let variable = model?.first?.criteria?.first?.variable
                    let scanVariable = variable?["$1"]
                    if let scanVariable = scanVariable {
                        variableVM = ScanVariableViewModel(variable: scanVariable)
                    }
                }
                
                afterEach {
                    variableVM = nil
                }
                
                it("nav title") {
                    expect(variableVM.navigationTitle) == "Values List"
                }
                
                it("scan variable type") {
                    expect(variableVM.variable.variableType) == .value
                }
                
                it("table properties") {
                    let testIndexPath = IndexPath(row: 0, section: 0)
                    expect(variableVM.numOfRows(in: testIndexPath.row)) == 4
                    if let rowM = variableVM.variableRowModel(at: testIndexPath.row) {
                        expect(rowM.rowType) == .value
                    }
                }
            }
            
            context("indicator parameter") {
                
                beforeEach {
                    let variable = model?.first?.criteria?[2].variable
                    let scanVariable = variable?["$4"]
                    
                    if let scanVariable = scanVariable {
                        variableVM = ScanVariableViewModel(variable: scanVariable)
                    }
                }
                
                afterEach {
                  variableVM = nil
                }
                
                
                it("nav title") {
                    expect(variableVM.navigationTitle) == "Set Parameters"
                }
                
                it("scan variable type") {
                    expect(variableVM.variable.variableType) == .indicator
                }
                
                it("table properties") {
                    let testIndexPath = IndexPath(row: 0, section: 0)
                    expect(variableVM.numOfRows(in: testIndexPath.row)) == 1
                    if let rowM = variableVM.variableRowModel(at: testIndexPath.row) {
                        expect(rowM.rowType) == .indicator
                    }
                }
                
                it("update default value") {
                    // newValue between min and max
                    variableVM.updateParamValue(at: 0, newValue: 80)
                    expect(variableVM.variable.defaultValue).to(equal(80))
                    
                    // newValue not between min and max
                    variableVM.updateParamValue(at: 0, newValue: 999)
                    expect(variableVM.variable.defaultValue).notTo(equal(999))
                }
            }
       
        }
    }
}
