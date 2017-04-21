//
//  AccountVC.swift
//  Elite Condos
//
//  Created by Khoa on 3/20/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import UIKit

class AccountVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Api.User.loadUserData()
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }


}
