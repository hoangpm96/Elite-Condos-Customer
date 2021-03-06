//
//  MyJobsVC.swift
//  Elite Condos
//
//  Created by Khoa on 3/20/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import UIKit
import ProgressHUD
import Firebase
class MyJobsVC: UIViewController {
    
//    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    let currendId = Api.User.currentUid()
    var orders = [Order]()
    var supplierName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
     
        fetchOrders(orderStatus: ORDER_STATUS.NOTACCEPTED.hashValue)
        
    }
    func fetchOrders(orderStatus: Int){
        
        ProgressHUD.show("Đang tải dữ liệu...")
        FirRef.ORDERS.queryOrdered(byChild: "customerId").queryEqual(toValue: currendId).observe(.value, with: { (snapshots) in
            if let snapshots = snapshots.children.allObjects as? [FIRDataSnapshot]{
                self.orders.removeAll()
                self.tableView.reloadData()
                for orderSnapshot in snapshots{
                    if let dict = orderSnapshot.value as? [String:Any]{
                        if let status = dict["status"] as? Int{
                            if status == orderStatus {
                               
                                let order = Order(id: orderSnapshot.key, data: dict)
                                self.orders.append(order)
                            }
                        }
                    }
                    
                }
                self.tableView.reloadData()
                ProgressHUD.dismiss()
            }
        })
        
        
    }
    @IBAction func waitingBtn(_ sender: Any) {
        fetchOrders(orderStatus: ORDER_STATUS.NOTACCEPTED.hashValue)
    }
    @IBAction func ongoingBtn(_ sender: Any) {
        fetchOrders(orderStatus: ORDER_STATUS.ONGOING.hashValue)
    }
    @IBAction func rejectedBtn_TouchInside(_ sender: Any) {
        fetchOrders(orderStatus: ORDER_STATUS.REJECTED.hashValue)
    }
    @IBAction func cancelBtn(_ sender: Any) {
        fetchOrders(orderStatus: ORDER_STATUS.CANCEL.hashValue)
    }
    
    @IBAction func finishBtn(_ sender: Any) {
        fetchOrders(orderStatus: ORDER_STATUS.FINISHED.hashValue)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MyJobToPaymentConfimation"{
            if let paymentVC = segue.destination as? PaymentConfirmationVC{
                if let data = sender as? [String:Any]{
                    if let orderId = data["orderId"] as? String{
                        paymentVC.orderId = orderId
                    }
                    if let supplierName = data["supplierName"] as? String{
                        paymentVC.supplierName = supplierName
                    }
                    if let serviceName = data["serviceName"] as? String{
                        paymentVC.serviceName = serviceName
                    }
                    if let supplierId = data["supplierId"] as? String{
                        paymentVC.supplierId = supplierId
                    }
                }
            }
        }
    }
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

extension MyJobsVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let status = orders[indexPath.row].status
        if status == ORDER_STATUS.ONGOING.hashValue {
            let senderData: [String:String] = [
                "orderId": self.orders[indexPath.row].id ?? "",
                "supplierName": supplierName,
                "serviceName": self.orders[indexPath.row].serviceName ?? "",
                "supplierId": self.orders[indexPath.row].supplierId ?? ""
            ]
            
            self.performSegue(withIdentifier: "MyJobToPaymentConfimation", sender: senderData)
        }
        
       
        
        
    }
}

extension MyJobsVC: Customer_OrderCellDelegate{
    func getSupplierName(name: String) {
        supplierName = name
    }
    
}

extension MyJobsVC: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
            cell.delegate = self
            cell.order = orders[indexPath.row]
            return cell
    }
}

