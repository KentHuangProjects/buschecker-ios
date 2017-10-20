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
    
    class func CreateBusStopMO(stopCode : Int64,bookmarkName: String,busNumber: String, creation: Date, in context: NSManagedObjectContext) -> BusStopMO
    {
    
        let busstop = BusStopMO(context: context)
        busstop.stopCode = stopCode
        busstop.bookmarkName = bookmarkName
        busstop.busNumber = busNumber
        busstop.creationDate = creation
        return busstop
    }
}
