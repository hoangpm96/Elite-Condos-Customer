//
//  ReviewVC.swift
//  Elite Condos
//
//  Created by Khoa on 4/10/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import UIKit

class ReviewVC: UIViewController {

   
    @IBOutlet weak var reviewTF: FancyField!
    @IBOutlet weak var nameTF: FancyField!
    @IBOutlet weak var rating: CosmosView!
 
    @IBOutlet weak var supplierLogo: UIImageView!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var serviceNameLbl: UILabel!
    @IBOutlet weak var supplierNameLbl: UILabel!
    var orderId = ""
    var serviceName = ""
    var price = 0.0
    var supplierName = ""
    var employeeImge = ""
    var supplierId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        supplierNameLbl.text = supplierName
        serviceNameLbl.text = serviceName
        priceLbl.text = "\(price)"
        Api.Supplier.downloadImage(id: supplierId, onError: { (error) in
            print(error)
        }) { (img) in
            self.supplierLogo.image = img
        }
    }
    
    
    
    @IBAction func addReview_TouchInside(_ sender: Any) {
        guard let name = nameTF.text, name != "" else {
            showAlert(title: "Error", message: "Vui lòng điền tên của bạn")
            return
        }
        guard let review = reviewTF.text, review != "" else {
            showAlert(title: "Error", message: "Vui lòng điền nội dung đánh giá")
            return
        }
        
        
//        DataService.ds.addReview(supplierId: supplierId, orderId: orderId, reviewData: [
//            "created_at" : getCurrentTime(),
//            "customerId" : userId,
//            "customerName" : name,
//            "serviceName" : serviceName,
//            "stars" : rating.rating,
//            "content" : review
//            ])
//        DataService.ds.updateOrders(orderId: orderId, supplierId: supplierId, customerId: userId, status: .FINISHED)
//        showAlert(title: APP_NAME, message: "Bạn đã thêm nhận xét thành công, xin cảm ơn!")
        
        
    }
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func showAlert(title: String, message : String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler:  {
            action in
            self.performSegue(withIdentifier: "CustomerOrderVC", sender: nil)
        })
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func skip_TouchInside(_ sender: Any) {
        performSegue(withIdentifier: "ReviewToHome", sender: nil)
    }

}
