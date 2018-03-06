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
    let type: ApplianceType
    
    
    //MARK: Inits
    init(id: Int, name: String, state: String, room: Int, type: ApplianceType) {
        self.id = id
        self.name = name
        self.state = state
        self.room = room
        self.type = type
    }
    
    static func getCurrentAppliances(room: String, completion: @escaping (_ appliences: [Appliance]) -> ()){
        
        var applianceList: [Appliance] = []
        
        Alamofire.request(GlobalVariables.server+"/appliances/"+room).responseJSON { (responseData) -> Void in if((responseData.result.value) != nil) {
            let swiftyJsonVar = JSON(responseData.result.value!)
            //print(swiftyJsonVar)
            
            for (_,dict) in swiftyJsonVar {
                
                var appType = ApplianceType.unknown
                
                if(dict["name"]=="Light"){
                   appType = ApplianceType.unknown
                }
                else if(dict["name"]=="Televesion"){
                   appType = ApplianceType.tv
                }
                else if(dict["name"]=="Curtain"){
                    appType = ApplianceType.curtain
                }
                else if(dict["name"]=="Oven"){
                    appType = ApplianceType.oven
                }
                else if(dict["name"]=="AC"){
                    appType = ApplianceType.ac
                }
                
                let appliance = Appliance(id: dict["id"].intValue, name: dict["name"].stringValue, state: dict["state"].stringValue, room: dict["room"].intValue, type: appType)
                applianceList.append(appliance)
            }
            //print
            for object in applianceList {
                print("ID: \(object.id), NAME: \(object.name), STATE: \(object.state)")
            }
            
            completion(applianceList)
            
            
            }
        }
        
    }
}

extension Appliance: Equatable { }

func ==(lhs: Appliance, rhs: Appliance) -> Bool {
    return lhs === rhs // === returns true when both references point to the same object
}
