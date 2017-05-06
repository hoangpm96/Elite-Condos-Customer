//
//  PaymentConfirmationVC.swift
//  Elite Condos
//
//  Created by Khoa on 4/10/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import UIKit

class PaymentConfirmationVC: UIViewController {

    var orderId = "C46kg9qq"
    @IBOutlet weak var tableView: UITableView!
    var priceTags = [PriceTag]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        Api.Order.observePriceTag(orderId: orderId) { (pricetag) in
            self.priceTags.append(pricetag)
            self.calulateTotal()
        }
        
    }

    @IBAction func confirm_TouchInside(_ sender: Any) {
    }

    
    func calulateTotal(){
        var total = 0.0
        for pricetag in priceTags{
            total += pricetag.price
        }
        let random = randomString(length: 5)
        let id = "total\(random)"
        let totalPrice = PriceTag(id: id, name: "Tổng", price: total)
        priceTags.append(totalPrice)
//        priceTags = priceTags.sorted(by: { $0.price < $1.price  })
        priceTags = priceTags.sorted{ $0.price < $1.price }
        self.tableView.reloadData()
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

