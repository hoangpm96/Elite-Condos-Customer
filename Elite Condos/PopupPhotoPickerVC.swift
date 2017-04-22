//
//  PopupPhotoPickerVC.swift
//  Elite Condos
//
//  Created by Khoa on 3/17/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import UIKit

class PopupPhotoPickerVC: UIViewController {
    
    @IBOutlet weak var subView: UIView!
    
    
    let imagePicker: UIImagePickerController = UIImagePickerController()
    var subViewTapped = false
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        subView.layer.cornerRadius = 10
        subView.clipsToBounds = true
        
     
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
       
        if touches.first?.view != subView{
            // subView is your view
            dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func deleteAllBtnPressed(_ sender: Any) {
        Api.Order.images = []
        collectionView.reloadData()
    }
   
}


extension PopupPhotoPickerVC: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if Api.Order.images.count  == 0 {
            return 1
        }
        else {
            return  Api.Order.images.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopupPhotoCell", for: indexPath) as! PopupPhotoCell
        
        guard Api.Order.images != nil else {
            return cell
        }
        
        if indexPath.row == Api.Order.images.count {
            let img = UIImage(named: "add.png")
            cell.configureCell(img: img!)
        }
        else {
            let img = Api.Order.images[indexPath.row]
            cell.configureCell(img: img)
        }
        
        return cell
        
    }
}

extension PopupPhotoPickerVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard Api.Order.images != nil else {
            return 
        }
        
        if indexPath.row == Api.Order.images.count {
            present(imagePicker, animated: true, completion: nil)
        }
    }
}
extension PopupPhotoPickerVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.width / 3 - 2
        print(size)
        return CGSize(width: size, height: size)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
}
extension PopupPhotoPickerVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage{
            Api.Order.images.append(img)
            collectionView.reloadData()
        }
        dismiss(animated: true, completion: nil)
    }
    
}
