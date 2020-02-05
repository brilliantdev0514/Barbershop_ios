//
//  Item.swift
//  Ivan
//
//  Created by Olga Pirogova on 22.01.2020.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import Foundation
import UIKit

class Item {
    
    var userName: String!
    var requestTime: String!
    var state: String!
    var orderNumber: Double!
    var phoneNumber: String!
    var uid: String!
    var ready: Bool!
        
    init(username: String, request: String, states: String, order: Double, phone: String, uid: String, ready: Bool) {
        
        self.userName = username
        self.requestTime = request
        self.state = states
        self.orderNumber = order
        self.phoneNumber = phone
        self.uid = uid
        self.ready = ready
    }
        
}

