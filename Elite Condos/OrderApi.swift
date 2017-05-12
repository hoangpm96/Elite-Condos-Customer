//
//  UserApi.swift
//  Elite Condos
//
//  Created by Khoa on 3/17/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import Foundation
import Firebase
import UIKit
import ProgressHUD
class OrderApi{
    var images: [UIImage] = [UIImage]()
    
    var mainService = ""
    var subService = ""
    
    var serviceId = ""
    
    
    // add order - add reviewID to order
    func addReview(supplierId: String, orderId: String, reviewData: [String:Any] ){
        FirRef.REVIEWS.child(orderId).updateChildValues(reviewData)
        FirRef.SUPPLIER_REVIEWS.child(supplierId).child(orderId).setValue(true)
    }
    // upload order photos -> img links
    func initOrder(orderData: [String:Any], onSuccess: @escaping (String) -> Void){
        uploadPhotos { (imgUrls) in
            var newData = orderData
            var imgStrings = ""
            for (index,value) in imgUrls.enumerated(){
                if (index == imgUrls.count - 1){
                    imgStrings += value
                }else {
                    imgStrings += "\(value),"
                }
            }
            newData["imgUrls"] = imgStrings
            let newChildId = randomString(length: 8)
            // wait here
            
            FirRef.ORDERS.child(newChildId).updateChildValues(newData)
            
            DispatchQueue.global().asyncAfter(deadline: .now() + 2 ) {
                print("all new child")
                onSuccess(newChildId)
            }
            
        }
    }
    
    // upload multiple photos
    func uploadPhotos(onSuccess: @escaping ([String]) -> Void){
        var imgUrls: [String] = []
        guard images.count > 0 else {
            return
        }
        
        let task = DispatchWorkItem {
            for img in self.images{
                
                self.uploadPhoto(photo: img, onSuccess: { (imgUrl) in
                    imgUrls.append(imgUrl)
                }, onError: { (error) in
                    print(error)
                })
                
            }}
        
//        
//        let start = DispatchTime.now()
        task.perform()
        
//        
//        let end  = DispatchTime.now()
//        
//        
//        
//        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
//        
//        let timeInterval = Double(nanoTime) / 1_000_000_000
//        
//        print("time= \(timeInterval))")
        
        
        
        
        // wait 10s to finish upload image task
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 10 ) {
            print("upload ok")
            onSuccess(imgUrls)
        }
        
    }
    
    // upload 1 photo
    func uploadPhoto(photo: UIImage, onSuccess: @escaping (String) -> Void, onError: @escaping (String) -> Void){
        if let imgData = UIImageJPEGRepresentation(photo, 0.1){
            let imgUid = NSUUID().uuidString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            
            
            FirRef.ORDER_IMAGES.child(imgUid).put(imgData, metadata: metadata, completion: { (metaData, error) in
                if error != nil{
                    onError("error \(error.debugDescription)")
                }else{
                    let downloadURL = metaData!.downloadURL()!.absoluteString
                    print("download URl \(downloadURL)")
                    onSuccess(downloadURL)
                }
            })
        }
    }
    
    // update order with new supplierid
    func updateOrder(orderId: String, supplierId : String, customerId : String, orderData : Dictionary<String,Any>, onSuccess: @escaping () -> Void){
        
        
        
        FirRef.ORDERS.child(orderId).updateChildValues(orderData)
        
        //
        
        FirRef.SUPPLIER_ORDERS.child(supplierId).child(orderId).setValue(true)
        FirRef.CUSTOMER_ORDERS.child(customerId).child(orderId).setValue(true)
        
        onSuccess()
    }
    
    
    // observe orders
    func observeCancelOrders(completed: @escaping (Order) -> Void, onNotFound: @escaping () -> Void){
        
        let uid = Api.User.currentUid()
        FirRef.CUSTOMER_ORDERS.child(uid).observe(.childAdded, with: { (snapshot) in
            print(snapshot.key)
            FirRef.ORDERS.child(snapshot.key).observe(.value, with: { (orderSnapshot) in
                if let dict = orderSnapshot.value as? [String:Any]{
                    if let status = dict["status"] as? Int{
                        if status == 1 {
                            print("status \(status)")
                            let order = Order(id: orderSnapshot.key, data: dict)
                            completed(order)
                        }else {
                            onNotFound()
                        }
                    }
                    
                }
            })
        })
    }
    
    // observe Orders with ORDER STATUS
    func observeOnGoingOrders(completed: @escaping (Order) -> Void, onNotFound: @escaping () -> Void){
        
        let uid = Api.User.currentUid()
        FirRef.CUSTOMER_ORDERS.child(uid).observe(.childAdded, with: { (snapshot) in
            print(snapshot.key)
            FirRef.ORDERS.child(snapshot.key).observe(.value, with: { (orderSnapshot) in
                if let dict = orderSnapshot.value as? [String:Any]{
                    print(dict)
                    if let status = dict["status"] as? Int{
                        if status == 0 {
                            print("status \(status)")
                            let order = Order(id: orderSnapshot.key, data: dict)
                            completed(order)
                        }else {
                            onNotFound()
                        }
                    }
                    
                    
                }
            })
        })
    }
    // observe Orders with ORDER STATUS
    func observeFinishOrders(completed: @escaping (Order) -> Void, onNotFound: @escaping () -> Void){
        
        let uid = Api.User.currentUid()
        FirRef.CUSTOMER_ORDERS.child(uid).observe(.childAdded, with: { (snapshot) in
            print(snapshot.key)
            FirRef.ORDERS.child(snapshot.key).observe(.value, with: { (orderSnapshot) in
                if let dict = orderSnapshot.value as? [String:Any]{
                    print(dict)
                    if let status = dict["status"] as? Int{
                        if status == 2 {
                            print("status \(status)")
                            let order = Order(id: orderSnapshot.key, data: dict)
                            completed(order)
                        }else {
                            onNotFound()
                        }
                    }
                    
                    
                }
            })
        })
    }
    
    
    // observe price tags - each orders have at least 1 price tag
    // price tags are displayed on PaymentConfirmation screen.
    
    func observePriceTag(orderId: String, completed: @escaping (PriceTag) -> Void){
        FirRef.ORDERS.child(orderId).child("pricetags").observe(.childAdded, with: { (snapshot) in
            if let dict = snapshot.value as? [String:Any]{
                let priceTag = PriceTag(id: snapshot.key, data: dict)
                completed(priceTag)
            }
        })
    }
    
    // confirm payment when order is finised, use in PaymentConfirmationVC
    func confirmPayment(orderId: String, totalPrice: Double, completion: @escaping () -> Void){
        let today = Date().description
        FirRef.ORDERS.child(orderId).updateChildValues(["totalPrice": totalPrice, "ended_at" : today, "status": ORDER_STATUS.FINISHED.hashValue ])
        completion()
    }
}












