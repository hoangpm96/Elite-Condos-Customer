//
//  Order.swift
//  Elite Condos
//
//  Created by Khoa on 11/26/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import Foundation

class Order  {
    
    var id : String?
    var customerId : String?
    var serviceName : String?
    var supplierId : String?
    var employeeId : String?
    var status : ORDER_STATUS?
    
    
    //    var id : String{
    //        return _id
    //    }
    //    var customerId :String{
    //        return _customerId
    //    }
    //    var serviceName : String{
    //        return _serviceName
    //    }
    //    var employeeId : String{
    //        return _employeeId
    //    }
    //    var supplierId : String{
    //        return _supplierId
    //    }
    //
    //    var status : ORDER_STATUS{
    //        return _status
    //    }
    
    init(id : String, data : Dictionary<String,Any>) {
        self.id = id
        if let customerId = data["customerId"] as? String{
            self.customerId = customerId
        }
        if let name = data["name"] as? String{
            self.serviceName = name
        }
        if let supplierId = data["supplierId"] as? String{
            self.supplierId = supplierId
        }
        if let status = data["status"] as? ORDER_STATUS{
            self.status = status
        }
        if let employeeId = data["employeeId"] as? String{
            self.employeeId = employeeId
        }
        if let serviceName = data["serviceName"] as? String{
            self.serviceName = serviceName
        }
    }
    
    
    
    
    
    
    
    
    
    
    
}
