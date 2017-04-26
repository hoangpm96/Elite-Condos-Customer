//
//  SupplierCell.swift
//  Elite Condos
//
//  Created by Khoa on 11/15/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import UIKit
import Firebase

class SupplierCell: UITableViewCell {

    @IBOutlet weak var rating: CosmosView!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    
    var supplier: Supplier?{
        didSet{
            updateView()
        }
    }
    
    func updateView(){
        nameLbl.text = supplier?.name
    }
  

}
