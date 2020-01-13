//
//  BGBaseVC.swift
//  BogoArtistApp
//
//

import UIKit
import CarbonKit

//Define enum for Switching Controllers
enum exploreSegment : Int {
    case dashboard = 1
    case schedule
    case profile
}

//Intialize controllers with raw Value
var currentTab      = exploreSegment(rawValue: 1)
var dashboardVC     : UIViewController?
var schedule        : UIViewController?
var profile         : UIViewController?

//Global Object of CarbonKit
var carbonTabSwipeNewNavigation : CarbonTabSwipeNavigation?

class BGBaseVC: UIViewController, CarbonTabSwipeNavigationDelegate {

    @IBOutlet var tabContainerView : UIView!
    @IBOutlet var containerView    : UIView!
    @IBOutlet var scheduleButton   : UIButton!
    @IBOutlet var dashBoardButton  : UIButton!
    @IBOutlet var profileButton    : UIButton!
    
    //MARK:- =====================>View Lifecycle Methods<=================//
    override func viewDidLoad() {
        super.viewDidLoad()
        self.defaultSetup()
        let items = ["Dashboard", "Schedule","Profile"]
        carbonTabSwipeNewNavigation = CarbonTabSwipeNavigation(items: items, delegate: self)
        carbonTabSwipeNewNavigation?.insert(intoRootViewController: self, andTargetView: self.containerView)
        carbonTabSwipeNewNavigation?.view.frame = self.containerView.bounds
        carbonTabSwipeNewNavigation?.setTabBarHeight(0)
        carbonTabSwipeNewNavigation?.toolbar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- ==================>Defautlt Setup <=================//
    func defaultSetup() {
        if UIScreen.main.bounds.width == 320{
            dashBoardButton.titleLabel?.font = UIFont.init(name: "Roboto", size: 13)
            scheduleButton.titleLabel?.font = UIFont.init(name: "Roboto", size: 13)
            profileButton.titleLabel?.font = UIFont.init(name: "Roboto", size: 13)
        }
        dashboardVC = storyBoardForName(name: "Main").instantiateViewController(withIdentifier: "BGDashboardVC")
        schedule = storyBoardForName(name: "Main").instantiateViewController(withIdentifier:"BGSchduleVC" )
        profile = storyBoardForName(name: "Main").instantiateViewController(withIdentifier:"BGProfileVC" ) 
    }
    
    //MARK:- =====================>Carbonkit Delegate Methods<=================//
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didMoveAt index: UInt) {
        self.deselectTab()
  
        if let view = self.tabContainerView.viewWithTag(Int(index + 11)) {
            view.backgroundColor = #colorLiteral(red: 0.5457286835, green: 0.7214295864, blue: 0.2108607888, alpha: 1)
        }
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        // return viewController at index
        self.deselectTab()
        switch index {
        case 0:
            if let view = self.tabContainerView.viewWithTag(Int(10)) {
                view.backgroundColor = #colorLiteral(red: 0.5457286835, green: 0.7214295864, blue: 0.2108607888, alpha: 1)
            }
            return dashboardVC!
        case 1:
            if let view = self.tabContainerView.viewWithTag(Int(11)) {
                view.backgroundColor = #colorLiteral(red: 0.5457286835, green: 0.7214295864, blue: 0.2108607888, alpha: 1)
            }
            return schedule!
        case 2:
            if let view = self.tabContainerView.viewWithTag(Int(12)) {
                view.backgroundColor = #colorLiteral(red: 0.5457286835, green: 0.7214295864, blue: 0.2108607888, alpha: 1)
            }
            return profile!
        default :
            return profile!
        }
    }
    
    func deselectTab(){
        for i in 1...3 {
            let button = self.tabContainerView.viewWithTag(i) as! UIButton
            button.isSelected = false
            if let view = self.tabContainerView.viewWithTag(i+10) {
                view.backgroundColor = UIColor.clear
            }
        }
    }
    
    //MARK:- =====================>UIButtonAction Methods<=================//
    @IBAction func commonButtonAction(_ sender: Any) {
        carbonTabSwipeNewNavigation?.setCurrentTabIndex(UInt((sender as AnyObject).tag - 1), withAnimation: true)
    }
}
