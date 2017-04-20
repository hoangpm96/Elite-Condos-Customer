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

    let locationManager = CLLocationManager()

    @IBOutlet weak var photoImage: UIButton!
    @IBOutlet weak var timeBtn: UIButton!
    var mainService = ""
    var subService = ""
    var current = Date()
    override func viewDidLoad() {
        super.viewDidLoad()
        
         locationManager.delegate = self
        print(mainService)
        print(subService)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if Api.Order.images.count > 0 {
            photoImage.imageView?.image = Api.Order.images[0]
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
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
            print(finalDate)
        }
        
        
        
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
}

extension DescriptionVC: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print(location.coordinate.latitude)
            print(location.coordinate.longitude )
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
}
