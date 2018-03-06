//
//  LoginViewController.swift
//  MentalCommand
//
//  Created by Hend Alzahrani on 2/12/18.
//

import UIKit


class HomeViewController: UIViewController {
    
    var userInfo: User!
    
    var timer = Timer()
    var timer2 = Timer()
    var MCV: McViewController!
    var pushed:Bool!
    
    @IBOutlet var welcome: UILabel!
    @IBOutlet var profileView: UIView!
    @IBOutlet var fullname: UILabel!
    @IBOutlet var gender: UILabel!
    @IBOutlet var emergencyNum: UILabel!
    @IBOutlet var email: UILabel!
    
    @IBOutlet var call: UIButton!
    @IBOutlet var Environment: UIButton!
    
    var callSelected:Bool!
    var EnvironmentSelected:Bool!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //userInfo = GlobalVariables.userInfo
        //profileView.layer.cornerRadius = 5
       // welcome.text="Welcome, "+userInfo.first
        // Do any additional setup after loading the view.
        //fullname.text=userInfo.first + " "+userInfo.last
        
        //gender.text=userInfo.gender
        //emergencyNum.text=userInfo.contact
        //email.text=userInfo.email
        
        pushed = false
        callSelected = false
        
        timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.updateVal), userInfo: nil, repeats: true)
        timer.fire()
        
        timer2 = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.NavigateButtons), userInfo: nil, repeats: true)
        
        timer2.fire()
        
    }
    
        

    @objc
    func updateVal()
    {
        
        self.MCV = McViewController()
        if(MCV.globalcommand == "push" && !pushed)
        {
            pushed = true
            self.performSegue(withIdentifier: "EnvironmentSeque", sender: self)
        }
        
        print(MCV.globalcommand)
        //print(GlobalVariables.command)

        }
    
    @objc
    func NavigateButtons()
    {
        
       if(!callSelected)
       {
        //highlight call image
        let image = UIImage(named: "light") as! UIImage
        call.setBackgroundImage(image, for: UIControlState.normal)
        callSelected = true
        }
        else if(callSelected)
       {
        //highlight environment image
        let image = UIImage(named: "light") as! UIImage
        Environment.setBackgroundImage(image, for: UIControlState.normal)
        callSelected = false
        }
    }

    @IBAction func makeAPhoneCall() {
        if let url = URL(string: "tel://"+userInfo.contact), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func viewProfile(_ sender: Any) {
        animateIn()
    }
    
    @IBAction func closeView(_ sender: Any) {
        animateOut()
    }
    
    func animateIn() {
        self.view.addSubview(profileView)
        profileView.center = self.view.center
        
        profileView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        profileView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {

            self.profileView.alpha = 1
            self.profileView.transform = CGAffineTransform.identity
        }
        
    }
    
    func animateOut () {
        UIView.animate(withDuration: 0.3, animations: {
            self.profileView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.profileView.alpha = 0
            
        }) { (success:Bool) in
            self.profileView.removeFromSuperview()
        }
    }
    @IBAction func logout(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
        self.present(vc!, animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
