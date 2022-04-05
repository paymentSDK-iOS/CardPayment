//
//  UserModel.swift
//  PaymentFramework
//
//  Created by Exaltare Technologies Pvt LTd. on 04/04/22.
//

import Foundation

class UserModel{
    
    //MARK: Shared Instance
    static var shared:UserModel = UserModel()
    
    // MARK: Inputs
    var apikey:String?
    var token:String?
    
    var email:String? = nil
    var country:String?
    var currency:String?
    var amount:Int = 0
    var endpoint:String?
}
