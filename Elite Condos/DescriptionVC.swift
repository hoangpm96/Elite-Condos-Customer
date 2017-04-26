//
//  DescriptionVC.swift
//  Elite Condos
//
//  Created by Khoa on 3/16/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import UIKit
import CoreLocation


class DescriptionVC: UIViewController {

    @IBOutlet weak var descriptionTF: UITextField!
    @IBOutlet weak var continueBtn: UIButton!
    let locationManager = CLLocationManager()

    var userLocation = CLLocation()
    
    var isGetTime = false
    var isGetLocation = false
    @IBOutlet weak var photoImage: UIButton!
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var timeBtn: UIButton!
    var mainService = ""
    var subService = ""
    var current = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let popover = segue.destination as! PopupPhotoPickerVC
//        popover.delegate = self
        
        locationManager.delegate = self
        
        locationBtn.titleLabel?.numberOfLines = 2
        locationBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        locationBtn.titleLabel?.lineBreakMode = .byClipping
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if Api.Order.images.count > 0 {
            photoImage.imageView?.image = Api.Order.images[0]
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if  segue.identifier == "DesciptionToPopup"{
        
        if let popover = segue.destination as? PopupPhotoPickerVC{
            print("pop over")
            popover.delegate = self
        }
        }
    }
    
    @IBAction func getTimeBtnPressed(_ sender: Any) {
       
       
        let min = Date().addingTimeInterval(-60 * 60 * 24 * 0.5)
        let max = Date().addingTimeInterval(60 * 60 * 24 * 8)
        let picker = DateTimePicker.show(selected: min, minimumDate: min, maximumDate: max)
        picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.doneButtonTitle = "I pick this time!"
        picker.todayButtonTitle = "Today"
        picker.completionHandler = { date in
            self.current = date
            
            let today = Date()
            guard date > today else {
                self.showAlert(title: APP_NAME, message: "This time was in the past. Please choose the proper time!")
                return
            }
            
            
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm dd/MM/YYYY"
            let finalDate = formatter.string(from: date)
            
            self.timeBtn.setTitle(finalDate, for: .normal)
            self.isGetTime = true
        }
        
        
        
    }
    
    @IBAction func continueBtnPressed(_ sender: Any) {
        guard let description = descriptionTF.text, description != "" else {
            showAlert(title: APP_NAME, message: "You should fill in description")
            return
        }
        guard Api.Order.images.count > 0 else {
            showAlert(title: APP_NAME, message: "You should pick at least one picture")
            return
        }
        guard isGetTime == true else {
            showAlert(title: APP_NAME, message: "You should pick a time")
            return
        }
        guard isGetLocation == true else {
            showAlert(title: APP_NAME, message: "You should choose your address")
            return
        }
        
        
       
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func getLocationBtnPressed(_ sender: Any) {
        
        
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    func showAlert(title: String, message : String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func reserveGeo(){
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(userLocation, completionHandler: { (placemarks, error) in
            guard let addressDict = placemarks?[0].addressDictionary else {
                return
            }
            if let formattedAddress = addressDict["FormattedAddressLines"] as? [String] {
                let address  = formattedAddress.joined(separator: ", ")
                
                // set value to your control
                self.locationBtn.setTitle(address, for: .normal)
                self.isGetLocation = true
            }
            
        })
    }
}

extension DescriptionVC: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print(location.coordinate.latitude)
            print(location.coordinate.longitude )
            userLocation = location
            reserveGeo()
            
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
}

extension DescriptionVC: PopoverDelegate{
    func showPhotoImage() {
        print("In show photo image")
        if Api.Order.images.count > 0 {
            photoImage.setImage(Api.Order.images[0], for: .normal)
        }else {
            let img = UIImage(named: "photo")
            photoImage.setImage(img, for: .normal)
        }
    }
}
