//
//  MyJobsVC.swift
//  Elite Condos
//
//  Created by Khoa on 3/20/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import UIKit
import ProgressHUD
class MyJobsVC: UIViewController {
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    var orders = [Order]()
    var supplierName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchOrders(status: 0)
    }
    
    func fetchOrders(status: Int){
        orders = []
        self.tableView.reloadData()
        ProgressHUD.show("Đang tải dữ liệu...")
        
        switch status {
        case 0:
            Api.Order.observeOnGoingOrders(completed: { (order) in
                self.orders.append(order)
                self.tableView.reloadData()
                ProgressHUD.dismiss()
            }, onNotFound: {
                ProgressHUD.dismiss()
            })
        case 1:
            Api.Order.observeCancelOrders(completed: { (order) in
                self.orders.append(order)
                self.tableView.reloadData()
                ProgressHUD.dismiss()
            }, onNotFound: {
                ProgressHUD.dismiss()
            })
        case 2:
            Api.Order.observeFinishOrders(completed: { (order) in
                self.orders.append(order)
                self.tableView.reloadData()
                ProgressHUD.dismiss()
            }, onNotFound: {
                ProgressHUD.dismiss()
            })
        default:
            return
        }
        
        
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
    
    @IBAction func segment_ChangeValue(_ sender: Any) {
        
        let segmentValue = segment.selectedSegmentIndex
        
        if segmentValue == 0 {
            fetchOrders(status: 0)
        }else if segmentValue == 1 {
            fetchOrders(status: 1)
        }else {
            fetchOrders(status: 2)
        }
    }
}

extension MyJobsVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let senderData: [String:Any] = [
            "orderId": self.orders[indexPath.row].id,
            "supplierName": supplierName,
            "serviceName": self.orders[indexPath.row].serviceName,
            "supplierId": self.orders[indexPath.row].supplierId
        ]
        
        self.performSegue(withIdentifier: "MyJobToPaymentConfimation", sender: senderData)
        
        //        Api.Supplier.getSupplierName(id: orders[indexPath.row].id) { (name) in
        //                        self.performSegue(withIdentifier: "MyJobToPaymentConfimation", sender: senderData)
        //        }
        
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "Customer_OrderCell", for: indexPath) as! Customer_OrderCell
            cell.delegate = self
            cell.order = orders[indexPath.row]
            return cell
    }
}

