//
//  SupplierCell.swift
//  Elite Condos
//
//  Created by Khoa on 11/15/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import UIKit
import Firebase

protocol SupplierCellDelegate {
    func book(supplierId: String)
}

class SupplierCell: UITableViewCell {

    @IBOutlet weak var rating: CosmosView!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    
    var delegate: SupplierCellDelegate?
    var supplier: Supplier?{
        didSet{
            updateView()
        }
    }
    
    func updateView(){
        nameLbl.text = supplier?.name
        
        if let imgUrl = supplier?.logo {
            let url = URL(string: imgUrl)
            logoImage.sd_setImage(with: url)
        }
        
        
    }
    @IBAction func book_TouchUpInside(_ sender: Any) {
        delegate?.book(supplierId: (supplier?.id!)!)
    }
}




