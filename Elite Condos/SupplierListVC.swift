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
        Api.Supplier.observeSuppliers { (supplier) in
            self.suppliers.append(supplier)
            
            
            
            
            self.tableView.reloadData()
        }

       
//
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonAction))
        self.navigationItem.leftBarButtonItem = newBackButton
        
    }
 
    
    func sortSupplierArray(onSuccess: @escaping () -> Void){
        
        
        self.suppliers = self.suppliers.sorted(by: { (s1, s2) -> Bool in
            
            if let d1 = s1.distance, let d2 = s2.distance {
                return d1.isLess(than: d2)
            }else {
                return true
            }
            
        })
        
        self.suppliers = self.suppliers.sorted(by: { (s1, s2) -> Bool in
            
            if let d1 = s1.distance, let d2 = s2.distance {
                return d1.isLess(than: d2)
                
                
            }else {
                return true
            }
            
        })
    }
    
    
    func backButtonAction(){
        FirRef.ORDERS.child(orderId).removeValue()
        navigationController?.popViewController(animated: true)
        
    }
    
}
extension SupplierListVC: SupplierCellDelegate{
    func book(supplierId: String) {
        
        var newOrderData: [String:Any] = orderData
        newOrderData["supplierId"] = supplierId
        let currentUid = Api.User.currentUid()
        
        
        
        let alert = UIAlertController(title: APP_NAME, message: "Bạn đồng ý chọn nhà cung cấp này?", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Hủy", style: .cancel, handler: nil)
        
        let okAction = UIAlertAction(title: "Đồng ý", style: .default, handler: { action in
            ProgressHUD.show("Đang tạo đơn hàng...")
            
            Api.Order.updateOrder(orderId: self.orderId,supplierId: supplierId, customerId: currentUid, orderData: newOrderData) {
                ProgressHUD.dismiss()
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        )
        alert.addAction(cancel)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
        
        
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
