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
        guard let email = emailTF.text, email != "" else {
            showAlert(title: SIGN_IN_ERROR, message: SIGN_IN_ERROR_EMAIL)
            return
        }
        guard let password = passwordTF.text, password != "" else {
            showAlert(title: SIGN_IN_ERROR, message: SIGN_IN_ERROR_PASSWORD)
            return
        }
        
        Api.User.login(email: email, password: password, onSuccess: { 
            self.performSegue(withIdentifier: "LoginToHome", sender: nil)
        }) { (error) in
            self.showAlert(title: APP_NAME, message: error)
        }
        
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
