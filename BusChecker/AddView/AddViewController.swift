//
//  AddViewController.swift
//  BusChecker
//
//  Created by Yu Hong Huang on 2017-10-20.
//  Copyright © 2017 kenth. All rights reserved.
//

import UIKit
import Eureka
import CoreData

class AddViewController: FormViewController {
    
    var viewModel  = BusStopViewModel()
    var context : NSManagedObjectContext! = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    
    @IBAction func CancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func SaveRoute(_ sender: UIBarButtonItem) {
        //TODO validation
        _ = BusStopMO.CreateBusStopMO(stopCode: viewModel.stopcodeVm!, bookmarkName: viewModel.bookmarknameVm!, busNumber: viewModel.busnumberVm!, creation: Date(), in: context)
        do {
            try context.save()
        } catch {
            print(error)
        }
        dismiss(animated: true, completion: nil)
    }
    
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
                    self.viewModel.stopcodeVm = row.value
                }
            }
            +++ Section()
            <<< TextRow() { // 3
                $0.title = "Name" //4
                $0.placeholder = "Name your route"
                $0.value = viewModel.bookmarknameVm //5
                $0.onChange { [unowned self] row in //6
                    self.viewModel.bookmarknameVm = row.value
                }
        }
        
                
                
                // Do any additional setup after loading the view.
        }
        
}
