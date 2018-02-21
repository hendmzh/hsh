//
//  BeaconsViewController.swift
//
//
//  Created by Hend Alzahrani on 2/21/18.
//

import Foundation
import UIKit

// Adds UI-related methods to ViewController class.
@available(iOS 9.0, *)
extension AppliancesViewController {
    func updateBeaconZoneViews(beaconIdentifiersInRange identifiersInRange: Set<String>) {
        UIView.animate(withDuration: 0.2) {
            
            self.beaconIdentifiers.forEach({ (identifier) in
                guard let zoneView = self.zoneViewByBeaconIdentifier[identifier] else { return }
                
                if(identifiersInRange.isEmpty){
                    self.currentRoom.text = "We don't know where you are :("
                }
                
                if(identifiersInRange.contains(identifier)){
                    
                    Environment.getRoom(sensorID: identifier, completion: { (room) in
                        if(room != ""){
                        print("in room: "+room)
                        self.currentRoom.text = "You are inside: "+room
                        }
                    })
                }
            })
        }
    }
    
    func hideViewIfNeeded(view: UIView, shouldBeHidden hidden: Bool) {
        if view.isHidden != hidden {
            view.isHidden = hidden
        }
    }
    
    func goToAppLocationServicesSettings() {
        guard let appLocationServicesSettings = URL(string: UIApplicationOpenSettingsURLString) else { return }
        UIApplication.shared.openURL(appLocationServicesSettings)
    }
    
    func addBeaconZoneViews(colorByBeaconIdentifier: [String: UIColor]) {
        for identifier in colorByBeaconIdentifier.keys {
            
            let zoneView = UIView()
            zoneView.translatesAutoresizingMaskIntoConstraints = false
            zoneView.backgroundColor = colorByBeaconIdentifier[identifier]
            
            let beaconImageView = UIImageView(image: UIImage(named: "Beacon"))
            beaconImageView.contentMode = .scaleAspectFit
            beaconImageView.translatesAutoresizingMaskIntoConstraints = false
            zoneView.addSubview(beaconImageView)
            
            let identifierLabel = UILabel()
            identifierLabel.translatesAutoresizingMaskIntoConstraints = false
            identifierLabel.textAlignment = .center
            identifierLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
            identifierLabel.numberOfLines = 0
            identifierLabel.textColor = UIColor.white
            identifierLabel.text = identifier
            zoneView.addSubview(identifierLabel)
            
            // Setup constraints
            let verticalAlignmentConstraint = NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-24-[beacon]-8@999-[identifier]-|",
                options: [.alignAllCenterX],
                metrics: nil,
                views: ["beacon": beaconImageView, "identifier": identifierLabel])
            NSLayoutConstraint.activate(verticalAlignmentConstraint)
            beaconImageView.centerXAnchor.constraint(equalTo: zoneView.centerXAnchor).isActive = true
            
            self.zoneViewByBeaconIdentifier[identifier] = zoneView
            self.stackView.addSubview(zoneView)
            zoneView.isHidden = true
        }
    }
    
    func presentFetchingColorsFailedAlert() {
        let alert = UIAlertController(title: "Location Detection failed", message: "Check your internet connection.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentMonitoringFailedAlert() {
        let alert = UIAlertController(title: "Monitoring failed", message: "Make sure bluetooth is on and the app has permission to use it.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func presentLocationServicesPermissionsAlert() {
        let alert = UIAlertController(title: "Location Services Permissions", message: "Your app location services permission is insufficient. Change it to Always or WhenInUse", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Go to settings", style: UIAlertActionStyle.default, handler: { (action) in
            self.goToAppLocationServicesSettings()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
