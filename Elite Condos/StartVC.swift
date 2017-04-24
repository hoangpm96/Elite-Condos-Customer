//
//  StartVC.swift
//  Elite Condos
//
//  Created by Khoa on 11/14/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import UIKit
import FirebaseAuth
class StartVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if ( FIRAuth.auth()?.currentUser != nil  ){
            performSegue(withIdentifier: "StartVCToHome", sender: nil)
        }
        
    }
    
    
    
}
