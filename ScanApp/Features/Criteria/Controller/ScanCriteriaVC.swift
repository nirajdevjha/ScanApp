//
//  ScanCriteriaVC.swift
//  ScanApp
//
//  Created by Niraj Kumar Jha on 27/09/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import UIKit

class ScanCriteriaVC: UIViewController {
   
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 16, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ScanListingInfoTVC.self)
        return tableView
    }()
    
    private let viewModel: ScanCriteriaViewModel
    
    init(viewModel: ScanCriteriaViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title
        setupViews()
        viewModelCallbacks()
    }
    
    private func setupViews() {
        view.backgroundColor = .black
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func viewModelCallbacks() {
        viewModel.reloadTable = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

//MARK:- Table view delegate & datasource
extension ScanCriteriaVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let rowModel = viewModel.criteriaRowModel(at: indexPath.row) else {
            return UITableViewCell()
        }
        switch rowModel.rowType {
        case .criteria:
            let cell: ScanListingInfoTVC = tableView.dequeueReuseCell(forIndexPath: indexPath)
            cell.configure(from: rowModel)
            return cell
        }
    }
}

