//
//  EmployeeCell.swift
//  Elite Condos
//
//  Created by Khoa on 11/18/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import UIKit
import Firebase
class EmployeeCell: UITableViewCell {

    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var avatarImage: CircleImage!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell( employee : Employee ){
        self.nameLbl.text = employee.name
        self.phoneLbl.text = employee.phone
        
        
        let ref = FIRStorage.storage().reference(forURL: employee.avatarUrl)
        
        ref.data(withMaxSize: 2 * 1024 * 1024, completion:
            { data, error in
                if error != nil{
                    print("can't download image from Firebase")
                }else{
                    
                    if let data = data {
                        
                        if let imageData = UIImage(data: data){
                            self.avatarImage.image = imageData
                        }
                    }
                }
                
        })

    }

}
