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
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    let currendId = Api.User.currentUid()
    var orders = [Order]()
    var supplierName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
      
        
        FirRef.ORDERS.queryOrdered(byChild: "customerId").queryEqual(toValue: currendId).observe(.value, with: { (snapshots) in
            print(snapshots)
            
            if let snapshots = snapshots.children.allObjects as? [FIRDataSnapshot]{
                self.orders.removeAll()
                for orderSnapshot in snapshots{
                    if let dict = orderSnapshot.value as? [String:Any]{
                        print(dict)
                        if let status = dict["status"] as? Int{
                            if status == 0 {
                                print("alo \(status)")
                                let order = Order(id: orderSnapshot.key, data: dict)
                                self.orders.append(order)
                            }
                        }
                    }
                    
                }
                ProgressHUD.dismiss()
                self.tableView.reloadData()
            }
            
            
            
        })
        
        
//        
//        self.navigationItem.hidesBackButton = true
//        let newBackButton = UIBarButtonItem(title: "Back1", style: .plain, target: self, action: #selector(backButtonAction))
//        self.navigationItem.leftBarButtonItem = newBackButton
        
    }
    
//    func backButtonAction(){
//        print("say hi")
//        
//        
//    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchOrders(status: 0)
    }
    
    func fetchOrders(status: Int){
        
        FirRef.ORDERS.queryOrdered(byChild: "customerId").queryEqual(toValue: currendId).observe(.value, with: { (snapshots) in
            print(snapshots)
            
            if let snapshots = snapshots.children.allObjects as? [FIRDataSnapshot]{
                self.orders.removeAll()
                for orderSnapshot in snapshots{
                    if let dict = orderSnapshot.value as? [String:Any]{
                        print(dict)
                        if let status = dict["status"] as? Int{
                            if status == status {
                                print("alo \(status)")
                                let order = Order(id: orderSnapshot.key, data: dict)
                                self.orders.append(order)
                            }
                        }
                    }
                    
                }
                ProgressHUD.dismiss()
                self.tableView.reloadData()
            }
            
            
            
        })
        
        
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
//        performSegue(withIdentifier: "MyJobToHome", sender: nil)
    }
    
    @IBAction func segment_ChangeValue(_ sender: Any) {
        
        let segmentValue = segment.selectedSegmentIndex
        
        switch segmentValue {
        case 0:
             fetchOrders(status: 0)
        case 1:
            fetchOrders(status: 1)
        case 2:
            fetchOrders(status: 2)
        case 3:
            fetchOrders(status: 3)
        default:
            return
        }
        
//        
//        if segmentValue == 0 {
//            fetchOrders(status: 0)
//        }else if segmentValue == 1 {
//            fetchOrders(status: 1)
//        }else if segmentValue == 2 {
//            fetchOrders(status: 2)
//        }else if segmentValue == 3 {
//             fetchOrders(status: 3)
//        }
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

