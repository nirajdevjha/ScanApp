//
//  ScanResponseModel.swift
//  ScanApp
//
//  Created by Niraj Kumar Jha on 27/09/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import Foundation

typealias ScanResponseModel = [ScanResponse]

struct ScanResponse: Decodable {
    let id: Int?
    let name: String?
    let tag: String?
    let color: TagColorCategory
    let criteria: [ScanCriteria]?
}

enum TagColorCategory: String, Decodable {
    case green = "green"
    case red = "red"
    case white = "white"
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let decodedString = try container.decode(String.self)
        
        if let value = TagColorCategory(rawValue: decodedString) {
            self = value
        } else {
            self = .white
        }
    }
}


struct ScanCriteria: Decodable {
    let scanType: ScanCriteriaType
    let text: String?
    let variable: [String: ScanVariable]?
    
    enum CodingKeys: String, CodingKey {
        case scanType = "type"
        case text
        case variable
    }
}

class ScanVariable: Decodable {
    let variableType: ScanVariableType
    let values: [Float]?
    let studyType: String?
    let parameterName: String?
    let minValue: Int?
    let maxValue: Int?
    var defaultValue: Int?
    
    enum CodingKeys: String, CodingKey {
        case variableType = "type"
        case values
        case studyType = "study_type"
        case parameterName = "parameter_name"
        case minValue = "min_value"
        case maxValue = "max_value"
        case defaultValue = "default_value"
    }
}

enum ScanCriteriaType: String, Decodable {
    case plainText = "plain_text"
    case variable = "variable"
    case unknown = "unknown"
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let decodedString = try container.decode(String.self)
        
        if let value = ScanCriteriaType(rawValue: decodedString) {
            self = value
        } else {
            self = .unknown
        }
    }
}

enum ScanVariableType: String, Decodable {
    case value = "value"
    case indicator = "indicator"
    case unknown = "unknown"
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let decodedString = try container.decode(String.self)
        
        if let value = ScanVariableType(rawValue: decodedString) {
            self = value
        } else {
            self = .unknown
        }
    }
}
