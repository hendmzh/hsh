//
//  ProximityManager.swift
//
//
//  Created by Hend Alzahrani on 2/21/18.
//

import Foundation

protocol ProximityManagerDelegate: class {
    func proximityManager(_ proximityManager: ProximityManager, didUpdateBeaconsInRange identifiers: Set<String>)
    func proximityManager(_ proximityManager: ProximityManager, didFailWithError: Error)
    func proximityManager(_ proximityManager: ProximityManager, didChange authorizationStatus: CLAuthorizationStatus)
}

extension ProximityManager {
    fileprivate struct Parameters {
        
        /// Desired distance from a beacon from which enter/exit events should be triggered, in meters.
        static let desiredDistance = 0.5
    }
}

/// Monitors proximity of beacons using Estimote Monitoring to inform which beacons are currently in range.

class ProximityManager: NSObject {
    
    weak var delegate: ProximityManagerDelegate?
    fileprivate lazy var monitoringManager: ESTMonitoringV2Manager = ESTMonitoringV2Manager(desiredMeanTriggerDistance: Parameters.desiredDistance, delegate: self)
    
    func startMonitoringProximity(identifiers: [String]) {
        self.monitoringManager.startMonitoring(forIdentifiers: identifiers)
    }
    
    func stopMonitoringProximity() {
        self.monitoringManager.stopMonitoring()
    }
    
    func requestAuthorization() {
        self.monitoringManager.requestAlwaysAuthorization()
    }
    
    fileprivate func updateBeaconsInRange() {
        let beaconIdentifiersInRange = self.monitoringManager.monitoredIdentifiers.filter { [weak self] (identifier) -> Bool in
            return self?.monitoringManager.stateForBeacon(withIdentifier: identifier) == .insideZone
        }
        
        let mySet = Set(beaconIdentifiersInRange)
        self.delegate?.proximityManager(self, didUpdateBeaconsInRange: mySet)
    }
    
    fileprivate func name(_ state: ESTMonitoringState) -> String {
        switch state {
        case .unknown: return "Unknown"
        case .insideZone: return "Inside"
        case .outsideZone: return "Outside"
        }
    }
}

extension ProximityManager: ESTMonitoringV2ManagerDelegate {
    
    func monitoringManager(_ manager: ESTMonitoringV2Manager, didFailWithError error: Error) {
        print("Monitoring failed: \(error.localizedDescription)")
        self.delegate?.proximityManager(self, didFailWithError: error)
    }
    
    func monitoringManager(_ manager: ESTMonitoringV2Manager, didDetermineInitialState state: ESTMonitoringState, forBeaconWithIdentifier identifier: String) {
        print("Determined initial state for \(identifier) - \(self.name(state)).")
        self.updateBeaconsInRange()
    }
    
    func monitoringManager(_ manager: ESTMonitoringV2Manager, didEnterDesiredRangeOfBeaconWithIdentifier identifier: String) {
        print("Entered range of \(identifier).")
        self.updateBeaconsInRange()
    }
    
    func monitoringManager(_ manager: ESTMonitoringV2Manager, didExitDesiredRangeOfBeaconWithIdentifier identifier: String) {
        print("Exited range of \(identifier).")
        self.updateBeaconsInRange()
    }
    
    func monitoringManager(_ manager: ESTMonitoringV2Manager, didChange authorizationStatus: CLAuthorizationStatus) {
        self.delegate?.proximityManager(self, didChange: authorizationStatus)
    }
}
