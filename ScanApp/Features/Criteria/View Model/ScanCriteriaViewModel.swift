//
//  ScanCriteriaViewModel.swift
//  ScanApp
//
//  Created by Niraj Kumar Jha on 27/09/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import UIKit

class ScanCriteriaViewModel {
    
    let criterias: [ScanCriteria]
    let title: String
    private(set) lazy var criteriaCellModels = [ScanCriteriaCellModel]()
    
    var reloadTable: () -> () = {}
    
    init(_ criterias: [ScanCriteria], title: String) {
        self.criterias = criterias
        self.title = title
        prepareCellModels()
    }
    
    private func prepareCellModels() {
        criteriaCellModels.removeAll()
        criterias.forEach { criteria in
            if var text = criteria.text {
                if criteria.scanType == .plainText {
                    let criteriaModel = ScanCriteriaCellModel(rowType: .criteria, text: text, attributedText: nil)
                    criteriaCellModels.append(criteriaModel)
                } else if criteria.scanType == .variable {
                    if let variables = criteria.variable, variables.count > 0 {
                        var valueTextArray: [String] = []
                        var keyArray: [String] = []
                        for (idx, value) in variables.enumerated() {
                            if text.contains(value.key) {
                                keyArray.append(value.key)
                                let variableValue = value.value
                                
                                if variableValue.variableType == .indicator {
                                    if let defaultValue = variableValue.defaultValue {
                                        valueTextArray.append(String(format: "%d", defaultValue))
                                    }
                                }
                                else if variableValue.variableType == .value {
                                    if let values = variableValue.values, values.count > 0 {
                                        let valueAtIndex = values[0]
                                        valueTextArray.append(String(format: "%.01f", valueAtIndex))
                                    }
                                }
                                if valueTextArray.count > idx {
                                    text = text.replacingOccurrences(of: value.key, with: valueTextArray[idx])
                                }
                            }
                        }
                       
                        let criteriaModel = ScanCriteriaCellModel(rowType: .criteria, text: nil, attributedText: getValueAttributedText(text, valueTextArray: valueTextArray, keyArray: keyArray))
                        criteriaCellModels.append(criteriaModel)
                    }
                }
            }
        }
        reloadTable()
    }
    
    private func getValueAttributedText(_ text: String, valueTextArray: [String], keyArray: [String]) -> NSAttributedString {
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let attributedText = NSMutableAttributedString(string: text, attributes: attributes)
        for (idx, valueText) in valueTextArray.enumerated() {
            if let range = attributedText.string.range(of: valueText) {
                let range = NSRange(range, in: attributedText.string)
                let newAttributes: [NSAttributedString.Key : Any] = [ NSAttributedString.Key.foregroundColor: UIColor(red: 0/255, green: 140/255, blue: 255/255, alpha: 1.0), .link: keyArray[idx]]
                attributedText.setAttributes(newAttributes, range: range)
            }
        }
        return attributedText
    }
    
    func numOfRows(in section: Int) -> Int {
        return criteriaCellModels.count
    }
    
    func criteriaRowModel(at index: Int) -> ScanCriteriaCellModel? {
        guard index < criteriaCellModels.count else { return nil }
        return criteriaCellModels[index]
    }
    
    func getScanCriteriaVariable(at index: Int, key: String) -> ScanVariable? {
        guard index < criterias.count else { return nil }
        let criteria = criterias[index]
        if let variable = criteria.variable {
            return variable[key]
        }
        return nil
    }
}
