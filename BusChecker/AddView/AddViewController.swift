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
    var alertController:UIAlertController!

    
    
    @IBAction func CancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func SaveRoute(_ sender: UIBarButtonItem) {
        //TODO validation
        if(viewModel.stopcodeVm == nil || viewModel.bookmarknameVm == nil || viewModel.busnumberVm == nil) {
            errorAlert(errormessage: "Input fields can't be empty.")
            return
        }
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
        
   
        var rules = RuleSet<String>()
        rules.add(rule: RuleRequired())
        form
            +++ Section()    //2
            <<< TextRow() { // 3
                //error1 = NSMutableAttributedString(string: "Bus Number (Required)")
                
                $0.title = "Bus Number" //4
                $0.placeholder = "e.g. 25"
                $0.value = viewModel.busnumberVm //5
                $0.onChange { [unowned self] row in //6
                    self.viewModel.busnumberVm = row.value
                    }

                $0.add(ruleSet: rules)
                
      
            }.cellUpdate { cell, row in
                    if !row.isValid {
                        let error1 = NSMutableAttributedString(string: "Bus Number (Required)")
                        error1.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: NSRange(location:11,length:10))
                       //s cell.titleLabel?.textColor = .red
                        cell.titleLabel?.attributedText = error1
                    } else {
                        cell.titleLabel?.textColor = .black
                        cell.titleLabel?.text = "Bus Number"
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
                    $0.add(ruleSet: rules)
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        let error2 = NSMutableAttributedString(string: "Stop Code (Required)")
                         error2.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: NSRange(location:10,length:10))
                        //cell.titleLabel?.textColor = .red
                        cell.titleLabel?.attributedText = error2
                    } else {
                        cell.titleLabel?.textColor = .black
                        cell.titleLabel?.text = "Stop Code"
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
                    $0.add(ruleSet: rules)
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        let error3 = NSMutableAttributedString(string: "Name (Required)")
                        error3.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: NSRange(location:5,length:10))
                        cell.titleLabel?.attributedText = error3
                    } else {
                        cell.titleLabel?.textColor = .black
                        cell.titleLabel?.text = "Name"
                    }
                }
        
                
                
                // Do any additional setup after loading the view.
        }
    
    
    func errorAlert(errormessage : String) {
        
        alertController = UIAlertController(title: "Error", message: errormessage, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
        
}
