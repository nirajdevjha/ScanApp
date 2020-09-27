//
//  ScanCriteriaCellModel.swift
//  ScanApp
//
//  Created by Niraj Kumar Jha on 27/09/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import Foundation

protocol ScanCriteriaRowModel {
    var rowType: ScanCriteriaRowType { get }
}

enum ScanCriteriaRowType {
    case criteria
}

struct ScanCriteriaCellModel: ScanCriteriaRowModel {
    var rowType: ScanCriteriaRowType
    let text: String
}

