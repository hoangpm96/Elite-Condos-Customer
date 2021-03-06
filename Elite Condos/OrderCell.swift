//
//  Customer_OrderCell.swift
//  Elite Condos
//
//  Created by Khoa on 11/26/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import UIKit
import Firebase

protocol Customer_OrderCellDelegate {
    func getSupplierName(name: String)
}

class OrderCell: UITableViewCell {
    
    
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var orderId: UILabel!
    @IBOutlet weak var supplierName: UILabel!
    @IBOutlet weak var logo: CircleImage!
    
    @IBOutlet weak var serviceNameLbl: UILabel!
    var delegate: Customer_OrderCellDelegate?
    
    var order: Order?{
        didSet{
            updateView()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func updateView(){
        
        serviceNameLbl.text = order?.serviceName
        orderId.text = "#\((order?.id)!)"
        
        if order?.time != nil {
            timeLbl.text = getTimeStringFrom(str: (order?.time)!)
        }
        
        
        // download supplier Image
        
        
        if order?.supplierId != nil {
            Api.Supplier.getSupplierName(id: (order?.supplierId)!) { (name) in
                self.supplierName.text = name
                self.delegate?.getSupplierName(name: name)
            }
            Api.Supplier.downloadImage(id: (order?.supplierId)!, onError: { (error) in
                print(error)
            }) { (img) in
                self.logo.image = img
                
            }
        }
        
    }
    
}
