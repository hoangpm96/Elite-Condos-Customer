//
//  SubCategoryVC.swift
//  Elite Condos
//
//  Created by Khoa on 3/15/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import UIKit

class SubCategoryVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var services: [ServiceData] = [ServiceData]()
    var navTitle = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        title = navTitle
        
    }
    
    
    // get main - subcatergory
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let descriptionVC = segue.destination as? DescriptionVC{
            if let data = sender as? [String:Any]{
                if let main = data["main"] as? String{
                    descriptionVC.mainService = main
                }
                if let sub = data["sub"] as? String{
                    descriptionVC.subService = sub
                }
            }
        }
    }
}

extension SubCategoryVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "SubCategoryToDescription", sender:
            ["main": navTitle ,
             "sub": services[indexPath.row].name ] )
    }
}

extension SubCategoryVC: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SubCategoryCell", for: indexPath) as? SubCategoryCell{
            cell.service = services[indexPath.row]
            return cell
        }
        else{
            return UITableViewCell()
        }
        
    }

}
