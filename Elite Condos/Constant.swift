//
//  Constant.swift
//  Elite Condos
//
//  Created by Khoa on 11/14/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import Foundation

let APP_NAME = "Elite Condos"


let SHADOW_GRAY = 120.0 / 255.0
let DEFAULT_CUSTOMER_AVATAR = "https://firebasestorage.googleapis.com/v0/b/elite-condos.appspot.com/o/customer_avatar%2Favatar-user.png?alt=media&token=e39561de-252b-47df-99a2-ee860ca9a995"

let DEFAULT_SUPPLIER_LOGO = "https://firebasestorage.googleapis.com/v0/b/elite-condos.appspot.com/o/supplier_images%2Felite_condos_supplier_default.jpg?alt=media&token=79743a3b-a5d4-47d1-afd0-f8dad2e9ff07"



let CUSTOMER_ID = "CUSTOMER_ID"




var SUPPLIER_ID = "SUPPLIER_ID"
var SUPPLIER_NAME = "SUPPLIER_NAME"
let USER_ID = "USER_ID"

var token = ""


enum ORDER_STATUS{
    case NOTACCEPTED
    case ONGOING
    case CANCEL
    case FINISHED
    case REJECTED
}


//var picking_orderId = ""
//var picking_customerId = ""

func getCurrentTime() -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
    let dateInFormat = dateFormatter.string(from: Date())
    return dateInFormat
}

func getTimeStringFrom(str: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy HH:mm"
    let date = formatter.date(from: str)
    let dateInFormat = formatter.string(from: date ?? Date())
    return dateInFormat
    
    
}






