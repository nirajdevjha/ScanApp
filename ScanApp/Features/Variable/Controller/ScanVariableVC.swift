//
//  ScanVariableVC.swift
//  ScanApp
//
//  Created by Niraj Kumar Jha on 28/09/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import UIKit

protocol ScanVariableVCProtocol: class {
    func updateCriterias()
}

class ScanVariableVC: UIViewController {
   
    @IBOutlet private weak var tableView: UITableView!
    
    private var viewModel: ScanVariableViewModel!
    private weak var delegate: ScanVariableVCProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let doneBarButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
        navigationItem.rightBarButtonItem = doneBarButton
        let closeBarButton = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(closeTapped))
        navigationItem.leftBarButtonItem = closeBarButton
        title = "Customize"
        tableView.contentInset.top = 10
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ScanListingInfoTVC.self)
        tableView.register(ScanVariableIndicatorTVC.self)
        viewModelCallbacks()
    }
    
    private func viewModelCallbacks() {
        viewModel.reloadTable = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.showErrorMessage = { [weak self] message in
            guard let self = self else { return }
            DispatchQueue.main.async {
                UIAlertController.showErrorAlert(
                    from: self,
                    title: "Error", msg: message)
            }
        }
    }
    
    @objc
    private func closeTapped() {
        dismiss(animated: true)
        delegate?.updateCriterias()
    }
    
    @objc
    private func doneTapped() {
        dismiss(animated: true)
        delegate?.updateCriterias()
    }
    
    class func controller(viewModel: ScanVariableViewModel, delegate: ScanVariableVCProtocol?) -> ScanVariableVC {
        let vc = ScanVariableVC(nibName: String(describing: self), bundle: Bundle.main)
        vc.viewModel = viewModel
        vc.delegate = delegate
        return vc
    }
}

//MARK:- Table view delegate & datasource
extension ScanVariableVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let rowModel = viewModel.variableRowModel(at: indexPath.row) else {
            return UITableViewCell()
        }
        switch rowModel.rowType {
        case .value:
            if let rowModel = rowModel as? ScanVariableValueCellModel {
                let cell: ScanListingInfoTVC = tableView.dequeueReuseCell(forIndexPath: indexPath)
                cell.configure(rowModel)
                return cell
            }
            
        case .indicator:
            if let rowModel = rowModel as? ScanVariableIndicatorCellModel {
                let cell: ScanVariableIndicatorTVC = tableView.dequeueReuseCell(forIndexPath: indexPath)
                cell.configure(rowModel, delegate: self)
                return cell
            }
        }
        return UITableViewCell()
    }
}

extension ScanVariableVC: ScanVariableIndicatorCellProtocol {
    func updateParamValue(newDefaultValue: Int, cell: ScanVariableIndicatorTVC) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        viewModel.updateParamValue(at: indexPath.row, newValue: newDefaultValue)
    }
    
}
