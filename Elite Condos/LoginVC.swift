//
//  LoginVC.swift
//  Elite Condos
//
//  Created by Khoa on 11/14/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import UIKit
import Firebase
class LoginVC: UIViewController , UITextFieldDelegate {

    @IBOutlet weak var passwordTF: FancyField!
    @IBOutlet weak var emailTF: FancyField!
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    
    }


    
    @IBAction func loginButton(_ sender: Any) {
//        guard let email = emailTF.text, email != "" else {
//            showAlert(title: SIGN_IN_ERROR, message: SIGN_IN_ERROR_EMAIL)
//            return
//        }
//        guard let password = passwordTF.text, password != "" else {
//            showAlert(title: SIGN_IN_ERROR, message: SIGN_IN_ERROR_PASSWORD)
//            return
//        }
        
        let email = "khoa@gmail.com"
        let password = "123456"
        self.performSegue(withIdentifier: "LoginToHome", sender: nil)
//        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
//            if error != nil{
//                let errorDetail = (error as! NSError).localizedDescription
//                self.showAlert(title: SIGN_IN_ERROR, message: errorDetail)
//            }else{
//                print("Login successfully!")
//           
//                
//         
//                
//                let id = user?.uid
//                userId = id!
//                DataService.ds.REF_USERS.child(id!).observeSingleEvent(of: .value, with: {snapshot in
//                    if let userData = snapshot.value as? Dictionary<String,Any>{
//                        print(userData)
//                        
//                        
//                        if let customer = userData["customer"]{
//                            self.performSegue(withIdentifier: "LoginToHome", sender: nil)
//                            print(customer)
//                        }
//                        if let supplier = userData["supplier"]{
//                            print(supplier)
//                         self.showAlert(title: APP_NAME, message: "Tài khoản của bạn là tài khoản nhà cung cấp, vui lòng sử dụng ứng dụng \(APP_NAME) Supplier")
//                            
//                        }
//                        
//                    }
//                }
//                )
//                
//                
//                
//                
//            }
//        })
//        
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        passwordTF.resignFirstResponder()
        return true
    }
    
    func showAlert(title: String, message : String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)


        present(alert, animated: true, completion: nil)
        
    }

 
    
}
