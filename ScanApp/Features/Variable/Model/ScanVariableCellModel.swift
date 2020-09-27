//
//  ScanVariableCellModel.swift
//  ScanApp
//
//  Created by Niraj Kumar Jha on 28/09/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import Foundation

protocol ScanVariableRowModel {
    var rowType: ScanVariableRowType { get }
}

enum ScanVariableRowType {
    case indicator
    case value
}

struct ScanVariableValueCellModel: ScanVariableRowModel {
    var rowType: ScanVariableRowType
    let value: String
}


struct ScanVariableIndicatorCellModel: ScanVariableRowModel {
    var rowType: ScanVariableRowType
    let paramName: String
    let defaultValue: Int
    let minValue: Int
    let maxValue: Int
}
