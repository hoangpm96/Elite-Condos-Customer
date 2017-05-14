//
//  CustomerSignUpVC.swift
//  Elite Condos
//
//  Created by Khoa on 11/14/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD
class SignUpVC: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    
    @IBOutlet weak var passwordTF: FancyField!
    @IBOutlet weak var phoneTF: FancyField!
    @IBOutlet weak var emailTF: FancyField!
    @IBOutlet weak var nameTF: FancyField!
    @IBOutlet weak var profileImage: CircleImage!
    
    
    @IBOutlet weak var avatarImage: CircleImage!
    
    
    var imagePicker : UIImagePickerController!
    var pickedImage = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        setupTextField()
        
    }
    func setupTextField(){
        nameTF.delegate = self
        emailTF.delegate = self
        passwordTF.delegate = self
        phoneTF.delegate = self
        
        nameTF.tag = 0
        emailTF.tag = 1
        passwordTF.tag = 2
        phoneTF.tag = 3
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            avatarImage.image = image
            pickedImage = true
        }else {
            print("Can't show picker")
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func signUp(_ sender: Any) {
        
        guard pickedImage == true else {
            showAlert(title: APP_NAME, message: "Vui lòng chọn hình profile")
            return
        }
        
        guard let name = nameTF.text, name != ""
            else {
                showAlert(title: SIGN_UP_ERROR, message: SIGN_UP_ERROR_NAME)
                return
        }
        guard let email = emailTF.text, let password = passwordTF.text, email != "",  password != ""
            else {
                showAlert(title: SIGN_UP_ERROR, message: SIGN_UP_ERROR_EMAIL_PASSWORD )
                return
        }
        
        guard let phone = phoneTF.text, phone != ""
            else {
                showAlert(title: SIGN_UP_ERROR, message: SIGN_UP_ERROR_PHONE)
                return
        }
        
//        callback
        
//        Api.User.signUp(name: "", email: "", password: "", phone: "", avatarImg: "", onSuccess: { 
//            <#code#>
//        }, onError: <#T##(String) -> Void#>)
        ProgressHUD.show("Creating account")
        Api.User.signUp(name: name, email: email, password: password, phone: phone, avatarImg: avatarImage.image!, onSuccess: {
            let alert = UIAlertController(title: APP_NAME, message: "Đăng Ký Thành Công, tự động đăng nhập", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { action in
                self.performSegue(withIdentifier: "SignUpToHome", sender: nil)
            })
            
            alert.addAction(okAction)
            
            ProgressHUD.dismiss()
            self.present(alert, animated: true, completion: nil)

            
            
        }) { (error) in
            self.showAlert(title: APP_NAME, message: error)
        }
        
        
    }
    
    
    
    func showAlert(title: String, message : String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    @IBAction func pickAvatar(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension SignUpVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let nextTF = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField{
            nextTF.becomeFirstResponder()
            nextTF.updateFocusIfNeeded()
        }
        else {
            textField.resignFirstResponder()
        }
        
        return false
    }
}
