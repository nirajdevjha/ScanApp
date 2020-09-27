//
//  ViewController.swift
//  ScanApp
//
//  Created by Niraj Kumar Jha on 27/09/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import UIKit

class ScanListingVC: UIViewController {
    
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
        tableView.register(ScanSeparatorCell.self, forCellReuseIdentifier: ScanSeparatorCell.identifier)
        return tableView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.style = .large
        activityIndicator.color = .white
        return activityIndicator
    }()
    
    private let viewModel: ScanListingViewModel
    
    //MARK:- Life cycle
    init(viewModel: ScanListingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Scan List"
        setupViews()
        viewModelCallbacks()
        viewModel.fetchScanData()
    }
    
    //MARK:- Private
    private func setupViews() {
        view.backgroundColor = .black
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    private func showActivityIndicator() {
        activityIndicator.startAnimating()
    }
    
    private func hideActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
    private func viewModelCallbacks() {
        viewModel.reloadTable = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.hideActivityIndicator()
                self.tableView.reloadData()
            }
        }
        viewModel.showErrorMessage = { [weak self] message in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.hideActivityIndicator()
                UIAlertController.showErrorAlert(
                    from: self,
                    title: "Error", msg: message)
            }
        }
        viewModel.showActivityIndicator = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.showActivityIndicator()
            }
        }
    }
}

//MARK:- Table view delegate & datasource
extension ScanListingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let rowModel = viewModel.scanCellModel(at: indexPath.row) else {
            return UITableViewCell()
        }
        
        switch rowModel.rowType {
        case .scanInfo:
            if let rowModel = rowModel as? ScanListingInfoCellModel {
                let cell: ScanListingInfoTVC = tableView.dequeueReuseCell(forIndexPath: indexPath)
                cell.configure(from: rowModel)
                return cell
            }
        case .separator:
            if let _ = rowModel as? ScanSeparatorCellModel {
                let cell: ScanSeparatorCell = tableView.dequeueReuseCell(forIndexPath: indexPath)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let (criterias, name) = viewModel.scanCriteria(at: indexPath.row),
            let crtiteriaList = criterias,
            let title = name else {
                return
        }
        let vm = ScanCriteriaViewModel(crtiteriaList, title: title)
        let criteriaVC = ScanCriteriaVC(viewModel: vm)
        navigationController?.pushViewController(criteriaVC, animated: true)
    }
}
