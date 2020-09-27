//
//  ScanSeparatorCell.swift
//  ScanApp
//
//  Created by Niraj Kumar Jha on 27/09/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import UIKit

final class ScanSeparatorCell: UITableViewCell {
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
       
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        separatorView.addDashedLine(strokeColor: .white, lineWidth: 1.5, lineDashPattern: [2, 2])
    }
    
    func setupViews() {
        selectionStyle = .none
        contentView.backgroundColor = .black
        
        contentView.addSubview(separatorView)
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2)
        ])
        separatorView.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
    }
}
