//
//  SupplierHomeVC.swift
//  Elite Condos
//
//  Created by Khoa on 11/16/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import UIKit
import Firebase
class SupplierHomeVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var noOrderLbl: UILabel!
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
   
    var orders = [Order]()
    var isOnGoingClicked = true
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.revealViewController() != nil{
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        DataService.ds.REF_SUPPLIERS.child(userId).child("orders").queryOrdered(byChild: "status").queryEqual(toValue: ORDER_STATUS.ONGOING.hashValue).observe(.value, with: {
            
            snapshot in
            self.orders = []
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                for snap in snapshots {
                    
                    if let snapData = snap.value as? Dictionary<String, Any>{
                        let order = Order(id: snap.key, data: snapData)
                        self.orders.append(order)
                    }
                }
                
                self.tableView.reloadData()
            }})
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
       
    }

    // MARK: Tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Supplier_OrderCell", for: indexPath) as?
            Supplier_OrderCell{
            cell.configureCell(order: orders[indexPath.row])
            return cell
        }else {
            return UITableViewCell()
        }
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let orderId = orders[indexPath.row].id
        let customerId = orders[indexPath.row].customerId
        
        print(" Hello:  \(orderId) - \(customerId) ")
        let alert = UIAlertController(title: "Elite Condos", message: "", preferredStyle: .actionSheet)
        
        let chooseEmployee = UIAlertAction(title: "Chọn nhân viên", style: .default, handler: {
            action in
          
            
           
            
            self.performSegue(withIdentifier: "PickEmployeeVC", sender: ["order" : orderId,"customer" : customerId])
            
            
        })
        
        let cancelOrder = UIAlertAction(title: "Hủy đơn hàng", style: .default, handler: {
            action in
            
            // update order status - cancel
            
            DataService.ds.updateOrders(orderId: orderId, supplierId: userId, customerId: customerId, status : ORDER_STATUS.CANCEL)
            
            
        })
        
        let cancel = UIAlertAction(title: "Hủy", style: .cancel, handler: nil)
        
        if ( isOnGoingClicked  ){
            alert.addAction(chooseEmployee)
            alert.addAction(cancelOrder)
            
        }
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    // MARK: Functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "PickEmployeeVC" {
            if let pickEmployeeVC = segue.destination as? PickEmployeeVC{
                if let passingData = sender as? Dictionary<String,String>{
                    print(passingData)
                    if let order = passingData["order"]{
                         pickEmployeeVC.orderId = order
                    }
                    if let customer = passingData["customer"]{
                        pickEmployeeVC.customerId = customer
                    }
                  
                    }
                    
                }
            }}
    
    
    @IBAction func ongoingBtn(_ sender: Any) {
        isOnGoingClicked = true
        changeOrdersBy(status: ORDER_STATUS.ONGOING)
    }

    @IBAction func cancelBtn(_ sender: Any) {
        isOnGoingClicked = false
        changeOrdersBy(status: ORDER_STATUS.CANCEL)
    }
    
    @IBAction func finishBtn(_ sender: Any) {
        isOnGoingClicked = false
        changeOrdersBy(status: ORDER_STATUS.FINISHED)
    }
    func changeOrdersBy(status : ORDER_STATUS){
        DataService.ds.REF_SUPPLIERS.child(userId).child("orders").queryOrdered(byChild: "status").queryEqual(toValue: status.hashValue).observe(.value, with: {
            
            snapshot in
            print(snapshot)
            self.orders = []
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                for snap in snapshots {
                    if let snapData = snap.value as? Dictionary<String, Any>{
                        let order = Order(id: snap.key, data: snapData)
                        self.orders.append(order)
                    }
                }
                self.tableView.reloadData()
            }})
    }
}
    
   


