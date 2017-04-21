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
