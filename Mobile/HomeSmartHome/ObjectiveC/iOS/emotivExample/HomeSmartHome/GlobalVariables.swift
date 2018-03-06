//
//  GlobalVariables.swift
//  MentalCommand
//
//  Created by Hend Alzahrani on 2/12/18.
//

import Foundation

struct GlobalVariables {
    static var serverip = "172.20.10.5"
    static var server = "http://172.20.10.5:5000"
    static var userInfo = User.init(username: "")
    public static var command = "Blank"
}

@objc(AppConstants) class AppConstant: NSObject{
    @objc func command(com: String){
        GlobalVariables.command = com
    }
}
