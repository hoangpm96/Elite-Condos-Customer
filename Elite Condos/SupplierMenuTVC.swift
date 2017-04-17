//
//  SupplierMenuTVC.swift
//  Elite Condos
//
//  Created by Khoa on 11/16/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import UIKit
import Firebase
class SupplierMenuTVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 48/255, green: 49/255, blue: 77/255, alpha: 1.0)
        
    
    }

    @IBAction func logoutBtn(_ sender: Any) {
        do{
            try FIRAuth.auth()?.signOut()
            performSegue(withIdentifier: "SupplierMenuToStart", sender: nil)
            UserDefaults.standard.removeObject(forKey: USER_ID)
        }
        catch{
            print("Supplier can't sign out!")
        }
    }
}
