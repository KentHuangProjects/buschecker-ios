//
//  AddViewController.swift
//  BusChecker
//
//  Created by Yu Hong Huang on 2017-10-20.
//  Copyright © 2017 kenth. All rights reserved.
//

import UIKit
import Eureka

class AddViewController: FormViewController {
    
    var viewModel  = BusStopViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form
            +++ Section()    //2
            <<< TextRow() { // 3
                $0.title = "Bus Number" //4
                $0.placeholder = "e.g. 25"
                $0.value = viewModel.busnumberVm //5
                $0.onChange { [unowned self] row in //6
                    self.viewModel.busnumberVm = row.value
                    }
                
                        
                }
            +++ Section()
            <<< TextRow() { // 3
                $0.title = "Stop Code" //4
                $0.placeholder = "e.g. 51536"
                $0.value = viewModel.stopcodeVm //5
                $0.onChange { [unowned self] row in //6
                    self.viewModel.busnumberVm = row.value
                }
                
                
        }
        
                
                
                // Do any additional setup after loading the view.
        }
        
}
