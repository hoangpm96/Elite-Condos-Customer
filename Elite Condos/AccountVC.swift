//
//  AccountVC.swift
//  Elite Condos
//
//  Created by Khoa on 3/20/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import UIKit
import ProgressHUD
class AccountVC: UIViewController {
    @IBOutlet weak var nameTF: FancyField!

    @IBOutlet weak var phoneTF: FancyField!
    @IBOutlet weak var emailTF: FancyField!
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ProgressHUD.show("")
        Api.User.loadUserData { (name, email, phone ) in
            self.updateUI(name: name, email: email, phone: phone)
            ProgressHUD.dismiss()
        }
        
        nameTF.delegate = self
        phoneTF.delegate = self
        emailTF.delegate = self
        
    }

    func updateUI(name: String, email: String, phone: String){
        nameTF.text = name
        emailTF.text = email
        phoneTF.text = phone
    }
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signOut_TouchInside(_ sender: Any) {
        Api.User.signOut(onSuccess: { 
            let storyboard = UIStoryboard.init(name: "Start", bundle: nil)
            let homeVC = storyboard.instantiateViewController(withIdentifier: "StartVC")
            self.present(homeVC, animated: true, completion: nil)
        }) { (error) in
            print(error)
        }
        
    }
}
extension AccountVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        nameTF.resignFirstResponder()
        phoneTF.resignFirstResponder()
        emailTF.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nameTF{
            // API here
            print("nameTF \(textField.text!)")
        }
        if textField == emailTF{
            print("emailTF \(textField.text!)")
        }
        if textField == phoneTF{
            print("phoneTF \(textField.text!)")
        }
    }
}

