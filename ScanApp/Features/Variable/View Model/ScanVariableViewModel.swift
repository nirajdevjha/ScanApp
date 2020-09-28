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
    var showErrorMessage: (String) -> () = { _ in }
    
    init(variable: ScanVariable) {
        self.variable = variable
        prepareCellModels()
    }
    
    var navigationTitle: String {
        if variable.variableType == .indicator {
            return "Set Parameters"
        } else {
            return "Values List"
        }
    }
    
    private func prepareCellModels() {
        variableCellModels.removeAll()
        if variable.variableType == .value {
            if let values = variable.values {
                values.forEach { value in
                    let valueModel = ScanVariableValueCellModel(rowType: .value, value: String(format: "%.01f", value))
                    variableCellModels.append(valueModel)
                }
            }
        } else if variable.variableType == .indicator {
            if let paramName = variable.parameterName, let defaultValue = variable.defaultValue, let max = variable.maxValue, let min = variable.minValue {
                let indicatorModel = ScanVariableIndicatorCellModel(rowType: .indicator, paramName: paramName, defaultValue: defaultValue, minValue: min, maxValue: max)
                variableCellModels.append(indicatorModel)
            }
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
    
    func updateParamValue(at index: Int, newValue: Int) {
        if variable.variableType == .indicator {
            /// validating the newValue to be within maxValue and minValue
            if let max = variable.maxValue, let min = variable.minValue {
                if newValue <= max && newValue >= min {
                    variable.defaultValue = newValue
                } else {
                    showErrorMessage("\(newValue) is not between allowed range of min \(min) & max \(max)")
                }
            }
        }
        prepareCellModels()
    }
}
