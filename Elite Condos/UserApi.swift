//
//  UserApi.swift
//  Elite Condos
//
//  Created by Khoa on 3/21/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import Foundation
import Firebase

class UserApi{
   
   
    func downloadUserImage(onError: @escaping (String) -> Void, onSuccess: @escaping (UIImage) -> Void){
        guard let user = FIRAuth.auth()?.currentUser else {
            return
        }
        
        DataService.ds.REF_CUSTOMERS.child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snap = snapshot.value as? [String:Any]{
                if let imgUrl = snap["avatarUrl"] as? String{
                    self.downloadImage(imgUrl: imgUrl, onError: { (error) in
                        onError(error)
                    }, onSuccess: { (img) in
                        onSuccess(img)
                    })
                }
            }
        })
    }
    
    func downloadImage(imgUrl: String, onError: @escaping (String) -> Void, onSuccess: @escaping (UIImage) -> Void ){
        let storage = FIRStorage.storage()
        let ref = storage.reference(forURL: imgUrl)
        ref.data(withMaxSize: 3 * 1024 * 1024) { (data, error) in
            if let error = error {
                onError(error.localizedDescription)
            }else{
                let img = UIImage(data: data!)
                onSuccess(img!)
            }
        }
    }
    
    func forgetPassword(email: String, onError: @escaping (String) -> Void, onSuccess: @escaping () -> Void ){
        FIRAuth.auth()?.sendPasswordReset(withEmail: email, completion: { (error) in
            if error != nil {
                onError((error?.localizedDescription)!)
                return 
            }
            onSuccess()
        })
    }
    
    func updatePhone(phone: String, onSuccess: @escaping () -> Void) {
        guard let user = FIRAuth.auth()?.currentUser else {
            return
        }
        DataService.ds.REF_CUSTOMERS.child(user.uid).updateChildValues(["phone": phone])
        
        onSuccess()
    }
    
    func updateName(name: String, onSuccess: @escaping () -> Void) {
        guard let user = FIRAuth.auth()?.currentUser else {
            return
        }
        DataService.ds.REF_CUSTOMERS.child(user.uid).updateChildValues(["name": name])
        
        onSuccess()
    }
    
    
    func updateEmail(email: String, onError: @escaping (String) -> Void, onSuccess: @escaping () -> Void){
 
        
        guard let user = FIRAuth.auth()?.currentUser else {
            return
        }
        
        DataService.ds.REF_CUSTOMERS.child(user.uid).updateChildValues(["email": email])
       
        FIRAuth.auth()?.currentUser?.updateEmail(email, completion: { (callback) in
            if callback != nil {
                onError((callback?.localizedDescription)!)
                return
            }
            
        })
        onSuccess()
    }
    
    func updatePassword(password: String, onError: @escaping (String) -> Void){
       
        FIRAuth.auth()?.currentUser?.updatePassword(password, completion: { (error) in
            if error != nil {
                onError((error?.localizedDescription)!)
            }
        })
    }
    
    func signOut(onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void){
        do {
           try  FIRAuth.auth()?.signOut()
            onSuccess()
        } catch{
            onError("can't sign out")
        }
    }
    
    func uploadAvatar(avatarImg: UIImage,onSuccess: @escaping (String) -> Void, onError: @escaping (String) -> Void ){
        
        if let imgData = UIImageJPEGRepresentation(avatarImg, 0.2){
            let imgUid = NSUUID().uuidString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            DataService.ds.REF_CUSTOMER_AVATAR.child(imgUid).put(imgData, metadata: metadata, completion: { (metaData, error) in
                if error != nil{
                    onError(error.debugDescription)
                }else{
                     let downloadURL = metaData!.downloadURL()!.absoluteString
                    onSuccess(downloadURL)
                }
            })
        }
    }
    
    func signUp(name: String, email: String, password: String, phone: String, avatarImg: UIImage, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void){
        
        uploadAvatar(avatarImg: avatarImg, onSuccess: { (imgUrl) in
            
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                
                if error != nil{
                    
                    let errorDetail = (error as! NSError).localizedDescription
                    
                    onError(errorDetail)
                }
                if let user = user{
                    let userData = [
                        "name" : name,
                        "email" : email,
                        "phone" : phone,
                        "avatarUrl" : imgUrl
                    ]
                    DataService.ds.createFirebaseDBCutomer(uid: user.uid, userData: userData)
                    onSuccess()
                }
            })
            
        }) { (error) in
            onError(error)
        }
        
    }
    
    
    func loadUserData(completed: @escaping (String,String,String) -> Void){
        guard let user = FIRAuth.auth()?.currentUser else {
            return
        }
        DataService.ds.REF_CUSTOMERS.child(user.uid).observe(.value, with: { (snapshot) in
            if let dict = snapshot.value as? [String:Any]{
                guard let phone = dict["phone"] as? String else{
                    return
                }
                guard let name = dict["name"] as? String else{
                    return
                }
            
                
                let email = FIRAuth.auth()?.currentUser?.email
                
                if let email = email{
                    completed(name, email, phone)
                }
                
                
                
                
                
       
            }
        })
    }
    
    func login( email: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void ) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil{
                let errorDetail = (error as! NSError).localizedDescription
                
                onError(errorDetail)
                
            }else{
                print("Login successfully!")
                
                guard let userId = FIRAuth.auth()?.currentUser?.uid else {
                    return
                }
                
                DataService.ds.REF_USERS.child(userId).observeSingleEvent(of: .value, with: {snapshot in
                    if let userData = snapshot.value as? Dictionary<String,Any>{
                        print(userData)
                        if let _ = userData["customer"]{
                            
                            onSuccess()
                        }
                        if let supplier = userData["supplier"]{
                            print(supplier)
                            
                            onError("Tài khoản của bạn là tài khoản nhà cung cấp, vui lòng sử dụng ứng dụng \(APP_NAME) Supplier")
   
                        }
                    }
                }
                )
                
                
                
                
            }
        })

    }
    
    
}
