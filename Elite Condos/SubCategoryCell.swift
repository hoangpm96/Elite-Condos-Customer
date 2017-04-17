//
//  SubCategoryCell.swift
//  Elite Condos
//
//  Created by Khoa on 3/15/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import UIKit

class SubCategoryCell: UITableViewCell {

    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var serviceImage: UIImageView!
   
    
    var service: ServiceData?{
        didSet{
            configureCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(){
        if let name = service?.name{
            serviceName.text = name
            
        }
        if let img = service?.imgUrl{
            serviceImage.image = UIImage(named: img)
        }
        
    }

   
}
