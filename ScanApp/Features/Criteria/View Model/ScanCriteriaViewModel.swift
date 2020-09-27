//
//  ScanCriteriaViewModel.swift
//  ScanApp
//
//  Created by Niraj Kumar Jha on 27/09/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import Foundation

class ScanCriteriaViewModel {
    
    let criterias: [ScanCriteria]
    let title: String
    private(set) lazy var criteriaCellModels = [ScanCriteriaCellModel]()
    
    /// VM Output Callbacks
    var reloadTable: () -> () = {}
    
    init(_ criterias: [ScanCriteria], title: String) {
        self.criterias = criterias
        self.title = title
        prepareCellModels()
    }
    
    private func prepareCellModels() {
        criterias.forEach { criteria in
            if let text = criteria.text {
                let criteriaModel = ScanCriteriaCellModel(rowType: .criteria, text: text)
                criteriaCellModels.append(criteriaModel)
                reloadTable()
            }
        }
    }
    
    func numOfRows(in section: Int) -> Int {
        return criteriaCellModels.count
    }
    
    func criteriaRowModel(at index: Int) -> ScanCriteriaCellModel? {
        guard index < criteriaCellModels.count else { return nil }
        return criteriaCellModels[index]
    }
}
