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
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var orders = [Order]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        orders = []
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchOrders()
    }
    
    func fetchOrders(){
        ProgressHUD.show("Đang tải dữ liệu...")
        Api.Order.observeOrders { (order) in
            self.orders.append(order)
            self.tableView.reloadData()
        }
    }
    
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
            cell.order = orders[indexPath.row]
            return cell
            
            
    }
}

