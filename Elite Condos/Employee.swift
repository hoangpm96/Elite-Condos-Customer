//
//  Employee.swift
//  Elite Condos
//
//  Created by Khoa on 11/18/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import Foundation


class Employee{
    
    
    private var _id : String!
    private var _name : String!
    private var _phone : String!
    private var _avatarUrl : String!
    
    var id : String{
        return _id
    }
    var name : String{
        return _name
    }
    var phone : String{
        return  _phone
    }
    var avatarUrl : String{
        return _avatarUrl
    }
    
    
    init(id : String, data : Dictionary<String, Any>) {
        self._id = id
        if let name = data["name"] as? String{
            self._name = name
        }
        if let phone = data["phone"] as? String{
            self._phone = phone
        }
        if let avatarUrl = data["avatarUrl"] as? String{
            self._avatarUrl = avatarUrl
        }
        
    }
    
    
    
    
    
}
