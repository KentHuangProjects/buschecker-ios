//
//  BusStopMO.swift
//  BusChecker
//
//  Created by kenth on 2017-10-19.
//  Copyright © 2017 kenth. All rights reserved.
//

import Foundation
import CoreData

class BusStopMO : NSManagedObject {
    
    class func CreateBusStopMO(stopCode : String,bookmarkName: String,busNumber: String, creation: Date, in context: NSManagedObjectContext) -> BusStopMO
    {
    
        let busstop = BusStopMO(context: context)
        busstop.stopCode = stopCode
        busstop.bookmarkName = bookmarkName
        busstop.busNumber = busNumber
        busstop.creationDate = creation
        return busstop
    }
    
    class func DeleteBusStopMO(bsVm: BusStopViewModel,context: NSManagedObjectContext) {
        let busnum = bsVm.busnumberVm
        let stopcode = bsVm.stopcodeVm!
        
        let fetchRequest: NSFetchRequest<BusStopMO> = BusStopMO.fetchRequest()
        fetchRequest.predicate = NSPredicate.init(format: "busNumber = %@ AND stopCode = %@", argumentArray: [busnum!,stopcode])
        let object = try! context.fetch(fetchRequest)
        context.delete(object[0])
        do {
            try context.save()
        } catch {
            print(error)
            fatalError("fail to delete.")
        }
    }
    
    //update date
    class func UpdateDateBusStopMO(bsVm: BusStopViewModel,context: NSManagedObjectContext) {
        let busnum = bsVm.busnumberVm
        let stopcode = bsVm.stopcodeVm!
        
        let fetchRequest: NSFetchRequest<BusStopMO> = BusStopMO.fetchRequest()
        fetchRequest.predicate = NSPredicate.init(format: "busNumber = %@ AND stopCode = %@", argumentArray: [busnum!,stopcode])
        let object = try! context.fetch(fetchRequest)[0]
        object.setValue(Date(), forKey: "creationDate")
        
        do {
            try context.save()
        } catch {
            print(error)
            fatalError("fail to update.")
        }
        
    }
}
