//
//  Reachability.swift
//  BusChecker
//
//  Created by kenth on 2017-11-08.
//  Copyright © 2017 kenth. All rights reserved.
//

import Foundation
import SystemConfiguration

public class Reachability {
    
    

    class func isNetworkReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutUserInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
        
        return isReachable && (!needsConnection || canConnectWithoutUserInteraction)
    }
    
    class func isConnectedToNetwork() -> Bool {
        
        // Optional binding since `SCNetworkReachabilityCreateWithName` return an optional object
        guard let reachability = SCNetworkReachabilityCreateWithName(nil, "www.google.com") else { return false}
        
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(reachability, &flags)
        
        if !isNetworkReachable(with: flags) {
            // Device doesn't have internet connection
            return false
        }
        
        #if os(iOS)
            // It's available just for iOS because it's checking if the device is using mobile data
            if flags.contains(.isWWAN) {
                // Device is using mobile data
                print("mobiledata")
                return true
            }
        #endif
        
        print("wifi")
        return true
        // At this point we are sure that the device is using Wifi since it's online and without using mobile data
        
    }
}
