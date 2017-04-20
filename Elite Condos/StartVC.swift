//
//  StartVC.swift
//  Elite Condos
//
//  Created by Khoa on 11/14/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import UIKit

class StartVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDefaults.standard.string(forKey: CUSTOMER_ID) != nil{
            print("Hello")
            performSegue(withIdentifier: "HomeVC", sender: nil)
            
        }
    }



    
    @IBAction func signUpButton(_ sender: Any) {
    self.performSegue(withIdentifier: "CustomerSignUp", sender: nil)
        
    }
   
  
    @IBAction func signInButton(_ sender: Any) {
        performSegue(withIdentifier: "CustomerSignIn", sender: nil)
    
    }
   

}
