//
//  ScanVariableViewModel.swift
//  ScanApp
//
//  Created by Niraj Kumar Jha on 28/09/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import Foundation

class ScanVariableViewModel {
    let variable: ScanVariable
    private(set) var variableCellModels = [ScanVariableRowModel]()
    
    var reloadTable: () -> () = {}
    
    init(variable: ScanVariable) {
        self.variable = variable
        prepareCellModels()
    }
    
    private func prepareCellModels() {
        if variable.variableType == .value {
            if let values = variable.values {
                values.forEach { value in
                    let valueModel = ScanVariableValueCellModel(rowType: .value, value: String(format: "%.01f", value))
                    variableCellModels.append(valueModel)
                }
            }
        } else if variable.variableType == .indicator {
            
        }
        reloadTable()
    }
}

extension ScanVariableViewModel {
    
    func numOfRows(in section: Int) -> Int {
        return variableCellModels.count
    }
    
    func variableRowModel(at index: Int) -> ScanVariableRowModel? {
        guard index < variableCellModels.count else { return nil }
        return variableCellModels[index]
    }
    
}
