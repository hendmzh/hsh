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
    
    
    //MARK: Inits
    init(id: Int, name: String, state: String) {
        self.id = id
        self.name = name
        self.state = state
    }
    
    static func getCurrentAppliances(){
        Alamofire.request(GlobalVariables.server+"/appliances").responseJSON { (responseData) -> Void in
                                if((responseData.result.value) != nil) {
                                    let swiftyJsonVar = JSON(responseData.result.value!)

                                    print(swiftyJsonVar)
                                }
                                }

    }
    
    
    
}
