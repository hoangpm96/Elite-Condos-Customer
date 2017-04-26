//
//  SupplierApi.swift
//  Elite Condos
//
//  Created by Khoa on 4/8/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import Foundation
import Firebase
class SupplierApi{
    let ref = FIRDatabase.database().reference().child("suppliers")
    
    func observeSupplier(id: String, completion: @escaping (Supplier) -> Void){
        ref.child(id).observe(.value, with: { (snapshot) in
            
            if let dict = snapshot.value as? [String:Any]{
                let supplier = Supplier(id: snapshot.key, data: dict)
                completion(supplier)
            }
        })
    }
    func observeSuppliers(completion: @escaping (Supplier) -> Void){
        ref.observe(.childAdded, with: { (snapshot) in
            
            if let dict = snapshot.value as? [String:Any]{
                let supplier = Supplier(id: snapshot.key, data: dict)
                completion(supplier)
            }
        })
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
