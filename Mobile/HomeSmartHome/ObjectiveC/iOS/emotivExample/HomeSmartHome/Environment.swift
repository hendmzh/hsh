//
//  Environment.swift
//  MentalCommand
//
//  Created by Hend Alzahrani on 2/21/18.
//

import Foundation
import Alamofire
import SwiftyJSON


struct Environment {
    
    let roomName: String!
    let roomID: String!

    static func getRoom(sensorID: String, completion: @escaping (_ room: Environment) -> ()){

        Alamofire.request(GlobalVariables.server+"/rooms/"+sensorID, method: .get)
            .responseJSON { response in
                if((response.result.value) != nil) {
                    let jsonVar: JSON = JSON(response.result.value!)
                    if(jsonVar["error"] == JSON.null){
                        let name = jsonVar["Room"].stringValue
                        let roomID = jsonVar["ID"].stringValue
                        let foundRoom = Environment.init(roomName: name, roomID: roomID)
                        completion(foundRoom)
                    }
                    else{
                        completion(Environment.init(roomName: "", roomID: ""))
                    }
                    
                }
        }
    
    }
    
    
}
