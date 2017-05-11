//
//  ReviewVC.swift
//  Elite Condos
//
//  Created by Khoa on 4/10/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import UIKit
import FirebaseAuth
import ProgressHUD
class ReviewVC: UIViewController {
    
    
    @IBOutlet weak var reviewTF: FancyField!
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
        ProgressHUD.show("Đang đăng nhận xét...")
    
        guard let review = reviewTF.text, review != "" else {
            showAlert(title: "Error", message: "Vui lòng điền nội dung đánh giá")
            return
        }
        let username = FIRAuth.auth()?.currentUser?.email
        let currenId = Api.User.currentUid()
        Api.User.getImageProfile { (imgUrl) in
            let reviewData: [String:Any] =
                [
                    "time" : getCurrentTime(),
                    "customerId" : currenId,
                    "username": username! ,
                    "moneyAmount": self.price,
                    "ratingStars" : self.rating.rating,
                    "content" : review,
                    "imgUrl": imgUrl
            ]
            
            
            Api.Order
                .addReview(supplierId: self.supplierId, orderId: self.orderId, reviewData: reviewData)
            self.showAlert(title: "✓", message: "Bạn đã thêm nhận xét thành công, xin cảm ơn!")
            
            
        }
        
    }
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func showAlert(title: String, message : String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler:  {
            action in
            self.performSegue(withIdentifier: "ReviewToHome", sender: nil)
        })
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func skip_TouchInside(_ sender: Any) {
        performSegue(withIdentifier: "ReviewToHome", sender: nil)
    }
    
}
