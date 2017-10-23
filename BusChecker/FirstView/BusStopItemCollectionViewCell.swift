//
//  BusStopItemCollectionViewCell.swift
//  BusChecker
//
//  Created by kenth on 2017-10-20.
//  Copyright © 2017 kenth. All rights reserved.
//

import UIKit

class BusStopItemCollectionViewCell: UITableViewCell {
    
    
    @IBOutlet weak var bookmarkName: UILabel!
    
    var bsVM: BusStopViewModel!
    
    //delete method
    @objc func deleteRoute(_ sender:AnyObject?){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        print("BusStopItemCollectionViewCell,Delete")
        BusStopMO.DeleteBusStopMO(bsVm: bsVM,context: context)
        do {
            try context.save()
        } catch {
            print(error)
            fatalError("fail to delete.")
        }
    }
}
