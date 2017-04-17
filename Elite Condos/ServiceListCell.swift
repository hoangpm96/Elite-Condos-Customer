//
//  ServiceListCell.swift
//  Elite Condos
//
//  Created by Khoa on 11/18/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import UIKit

class ServiceListCell: UITableViewCell {

    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(service : Service){
        //priceLbl.text = service.price
        nameLbl.text  = service.name
    }

}
