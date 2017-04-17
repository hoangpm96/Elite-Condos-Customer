//
//  SupplierSignUp.swift
//  Elite Condos
//
//  Created by Khoa on 11/16/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import UIKit
import Firebase
class SupplierSignUp: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var pickLogoLbl: UILabel!
    @IBOutlet weak var passwordLbl: FancyField!
    @IBOutlet weak var phoneLbl: FancyField!
    @IBOutlet weak var addressLbl: FancyField!
    @IBOutlet weak var emailLbl: FancyField!
    @IBOutlet weak var nameLbl: FancyField!
    @IBOutlet weak var logoImage: UIImageView!
    
    var imagePicker : UIImagePickerController!
    var isPickedImage = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerEditedImage] as? UIImage{
            logoImage.image = img
            isPickedImage = true
            pickLogoLbl.isHidden = true
            logoImage.isHidden = false
        }else{
            print("Can't show image picker")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pickLogoBtn(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func signUpButton(_ sender: Any) {
        
        guard let name = nameLbl.text, name != "" else {
            showAlert(title: SIGN_UP_ERROR, message: SIGN_UP_ERROR_NAME)
            return
        }
        guard let email = emailLbl.text, let password = passwordLbl.text, email != "" , password != "" else {
            showAlert(title: SIGN_UP_ERROR, message: SIGN_UP_ERROR_EMAIL_PASSWORD)
            return
        }
        guard let address = addressLbl.text, address != "" else {
            showAlert(title: SIGN_UP_ERROR, message: SIGN_UP_ERROR_ADDRESS)
            return
        }
        guard let phone = phoneLbl.text, phone != "" else {
            showAlert(title: SIGN_UP_ERROR, message: SIGN_UP_ERROR_PHONE)
            return
        }
        
        var logoUrl  = DEFAULT_SUPPLIER_LOGO
        if let imgData = UIImageJPEGRepresentation(logoImage.image!, 0.2){
            let imgUid = NSUUID().uuidString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            DataService.ds.REF_SUPPPLIER_LOGO.child(imgUid).put(imgData, metadata: metadata, completion: { (metadata, error) in
                if error != nil{
                    print("Error to upload to server")
                }else{
                    logoUrl = (metadata?.downloadURL()?.absoluteString)!
                    print("Upload image \(logoUrl)")
                }
            })
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                self.showAlert(title: SIGN_UP_ERROR, message: (error as! NSError).localizedDescription)
            }else{
                if let user = user {
                    
                    let id = user.uid
                    
                    let supplierData = ["name" : name,
                                        "email" : email,
                                        "address" : address,
                                        "phone" : phone,
                                        "logoUrl" : logoUrl]
                    
                    DataService.ds.createFirebaseDBSupplier(id: id, supplierData: supplierData)
                    
                    
                    
                }
                
                
            }
        })
    }
    // MARK: Functions
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func showAlert(title: String, message : String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
        
    }
}
