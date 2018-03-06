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
    
    var room: Environment!
    var appsArray: [Appliance]!
    
    // this variable decides which segue (if we get its type: selectedApp.type == door or any other?)
    var selectedApp: Appliance!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Appliances"
        appsArray = []

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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "doorSegue"{
            
            let doorVC = segue.destination as? ControlDoorViewController

                doorVC?.currentDoor = self.selectedApp //Or pass any
            
        }
        
        
        if segue.identifier == "ApplianceSegue"{
            
            let appVC = segue.destination as? ControlApplianceViewController
            
            appVC?.currentAppliance = self.selectedApp //Or pass any
            
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
    
    
    private func animate(views: [UIView], duration: TimeInterval, intervalDelay: TimeInterval) {
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            print("COMPLETED A CIRCLE")
        }
        
        var delay: TimeInterval = 0.0
        let interval = duration / TimeInterval(views.count)
        
        for view in views {
            
            let index = views.index(where: {$0 === view})

            selectedApp = appsArray[index!]
            
            let transform = view.transform
            
            UIView.animate(withDuration: interval, delay: delay, options: [.curveEaseIn], animations: {
                
                view.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
                
            }, completion: { (finished) in
                
                UIView.animate(withDuration: interval, delay: 0.0, options: [.curveEaseIn], animations: {
                    view.transform = transform
                    
                }, completion: { (finished) in
                    
                    
                })
            })
            
            delay += (interval * 2.0) + intervalDelay
        }
        CATransaction.commit()
    }
    
    func createAppliancesViews(appliances: [Appliance]){
        
        let size = appliances.count
        print("apps num : ")
        print(size)
        
        var apps: [UIImage] = []

        for object in appliances {
            
            self.appsArray.append(object)
            
            if(object.name == "Light"){
                print("appended light")
                apps.append(UIImage(named: "light.png")!)
            }
            else if(object.name == "Television"){
                print("appended tv")
                apps.append(UIImage(named: "tv.png")!)
            }
            else if(object.name == "Curtain"){
                print("appended Curtain")
                apps.append(UIImage(named: "curtain.png")!)
            }
            else if(object.name == "Oven"){
                print("appended oven")
                apps.append(UIImage(named: "oven.png")!)
            }
        }
        
        
        func makeView(index: Int) -> UIImageView {
            let view = UIImageView()
            view.image = apps[index]
            view.frame = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
            self.view.addSubview(view)
            return view
        }
        
        var imageViews = [UIImageView]()
        
        for i in 0...size-1 {
            imageViews.append(makeView(index: i))
        }
        
        
        let locationForView = { (angle: CGFloat, center: CGPoint, radius: CGFloat) -> CGPoint in
            let angle = angle * CGFloat.pi / 180.0
            return CGPoint(x: center.x - radius * cos(angle), y: center.y + radius * sin(angle))
        }
        
        for i in 0..<imageViews.count {
            let center = self.view.center
            let radius = ((150.0 + imageViews[i].bounds.size.width) / 2.0)
            let count = imageViews.count
            imageViews[i].center = locationForView(((360.0 / CGFloat(count)) * CGFloat(i)) + 90.0, center, radius)
        }
        
          self.animate(views: imageViews.reversed(), duration: 7.0, intervalDelay: 0.5)        
    }

}
