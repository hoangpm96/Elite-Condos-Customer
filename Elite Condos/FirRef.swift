//
//  DataService.swift
//  Elite Condos
//
//  Created by Hien on 11/14/16.
//  Copyright © 2016 Hien. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = FIRDatabase.database().reference()
let STORAGE_BASE = FIRStorage.storage().reference()

struct FirRef {
    // DB references
    static let POSTS = DB_BASE.child("posts")
    static let USERS = DB_BASE.child("users")
    static let CUSTOMERS = DB_BASE.child("customers")
    static let SUPPLIERS = DB_BASE.child("suppliers")
    static let EMPLOYEES = DB_BASE.child("employees")
    static let ORDERS = DB_BASE.child("orders")
    static let SUPPLIER_ORDERS = DB_BASE.child("supplier-orders")
    static let CUSTOMER_ORDERS = DB_BASE.child("customer-orders")
    static let REVIEWS = DB_BASE.child("reviews")
    static let SUPPLIER_REVIEWS = DB_BASE.child("supplier-reviews")
    
    // Storage references
    static  let POST_IMAGES = STORAGE_BASE.child("post-pics")
    static  let ORDER_IMAGES = STORAGE_BASE.child("order-pics")
    
    static  let CUSTOMER_AVATAR = STORAGE_BASE.child("customer_avatar")
    static   let SUPPLIER_LOGO = STORAGE_BASE.child("supplier_images")
    static let EMPLOYEE_AVATAR = STORAGE_BASE.child("employee_avatar")

    
    //
    //    func createFirbaseDBUser(uid: String, userData: Dictionary<String, String>) {
    //        REF_USERS.child(uid).updateChildValues(userData)
    //    }
    //    func createFirebaseDBCutomer(uid : String, userData : Dictionary<String, String>  ){
    //        REF_CUSTOMERS.child(uid).updateChildValues(userData)
    //
    //        let currentTime = getCurrentTime()
    //        REF_USERS.child(uid).updateChildValues(["customer" : true,
    //                                                "created_at" : currentTime])
    //    }
    //
    //    func createFirebaseDBSupplier(id : String, supplierData : Dictionary<String,Any>) {
    //        REF_SUPPLIERS.child(id).updateChildValues(supplierData)
    //
    //        let currentTime = getCurrentTime()
    //        REF_USERS.child(id).updateChildValues(["supplier" : true,
    //                                               "created_at" : currentTime])
    //    }
    //
    //    func addService( supplierId : String, serviceData : Dictionary<String,Any>){
    //
    //
    //        let randomId = randomString(length: 30)
    //        REF_SERVICES.child(randomId).updateChildValues(serviceData)
    //        REF_SUPPLIERS.child(supplierId).child("services").updateChildValues(
    //            [randomId : true])
    //
    //    }
    //
    //    func addEmployee(supplierId : String, employeeData : Dictionary<String, Any>){
    //
    //        let randomId = randomString(length: 30)
    //        REF_EMPLOYEES.child(randomId).updateChildValues(employeeData)
    //        REF_SUPPLIERS.child(supplierId).child("employees").updateChildValues([
    //            randomId : true])
    //    }
    //
    //    func createOrder(supplierId : String, customerId : String, orderData : Dictionary<String,Any>){
    //
    //
    //        // save to 3 paths - remember delete at 3 paths
    //        // use the same key for orderId = serviceId
    //        let randomId = randomString(length: 12)
    //        REF_ORDERS.child(randomId).updateChildValues(orderData)
    //        REF_SUPPLIERS.child(supplierId).child("orders").child(randomId).updateChildValues(orderData)
    //        REF_CUSTOMERS.child(customerId).child("orders").child(randomId).updateChildValues(orderData)
    //        // because we use serviceID for orderId
    //    }
    //    func deleteOrderByCustomer( orderId : String, supplierId : String, customerId : String ){
    //
    //        REF_ORDERS.child(orderId).removeValue()
    //        REF_SUPPLIERS.child(supplierId).child("orders").child(orderId).removeValue()
    //        REF_CUSTOMERS.child(customerId).child("orders").child(orderId).removeValue()
    //
    //    }
    //
    //    func updateOrders(orderId : String, supplierId : String, customerId : String, status : ORDER_STATUS ){
    //        REF_ORDERS.child(orderId).updateChildValues(["status": status.hashValue])
    //        REF_SUPPLIERS.child(supplierId).child("orders").child(orderId).updateChildValues(["status": status.hashValue])
    //        REF_CUSTOMERS.child(customerId).child("orders").child(orderId).updateChildValues(["status": status.hashValue])
    //    }
    //
    //    func addEmployee(orderId : String, supplierId : String, customerId : String, employeeId : String ){
    //        REF_ORDERS.child(orderId).updateChildValues([
    //            "employeeId" : employeeId
    //            ])
    //        REF_SUPPLIERS.child(supplierId).child("orders").child(orderId).updateChildValues(["employeeId" : employeeId])
    //        REF_CUSTOMERS.child(customerId).child("orders").child(orderId).updateChildValues(["employeeId" : employeeId])
    //    }
    //
    //    func addReview( supplierId : String , orderId :String, reviewData : Dictionary<String,Any>){
    //
    //        let randomId = randomString(length: 8)
    //        REF_SUPPLIERS.child(supplierId).child("reviews").child(randomId).updateChildValues(reviewData)
    //
    //
    //    }
    //
    //    //
    //
    //    func updateAvatar( userId : String, imageUrl : String  ){
    //
    //        REF_CUSTOMERS.child(userId).updateChildValues([
    //            "avatarUrl" : imageUrl
    //            ])
    //
    //    }
    //
    //
    
    
    
    
    
    
    
    
    
    
    // MARK:- Get properties
    
    //    func getCustomerNameBy(id : String) -> String{
    //        var customerName = ""
    //        REF_CUSTOMERS.child(id).observeSingleEvent(of: .value, with: {
    //            snapshot in
    //
    //                if let snapData = snapshot.value as? Dictionary<String,Any>{
    //                    if let name = snapData["name"] as? String{
    //                        customerName = name
    //                        return name
    //                    }
    //                    else {
    //                        return ""
    //                    }
    //                }
    //
    //
    //        })
    //    }
    
    
    
    
}
