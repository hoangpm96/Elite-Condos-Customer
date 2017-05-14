//
//  HomeVC.swift
//  Elite Condos
//
//  Created by Khoa on 3/15/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import UIKit
import FirebaseInstanceID
import FirebaseMessaging
import FirebaseDatabase
class HomeVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let services = getServiceData()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self 

        FIRMessaging.messaging().subscribe(toTopic: "/topics/news")
        
        
        var totalStars: Double = 0.0
        var count: Int = 1
        var average = 0.0
        
        
     
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        if let subVC = segue.destination as? SubCategoryVC{
            if let data = sender as? [String:Any]{
                if let subServices = data["data"] as? [ServiceData]{
                    subVC.services = subServices
                }
                
                if let id = data["id"] as? String{
                    Api.Order.serviceId = id
                }
                
                if let title = data["title"] as? String{
                    subVC.navTitle = title
                    Api.Order.mainService = title
                }
            }
        }
    }
}

extension HomeVC: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell", for: indexPath) as? ServiceCell{
            cell.service = services[indexPath.row]
            return cell
        }
        else{
            return UITableViewCell()
        }
        
    }
}

extension HomeVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "HomeToSubCategory", sender:
            ["data": services[indexPath.row].subCategory! ,
            "title": services[indexPath.row].name,
            "id" : services[indexPath.row].id!
            ] as [String:Any]
                )
    }
}
