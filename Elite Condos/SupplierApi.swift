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
    
    // get supplier Name
    
    func getSupplierName(id: String, completion: @escaping (String) -> Void) {
        FirRef.SUPPLIERS.child(id).observeSingleEvent(of: .value, with: {
            snapshot in
            if let snapData = snapshot.value as? [String:Any]{
                if let name = snapData["name"] as? String{
                    
                    // name = "khoa"
                    
                    completion(name)
                }
            }
        })
    }
    
    func downloadImage(id: String,onError: @escaping (String) -> Void, onSuccess: @escaping (UIImage) -> Void ){
    
       
        
        FirRef.SUPPLIERS.child(id).observeSingleEvent(of: .value, with: {
            snapshot in
            if let snapData = snapshot.value as? [String:Any]{
                if let imgUrl = snapData["logoUrl"] as? String{
                    print("URL = \(imgUrl)")
                    Api.User
                    .downloadImage(imgUrl: imgUrl, onError: onError, onSuccess: onSuccess)
                }
            }
        })
    }
    
    
    // get total reviews score of a supplier
    
    func getTotalReviewScore(supplierId: String, onSuccess: @escaping (Double) -> Void){
        
        let ref = FirRef.SUPPLIER_REVIEWS.child(supplierId).child("totalStars")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String:Double]{
                if let rating = dict["rating"] {
                    onSuccess(rating)
                }
                
            }
        
        })
    
    }

    func calculateTotalRating(supplierId: String, newRating: Double,  onSuccess: @escaping () -> Void){
        
        // if exit else
        
        let ref = FirRef.SUPPLIER_REVIEWS.child(supplierId).child("totalStars")
//

        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if  !snapshot.exists() {
                
                ref.updateChildValues(["rating": newRating])
                onSuccess()
                
            }
            else {
                
                FirRef.SUPPLIER_REVIEWS.child(supplierId).child("totalStars").observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dict = snapshot.value as? [String:Double]{
                        
                        if let currentRating = dict["rating"]{
                            let updateRating = (currentRating + newRating) / 2
                            
                            self.updateTotalRating(supplierId: supplierId, newRating: updateRating, onSuccess: onSuccess)
                        }
                    }
                })

                
                
                
                
                
            }
        })
        
        
    }
    
    func updateTotalRating(supplierId: String, newRating: Double,  onSuccess: @escaping () -> Void){
        FirRef.SUPPLIER_REVIEWS.child(supplierId).child("totalStars").updateChildValues(["rating":newRating])

        onSuccess()
    }

    
}
