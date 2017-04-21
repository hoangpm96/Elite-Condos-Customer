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
    
    
    
    func uploadAvatar(avatarImg: UIImage,onSuccess: @escaping (String) -> Void, onError: @escaping (String) -> Void ){
        
        if let imgData = UIImageJPEGRepresentation(avatarImg, 0.2){
            let imgUid = NSUUID().uuidString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            DataService.ds.REF_CUSTOMER_AVATAR.child(imgUid).put(imgData, metadata: metadata, completion: { (metadata, error) in
                if error != nil{
                    onError(error.debugDescription)
                }else{
                    
                    if let avatarUrl = metadata?.downloadURL()?.absoluteString{
                        onSuccess(avatarUrl)
                    }
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
    
    
    func loadUserData(){
        guard let user = FIRAuth.auth()?.currentUser else {
            return
        }
        
        DataService.ds.REF_USERS.child(user.uid).observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.value as? [String:Any]{
                print(snapshot)
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
