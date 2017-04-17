//
//  EmployeeVC.swift
//  Elite Condos
//
//  Created by Khoa on 11/16/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import UIKit
import Firebase
class EmployeeVC: UIViewController , UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    @IBOutlet weak var nameLbl: FancyField!
    @IBOutlet weak var avatarImage: UIImageView!

    @IBOutlet weak var phoneLbl: FancyField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    var imagePicker : UIImagePickerController!
    var imageSelected = false
    
    var employees = [Employee]()
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil{
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerEditedImage] as? UIImage{
            avatarImage.image = img
            imageSelected = true
        }else {
            print("EmployeeVC can't pick image")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeCell", for: indexPath) as? EmployeeCell{
            cell.configureCell(employee: employees[indexPath.row])
            return cell
        }else{
            return UITableViewCell()
        }
        
    
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if  editingStyle == .delete{
            
            let employeeId = employees[indexPath.row].id
            
            
            DataService.ds.REF_EMPLOYEES.child(employeeId).removeValue()
            //services.remove(at: indexPath.row)
            DataService.ds.REF_SUPPLIERS.child(userId).child("employees").child(employeeId).removeValue()
            tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Xóa"
    }

    
    @IBAction func addEmployeeButton(_ sender: Any) {
        
        userId = UserDefaults.standard.string(forKey: USER_ID)!
        
        
        
        guard let name = nameLbl.text, name != "" else {
            showAlert(title: "Lỗi", message: "Vui lòng điền tên nhân viên!")
            return
        }
        guard let phone = phoneLbl.text, phone != "" else {
            showAlert(title: "Lỗi", message: "Vui lòng điền số điện thoại!")
            return
        }
        
        guard let img = avatarImage.image, imageSelected == true else {
            showAlert(title: "Lỗi", message: "Vui lòng chọn ảnh đại diện")
            return
        }
        print("EmployeeVC userId \(userId)")
        
        var avatarUrl : String!
        if let imgData = UIImageJPEGRepresentation(img, 0.2){
            let imgUid = NSUUID().uuidString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            DataService.ds.REF_EMPLOYEE_AVATAR.child(imgUid).put(imgData, metadata: metadata, completion: { (metadata, error) in
                if error != nil{
                    avatarUrl = DEFAULT_CUSTOMER_AVATAR
                    print("Error to upload to server")
                }else{
                    avatarUrl = metadata?.downloadURL()?.absoluteString
                    if let imgUrl = avatarUrl{
                        print("employee avatar : \(avatarUrl)")
                        DataService.ds.addEmployee(supplierId: userId, employeeData: [
                            "name" : name,
                            "phone" : phone,
                            "avatarUrl" : imgUrl,
                            "supplierId" : userId
                            ])
                        self.resetChoosingEmployee()
                        

                    }
                    
                }
            })
        }
      
        
        
    }
 
    func showAlert(title: String, message : String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
        
    }

    @IBAction func pickImageBtn(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    func resetChoosingEmployee(){
        imageSelected = false
        nameLbl.text = ""
        phoneLbl.text = ""
        avatarImage.image = UIImage(named: "avatar-user")
    }
}
