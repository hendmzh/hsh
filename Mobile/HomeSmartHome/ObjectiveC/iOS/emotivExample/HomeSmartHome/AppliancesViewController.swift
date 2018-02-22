//
//  AppliancesViewController.swift
//
//
//  Created by Hend Alzahrani on 2/21/18.
//

import UIKit


@available(iOS 9.0, *)
@available(iOS 9.0, *)
@available(iOS 9.0, *)
@available(iOS 9.0, *)
class AppliancesViewController: UIViewController {

    
    let beaconIdentifiers = ["d3377fb34c3c9928e623aa8809311b0c",
                             "d9d524b803fbd5529806f86571fc6211",
                             "ea249cfc85470f8ab8af63922a546f2e"]
    let cloudManager = CloudManager()
    let proximityManager = ProximityManager()
    var zoneViewByBeaconIdentifier = [String: UIView]()
    
    @IBOutlet weak var noBeaconsView: UIView!
    @IBOutlet var stackView: UIView!
    
    @IBOutlet var currentRoom: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    Appliance.getCurrentAppliances();
    Door.getCurrentDoors();
        
        
        
        self.proximityManager.requestAuthorization()
        self.updateBeaconZoneViews(beaconIdentifiersInRange: [])
        
        // Step 1: Pre-fetch content related to your beacons
        self.cloudManager.fetchColors(beaconIdentifiers: self.beaconIdentifiers) { (result) in
            
            switch result {
            case .error:
                self.presentFetchingColorsFailedAlert()
                return
                
            case .success(let colorByIdentifier):
                self.addBeaconZoneViews(colorByBeaconIdentifier: colorByIdentifier)
                self.proximityManager.delegate = self
            }
        }
    }
}

@available(iOS 9.0, *)
extension AppliancesViewController: ProximityManagerDelegate, ESTMonitoringV2ManagerDelegate {
    
    func proximityManager(_ proximityManager: ProximityManager, didUpdateBeaconsInRange identifiers: Set<String>) {
        
        // Step 3: Update UI dependant on which beacons are in range
        self.updateBeaconZoneViews(beaconIdentifiersInRange: identifiers)
    }
    
    func proximityManager(_ proximityManager: ProximityManager, didFailWithError: Error) {
        self.presentMonitoringFailedAlert()
    }
    
    
    func proximityManager(_ proximityManager: ProximityManager, didChange authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
            
        case .authorizedAlways, .authorizedWhenInUse:
            // Step 2: Start monitoring proximity of your beacons
            self.proximityManager.startMonitoringProximity(identifiers: self.beaconIdentifiers)
            print("Monitoring manager started monitoring")
            
        default:
            self.proximityManager.stopMonitoringProximity()
            self.presentLocationServicesPermissionsAlert()
        }
    }
    
    func monitoringManager(_ manager: ESTMonitoringV2Manager, didFailWithError error: Error) {
        print("Manager did fail with error: \(error.localizedDescription)")
    }

}
