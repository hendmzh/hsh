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
    
    
    //MARK: Inits
    init(id: Int, state: String) {
        self.id = id
        self.state = state
    }
    
    static func getCurrentDoors(){
        Alamofire.request(GlobalVariables.server+"/doors").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                print(swiftyJsonVar)
            }
        }
        
    }
    
    
    
}
