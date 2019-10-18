//
//  BGVerificationVC.swift
//  BogoArtistApp
//
//

import UIKit

class BGVerificationVC: UIViewController {

    //MARK:- UIView LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
        NotificationCenter.default.post(name: Notification.Name("PostToPush"), object: nil )
    }

    //MARK:- Helper Method
    func initialSetup(){
        delay(delay: 3) {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    //MARK:- UIButton Actions
    @IBAction func verificationButtonAction(_ sender: UIButton) {

    }
    
    //MARK:- Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
