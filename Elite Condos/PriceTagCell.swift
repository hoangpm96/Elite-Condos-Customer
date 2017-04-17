//
//  PriceTagCell.swift
//  Elite Condos
//
//  Created by Khoa on 4/10/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import UIKit

class PriceTagCell: UITableViewCell {
    
    
    @IBOutlet weak var nameLbl : UILabel!
    @IBOutlet weak var priceLbl : UILabel!
    
    var priceTag: PriceTag?{
        didSet{
            updateView()
        }
    }  
    func updateView(){
        nameLbl.text = priceTag?.name
        
        if let price = priceTag?.price {
             priceLbl.text = "\(price)"
        }
       
    }
    
    
}

