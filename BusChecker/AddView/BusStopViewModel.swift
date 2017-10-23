//
//  BusStopViewModel.swift
//  BusChecker
//
//  Created by Yu Hong Huang on 2017-10-20.
//  Copyright © 2017 kenth. All rights reserved.
//

import Foundation

class BusStopViewModel {
    var busnumberVm : String?
    var stopcodeVm : String?
    var bookmarknameVm : String?
    
    convenience init(_ busnumberVm: String, _ stopcodeVm: String, _ bookmarknameVm: String) {
        self.init()
        self.busnumberVm = busnumberVm
        self.stopcodeVm = stopcodeVm
        self.bookmarknameVm = bookmarknameVm
    }
}
