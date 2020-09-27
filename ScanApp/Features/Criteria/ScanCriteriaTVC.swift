//
//  ScanCriteriaTVC.swift
//  ScanApp
//
//  Created by Niraj Kumar Jha on 27/09/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import UIKit

protocol ScanCriteriaCellProtocol: class {
    func didTapCriteria(key: String, cell: ScanCriteriaTVC)
}

final class ScanCriteriaTVC: UITableViewCell {

    @IBOutlet private weak var criteriaTextView: UITextView!
    
    weak var delegate: ScanCriteriaCellProtocol?
   
    override func awakeFromNib() {
        super.awakeFromNib()
        criteriaTextView.isScrollEnabled = false
        criteriaTextView.isEditable = false
        criteriaTextView.textContainerInset.top = 2.0
        criteriaTextView.delegate = self
    }
    
    func configure(from model: ScanCriteriaCellModel, delegate: ScanCriteriaCellProtocol?) {
        self.delegate = delegate
        if let attibutedText = model.attributedText {
            criteriaTextView.attributedText = attibutedText
        } else if let text = model.text {
            criteriaTextView.text = text
        }
    }
}

extension ScanCriteriaTVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
         delegate?.didTapCriteria(key: URL.absoluteString, cell: self)
        return false
    }
}
