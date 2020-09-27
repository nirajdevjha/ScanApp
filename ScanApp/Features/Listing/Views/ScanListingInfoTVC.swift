//
//  ScanListingInfoTVC.swift
//  ScanApp
//
//  Created by Niraj Kumar Jha on 27/09/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import UIKit


final class ScanListingInfoTVC: UITableViewCell {

    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var scanNameLbl: UILabel!
    @IBOutlet private weak var scanTagLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}

extension ScanListingInfoTVC {
    func configure(from model: ScanListingInfoCellModel) {
        scanNameLbl.text = model.scanName
        scanTagLbl.text = model.scanTag
        var tagColor: UIColor
        switch model.tagColor {
        case .green:
            tagColor = .green
        case .red:
            tagColor = .red
        case .white:
            tagColor = .white
        }
        scanTagLbl.textColor = tagColor
    }
    
    func configure(_ model: ScanVariableValueCellModel) {
        scanNameLbl.text = model.value
        scanTagLbl.isHidden = true
    }
}


