//
//  ScanListingCellModels.swift
//  ScanApp
//
//  Created by Niraj Kumar Jha on 27/09/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import Foundation

protocol ScanListingRowModel {
    var rowType: ScanListingRowType { get }
}

enum ScanListingRowType {
    case scanInfo
    case separator
}

struct ScanListingInfoCellModel: ScanListingRowModel {
    var rowType: ScanListingRowType
    let scanId: Int
    let scanName: String
    let scanTag: String
    let tagColor: TagColorCategory
}

struct ScanSeparatorCellModel: ScanListingRowModel {
   var rowType: ScanListingRowType
}

