//
//  PaymentConfirmationVC.swift
//  Elite Condos
//
//  Created by Khoa on 4/10/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import UIKit
import Firebase
class PaymentConfirmationVC: UIViewController {

    @IBOutlet weak var confirmButton: FancyBtn!
    @IBOutlet weak var totalLbl: UILabel!
    var orderId = ""
    var total = 0.0
    var supplierName = ""
    var serviceName = ""
    var supplierId = ""
    @IBOutlet weak var tableView: UITableView!
    var priceTags = [PriceTag]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        print("orderId: \(orderId)")
        
        self.confirmButton.isHidden = true
        
        FirRef.ORDERS.child(orderId).child("pricetag").observe(.value, with:  { (snapshot) in
            
            self.priceTags = []
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                for snap in snapshots{
                    if let snapData = snap.value as? Dictionary<String,Any>{
                        
                        let priceTag = PriceTag(id: snap.key, data: snapData)
                        self.priceTags.append(priceTag)
                    }
                }
                self.tableView.reloadData()
             
            }
        })
        FirRef.ORDERS.child(orderId).child("total").observe(.value, with: { (snapshot) in
            if let totalPrice = snapshot.value as? Double{
                self.total  = totalPrice
                self.totalLbl.text = "\(totalPrice) VNĐ"
                self.confirmButton.isHidden = false
            }
        })
        
        

        
        
        
//        Api.Order.observePriceTag(orderId: orderId) { (pricetag) in
//            self.priceTags.append(pricetag)
//            self.calulateTotal()
//        }
    }
    
  
    
    @IBAction func confirm_TouchInside(_ sender: Any) {
        Api.Order.confirmPayment(orderId: orderId, totalPrice: total) {
            
            let senderData: [String:Any] = [
                "orderId": self.orderId,
                "supplierName": self.supplierName,
                "serviceName": self.serviceName,
                "total": self.total,
                "supplierId": self.supplierId
            ]
            
            self.performSegue(withIdentifier: "PaymentConfirmationToReview", sender: senderData)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PaymentConfirmationToReview"{
            if let reviewVC = segue.destination as? ReviewVC{
               
                if let data = sender as? [String:Any]{
                    if let orderId = data["orderId"] as? String{
                        reviewVC.orderId = orderId
                    }             
                    if let serviceName =  data["serviceName"] as? String{
                        reviewVC.serviceName = serviceName
                    }
                    if let supplierName = data["supplierName"] as? String{
                        reviewVC.supplierName = supplierName
                    }
                    if let supplierId = data["supplierId"] as? String{
                        reviewVC.supplierId = supplierId
                    }
                    if let totalPrice = data["total"] as? Double{
                        reviewVC.price = totalPrice
                    }
                }
                
                
            }
        }
    }
  
    
    

}
extension PaymentConfirmationVC: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return priceTags.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "PriceTagCell", for: indexPath) as! PriceTagCell
            cell.priceTag = priceTags[indexPath.row]
            return cell
    }

}

