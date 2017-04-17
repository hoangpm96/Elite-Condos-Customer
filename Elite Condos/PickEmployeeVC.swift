//
//  PickEmployeeVC.swift
//  Elite Condos
//
//  Created by Khoa on 11/29/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import UIKit
import Firebase
class PickEmployeeVC: UIViewController , UITableViewDelegate, UITableViewDataSource{

    
    
    var orderId = ""
    var customerId = ""
    
    var employees = [Employee]()
    @IBOutlet weak var tableView : UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        userId = UserDefaults.standard.string(forKey: USER_ID)!
        DataService.ds.REF_EMPLOYEES.observe(.value, with:
            {
                
                snapshot in
                self.employees = []
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                    
                    for snap in snapshots{
                        
                        if let snapData = snap.value as? Dictionary<String,Any>{
                            if let supplierId = snapData["supplierId"] as? String{
                                if supplierId == userId{
                                    let employee = Employee(id: snap.key, data: snapData)
                                    self.employees.append(employee)
                                }
                            }
                            
                        }
                    }
                    self.tableView.reloadData()
                }})
        

    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeCell2", for: indexPath) as? EmployeeCell{
            cell.configureCell(employee: employees[indexPath.row])
            return cell
        }else{
            return UITableViewCell()
        }
        
           // return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let employeeId = employees[indexPath.row].id

        DataService.ds.addEmployee(orderId: orderId, supplierId: userId, customerId: customerId, employeeId: employeeId)
        
        let alert = UIAlertController(title: APP_NAME, message: "Đã cập nhật nhân viên thành công!", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)

        
    }

   

    
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
 

}
