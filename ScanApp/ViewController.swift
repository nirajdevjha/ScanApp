//
//  ViewController.swift
//  ScanApp
//
//  Created by Niraj Kumar Jha on 27/09/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var viewModel: ScanListingViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ScanListingViewModel()
        viewModel?.fetchScanData()
    }


}

