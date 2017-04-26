//
//  Supplier.swift
//  Elite Condos
//
//  Created by Khoa on 11/15/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import Foundation
import Firebase
class Supplier {
    var id : String?
    var name : String?
    var address : String?
    var logo : String?
    var phone: String?
    var email: String?
    var stars: String?
    //var serviceRef : FIRDatabaseReference!
    
    init(id : String, data : Dictionary<String, Any>) {
        self.id = id
        if let name = data["name"] as? String{
            self.name = name
        }
        if let address = data["address"] as? String{
            self.address = address
        }
        if let logo = data["logoUrl"] as? String{
            self.logo = logo
        }
        if let email = data["email"] as? String{
            self.email = email
        }
        if let phone = data["phone"] as? String{
            self.phone = phone
        }
        
        
        
    }
    
    
}
