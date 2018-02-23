//
//  Appliance.swift
//  MentalCommand
//
//  Created by سيما on 2/22/18.
//

import Foundation
import Alamofire
import SwiftyJSON


struct Appliance {

    let id: Int!
    let name: String!
    let state: String!
    let room: Int!


    //MARK: Inits
    init(id: Int, name: String, state: String, room: Int) {
        self.id = id
        self.name = name
        self.state = state
        self.room = room
    }

    static func getCurrentAppliances(room: String){
        
        var applianceList: [Appliance] = []
        
        Alamofire.request(GlobalVariables.server+"/appliances/"+room).responseJSON { (responseData) -> Void in if((responseData.result.value) != nil) {
            let swiftyJsonVar = JSON(responseData.result.value!)
                //print(swiftyJsonVar)
            
            for (_,dict) in swiftyJsonVar {
                let appliance = Appliance(id: dict["id"].intValue, name: dict["name"].stringValue, state: dict["state"].stringValue, room: dict["room"].intValue)
                applianceList.append(appliance)
                
            }
            //print
            for object in applianceList {
                print("ID: \(object.id), NAME: \(object.name), STATE: \(object.state)")
            }
          
         
                }
        }

    }
 
    
}





