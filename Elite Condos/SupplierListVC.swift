//
//  SupplierListVC.swift
//  Elite Condos
//
//  Created by Khoa on 4/8/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import UIKit
import ProgressHUD
class SupplierListVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var suppliers: [Supplier]!
    
    var orderData: [String:Any]!
    var orderId =  ""
    override func viewDidLoad() {
        super.viewDidLoad()
        suppliers = []
        tableView.dataSource = self
        
        ProgressHUD.show("Đang tìm kiếm nhà cung cấp")
        Api.Supplier.observeSuppliers { (supplier) in
            self.suppliers.append(supplier)
            self.tableView.reloadData()
            ProgressHUD.dismiss()
        }
    }

}

extension SupplierListVC: SupplierCellDelegate{
    func book(supplierId: String) {
        
        var newOrderData: [String:Any] = orderData
        newOrderData["supplierId"] = supplierId
        let currentUid = Api.User.currentUid()
        
        ProgressHUD.show("Đang tạo đơn hàng...")
       
        Api.Order.updateOrder(orderId: self.orderId,supplierId: supplierId, customerId: currentUid, orderData: newOrderData) {
            ProgressHUD.dismiss()
        }
    }
}


extension SupplierListVC: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suppliers.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SupplierCell", for: indexPath) as! SupplierCell
        cell.supplier = suppliers[indexPath.row]
        cell.delegate = self
        return cell
    }
    
}
