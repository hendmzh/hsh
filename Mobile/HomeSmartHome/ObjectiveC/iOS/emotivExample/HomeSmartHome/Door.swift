//
//  Door.swift
//  MentalCommand
//
//  Created by سيما on 2/22/18.
//

import Foundation
import Alamofire
import SwiftyJSON

struct Door {
    
    let id: Int!
    let state: String!
    let room: Int!
    
    //MARK: Inits
    init(id: Int, state: String, room: Int) {
        self.id = id
        self.state = state
        self.room = room
        
    }
    
    static func getCurrentDoors(room: String){
        
        var doorList: [Door] = []
        Alamofire.request(GlobalVariables.server+"/doors/"+room).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                // print(swiftyJsonVar)
                
                for (_,dict) in swiftyJsonVar {
                    let door = Door(id: dict["id"].intValue, state: dict["state"].stringValue, room: dict["room"].intValue)
                    doorList.append(door)
                    
                }
                //print
                for object in doorList {
                    print("ID: \(object.id), STATE: \(object.state)")
                }
            }
        }
        
    }
    
}

