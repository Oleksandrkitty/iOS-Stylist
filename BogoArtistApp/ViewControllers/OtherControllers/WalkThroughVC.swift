//
//  WalkThroughVC.swift
//  ProjectTemplate
//
//

import UIKit

class WalkThroughVC: UIViewController {
    @IBOutlet weak var getStartedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func dismissWalkThrough() {
        if USERDEFAULT.value(forKey: pArtistID) == nil || UserDefaults.standard.value(forKey: pArtistID) as! String == "" {
            let loginVC = UIStoryboard.init(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "BGLoginVC") as! BGLoginVC
            self.navigationController?.pushViewController(loginVC, animated: true)
            
        } else {
            let loginVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BGBaseVC") as! BGBaseVC
            self.navigationController?.pushViewController(loginVC, animated: true)
        }
    }
    
    // MARK:- IBAction Method
    @IBAction func getStartedButtonAction(_ sender: UIButton) {
        dismissWalkThrough()
    }
    
    // MARK: - Memory Managment >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
