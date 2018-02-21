//
//  LoginViewController.swift
//  MentalCommand
//
//  Created by Hend Alzahrani on 2/12/18.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var connectBtn: UIButton!
    @IBOutlet var errorText: UILabel!
    
    @IBOutlet var settingsView: UIView!
    @IBOutlet var serverIP: UITextField!
    
    var userLogged: User!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.password.delegate = self;
        self.password.delegate = self;
        self.loginBtn.layer.cornerRadius = 5
        self.connectBtn.layer.cornerRadius = 5
        self.serverIP.text = GlobalVariables.serverip
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func login(_ sender: Any) {
        User.Login(user: username.text!, pass: password.text!){
            (user) -> Void in
            if(user.username == ""){
                self.errorText.text = "wrong username or password, please try again"
            }
            else{

                self.userLogged = user
                self.performSegue(withIdentifier: "homeSegue", sender: self)
            }
        }
    
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeSegue"{
            
            let navVC = segue.destination as? UINavigationController
          
            if let home = navVC?.viewControllers.first as? HomeViewController{
                home.userInfo = self.userLogged //Or pass any
            }
        }
    }
    
    @IBAction func showSettings(_ sender: Any) {
     animateIn()
    }
   
    @IBAction func connect(_ sender: Any) {
        GlobalVariables.server = "http://"+self.serverIP.text!+":5000"
        animateOut()
    }
    
    func animateIn() {
        self.view.addSubview(settingsView)
        settingsView.center = self.view.center
        
        settingsView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        settingsView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            
            self.settingsView.alpha = 1
            self.settingsView.transform = CGAffineTransform.identity
        }
        
    }
    
    func animateOut () {
        UIView.animate(withDuration: 0.3, animations: {
            self.settingsView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.settingsView.alpha = 0
            
        }) { (success:Bool) in
            self.settingsView.removeFromSuperview()
        }
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
