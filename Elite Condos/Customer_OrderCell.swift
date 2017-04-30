//
//  Customer_OrderCell.swift
//  Elite Condos
//
//  Created by Khoa on 11/26/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import UIKit
import Firebase
class Customer_OrderCell: UITableViewCell {
    
    
    @IBOutlet weak var orderId: UILabel!
    @IBOutlet weak var supplierName: UILabel!
    @IBOutlet weak var technicianImg: CircleImage!
    
    @IBOutlet weak var serviceNameLbl: UILabel!
    
    
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
        
        // download supplier Image
//        FirRef.SUPPLIERS.child(order.supplierId).observeSingleEvent(of: .value, with: {
//            snapshot in
//            
//            if let snapData = snapshot.value as? Dictionary<String,Any>{
//                if let name = snapData["name"] as? String{
//                    self.supplierName.text = name
//                }
//            }
//        })
        
        
        
    }
    
}
