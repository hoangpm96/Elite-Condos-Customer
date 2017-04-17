//
//  PasswordForgetVC.swift
//  Elite Condos
//
//  Created by Khoa on 3/30/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import UIKit

class PasswordForgetVC: UIViewController {

    @IBOutlet weak var emailTF: FancyField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func forgetPassword_TouchInside(_ sender: Any) {
        
        guard let email = emailTF.text, email != "" else {
            showAlert(title: APP_NAME, message: "Vui lòng nhập email")
            return
        }
        Api.User.forgetPassword(email: email, onError: { (error) in
            print(error)
        }, onSuccess: {
            self.showAlert(title: APP_NAME, message: "Vui lòng kiểm tra email để reset password!")
        })
    }

    func showAlert(title: String, message : String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
        
    }

    
   }
