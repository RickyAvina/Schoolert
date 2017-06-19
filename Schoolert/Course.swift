//
//  Course.swift
//  Schoolert
//
//  Created by Ricky Avina on 6/17/17.
//  Copyright © 2017 InternTeam. All rights reserved.
//

import Foundation

class Course {
    
    var periodId: Int?
    var groupId: Int?
    var name: String?
    
    init() {
        
    }
    
    func isValid() -> Bool {
        if (name?.range(of: "PE ") != nil || name?.range(of: "Engineering Robotics") != nil || name?.range(of: "Unsched") != nil) { // course exists
            return false
        }
        return true
    }
}
