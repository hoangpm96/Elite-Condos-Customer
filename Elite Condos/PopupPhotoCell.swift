//
//  PopupPhotoCell.swift
//  Elite Condos
//
//  Created by Khoa on 3/17/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import UIKit

class PopupPhotoCell: UICollectionViewCell {
    @IBOutlet weak var photo: UIImageView!
       override func awakeFromNib() {
        
    }
    
    func configureCell(img: UIImage){
        photo.image = img
    }
}
