//
//  User.swift
//  MentalCommand
//
//  Created by Hend Alzahrani on 2/12/18.
//

import Foundation
import Alamofire
import SwiftyJSON


struct User {
    
    let username: String!
    let id: String!
    let first: String!
    let last: String!
    let gender: String!
    let email: String!
    let contact: String!
    
    
    //MARK: Inits
    init(username: String, id: String, first: String, last: String, gender: String, email: String, contact: String) {
        self.username = username
        self.id = id
        self.first = first
        self.last = last
        self.gender = gender
        self.email = email
        self.contact = contact
    }
    
    init(username: String) {
        self.username = username
        self.id = nil
        self.first = nil
        self.last = nil
        self.gender = nil
        self.email = nil
        self.contact = nil
    }
    
    static func Login(user: String, pass: String, completion: @escaping (_ user: User) -> ()){
        var una = ""
        var fna=""
        var lna=""
        var ema=""
        var cont=""
        var uid = ""
        var gen = ""
        
        print("trying login")
        let params = [
            "username": user,
            "password": pass]
            
        
        Alamofire.request(GlobalVariables.server+"/user_login", method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { response in
                if((response.result.value) != nil) {
                    let jsonVar: JSON = JSON(response.result.value!)
                    print("found response login")
                    if(jsonVar["error"] == JSON.null){
                        una = jsonVar["Username"].stringValue
                        fna = jsonVar["FName"].stringValue
                        lna = jsonVar["LName"].stringValue
                       ema = jsonVar["Email"].stringValue
                        uid = jsonVar["UserID"].stringValue
                        gen = jsonVar["Gender"].stringValue
                        cont = jsonVar["EmergencyPhone"].stringValue
                        let loggedUser =  User.init(username: una, id: uid ,first: fna, last: lna, gender: gen, email: ema, contact: cont)
                        
                        completion(loggedUser)
                    }
                    else{
                        print("not found")
                        let loggedUser =  User.init(username: "")
                        
                        completion(loggedUser)
                    }
                    
                }
        }
        
    }

}
