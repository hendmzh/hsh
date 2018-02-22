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

    static func getRoom(sensorID: String, completion: @escaping (_ roomName: String) -> ()){

        Alamofire.request(GlobalVariables.server+"/rooms/"+sensorID, method: .get)
            .responseJSON { response in
                if((response.result.value) != nil) {
                    let jsonVar: JSON = JSON(response.result.value!)
                    if(jsonVar["error"] == JSON.null){
                        let foundRoom = jsonVar["Room"].stringValue
                        completion(foundRoom)
                    }
                    else{
                        completion("")
                    }
                    
                }
        }
    
    }
    
    
}
