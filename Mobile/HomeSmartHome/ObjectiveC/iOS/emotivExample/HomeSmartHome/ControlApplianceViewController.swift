//
//  ControlApplianceViewController.swift
//  MentalCommand
//
//  Created by Hend Alzahrani on 3/5/18.
//

import UIKit

class ControlApplianceViewController: UIViewController {
    
    
    @IBOutlet var turnonImage: UIImageView!
    @IBOutlet var increaseImage: UIImageView!
    @IBOutlet var turnoffImage: UIImageView!
    @IBOutlet var decreaseImage: UIImageView!
    
     var currentAppliance: Appliance!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageViews = [turnonImage, increaseImage, turnoffImage, decreaseImage]
        
        self.animate(views: imageViews as! [UIView], duration: 7.0, intervalDelay: 0.5)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func animate(views: [UIView], duration: TimeInterval, intervalDelay: TimeInterval) {
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            print("COMPLETED A CIRCLE")
        }
        
        var delay: TimeInterval = 0.0
        let interval = duration / TimeInterval(views.count)
        
        for view in views {
            let transform = view.transform
            
            UIView.animate(withDuration: interval, delay: delay, options: [.curveEaseIn], animations: {
                
                view.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
                
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

}
