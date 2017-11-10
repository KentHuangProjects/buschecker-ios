//
//  MessageMO.swift
//  BusChecker
//
//  Created by kenth on 2017-10-19.
//  Copyright © 2017 kenth. All rights reserved.
//

import Foundation
import CoreData


class MessageMO : NSManagedObject {
    
    class func CreateMessageMO(m1 : String,m2 : String, m3 : String, messageType: String,title1: String,title2: String, creation: Date,busstop:BusStopMO, in context: NSManagedObjectContext) -> MessageMO
    {
        
        let message = MessageMO(context: context)
        message.m1 = m1
        message.m2 = m2
        message.m3 = m3
        message.messageType = messageType
        message.title1 = title1
        message.title2 = title2
        message.creationDate = creation
        
        message.busStop = busstop
        return message
    }
    
}
