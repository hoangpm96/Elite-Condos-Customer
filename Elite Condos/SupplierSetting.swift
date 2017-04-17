//
//  SupplierSetting.swift
//  Elite Condos
//
//  Created by Khoa on 11/16/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import UIKit
import Firebase
class SupplierSetting: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    @IBOutlet weak var priceLbl: UITextField!
    @IBOutlet weak var serviceLbl: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    
    var services = [Service]()
    
    var listServices = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil{
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        tableView.delegate = self
        tableView.dataSource = self
        
        
        userId = UserDefaults.standard.string(forKey: USER_ID)!
        DataService.ds.REF_SERVICES.observe(.value, with:
            {
                
                snapshot in
                self.services = []
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                    
                    for snap in snapshots{
                        
                        if let snapData = snap.value as? Dictionary<String,Any>{
                            if let supplierId = snapData["supplierId"] as? String{
                                if supplierId == userId{
                                    let service = Service(id: snap.key, data: snapData)
                                    self.services.append(service)
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
        return services.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SupplierServiceCell", for: indexPath) as? SupplierServiceCell{
            cell.configureCell(service: services[indexPath.row])
            return cell
        }
        else{
            return UITableViewCell()
        }
    
    }
    
    @IBAction func addServiceButton(_ sender: Any) {
        guard let service = serviceLbl.text, service != "" else {
            showAlert(title: "Lỗi", message: "Vui lòng điền tên dịch vụ bạn cung cấp!")
            return
        }
        guard let price = priceLbl.text, price != "" else {
            showAlert(title: "Lỗi", message: "Vui lòng điền mức giá dịch vụ!")
            return
        }
        userId = UserDefaults.standard.string(forKey: USER_ID)!
        DataService.ds.addService(supplierId: userId, serviceData: [
            "name" : service,
            "price" : price,
            "supplierId" : userId])
        
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if  editingStyle == .delete{
            
            let serviceId = services[indexPath.row].serviceId
            
            
            DataService.ds.REF_SERVICES.child(serviceId).removeValue()
            //services.remove(at: indexPath.row)
            DataService.ds.REF_SUPPLIERS.child(userId).child("services").child(serviceId).removeValue()
            
            tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Xóa"
    }
    // MARK: Functions
    func showAlert(title: String, message : String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
        
    }

}







