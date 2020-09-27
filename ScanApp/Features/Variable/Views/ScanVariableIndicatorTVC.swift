//
//  ScanVariableIndicatorTVC.swift
//  ScanApp
//
//  Created by Niraj Kumar Jha on 28/09/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import UIKit

protocol ScanVariableIndicatorCellProtocol: class {
    func updateParamValue(newDefaultValue: Int, cell: ScanVariableIndicatorTVC)
}

class ScanVariableIndicatorTVC: UITableViewCell {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var paramNameLbl: UILabel!
    @IBOutlet private weak var paramValueTextField: UITextField!
    
    weak var delegate: ScanVariableIndicatorCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 5
        containerView.clipsToBounds = true
        paramValueTextField.inputAccessoryView = accesoryBar()
        paramValueTextField.keyboardType = .numberPad
        paramValueTextField.delegate = self
    }
    
    private func accesoryBar() -> UIToolbar {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        toolbar.tintColor = UIColor.blue
        var barItems = [UIBarButtonItem]()
        barItems.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBarItemTapped))
        barItems.append(done)
        toolbar.setItems(barItems, animated: false)
        return toolbar
    }
    
    @objc
    private func doneBarItemTapped() {
        contentView.endEditing(true)
    }
    
}

extension ScanVariableIndicatorTVC {
    func configure(_ model: ScanVariableIndicatorCellModel, delegate: ScanVariableIndicatorCellProtocol?) {
        self.delegate = delegate
        paramNameLbl.text = model.paramName
        paramValueTextField.text = "\(model.defaultValue)"
    }
}

extension ScanVariableIndicatorTVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, let range = NumberFormatter().number(from: text) else { return }
        let newValue = Int(truncating: range)
        delegate?.updateParamValue(newDefaultValue: newValue, cell: self)
    }
    
}
