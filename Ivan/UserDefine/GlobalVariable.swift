//
//  GlobalVariable.swift
//  Ivan
//
//  Created by Olga Pirogova on 22.01.2020.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import UIKit
class ModelData: NSObject {
    static let shared: ModelData = ModelData()
    var userName = ""
    var phoneNumber = ""
    var orderNo = 0
    var ready = false
    var state = ""
    var uid = ""
    var allow = ""
}
