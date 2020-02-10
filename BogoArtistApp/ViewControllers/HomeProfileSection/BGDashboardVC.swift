//
//  BGDashboardVC.swift
//  BogoArtistApp
//
//

import UIKit
import CarbonKit

//Intialize controllers with raw Value
var currentSelectedTab      = exploreSegment(rawValue: 1)
var upcomingVC              : UIViewController?
var paymentVC               : UIViewController?

//Global Object of CarbonKit
weak var carbonTabSwipeDashNavigation : CarbonTabSwipeNavigation?;

class BGDashboardVC: UIViewController,CarbonTabSwipeNavigationDelegate{
    
    @IBOutlet weak var dashBoardTableView   : UITableView!
    @IBOutlet weak var upComingButton       : UIButton!
    @IBOutlet weak var paymentButton        : UIButton!
    //UIView Outlet
    @IBOutlet var containerView             : UIView!
    @IBOutlet var headerView                : UIView!
    
    // MARK:- ============ View Lifecycle Methods ==============//
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async { [weak self] in
            guard let this = self else { return }
            this.defaultSetup()
            let items = ["Dashboard", "Schedule"]
            this.upComingButton.titleLabel?.adjustsFontSizeToFitWidth = true
            this.paymentButton.titleLabel?.adjustsFontSizeToFitWidth = true
            carbonTabSwipeDashNavigation = CarbonTabSwipeNavigation(items: items, delegate: this)
            carbonTabSwipeDashNavigation?.insert(intoRootViewController: this, andTargetView: this.containerView)
            carbonTabSwipeDashNavigation?.view.frame = this.containerView.bounds
            carbonTabSwipeDashNavigation?.setTabBarHeight(0)
            carbonTabSwipeDashNavigation?.toolbar.isHidden = true
            this.navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func defaultSetup() {
        upcomingVC = storyBoardForName(name: "Main").instantiateViewController(withIdentifier: "BGUpcomingRequestVC")
        paymentVC = storyBoardForName(name: "Main").instantiateViewController(withIdentifier:"BGPaymentVC" )
    }
    
    // MARK:- ============ CarbonKit Delegate Methods ==============//
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didMoveAt index: UInt) {
        self.deselectTab()
        if let view = self.headerView.viewWithTag(Int(index + 11)) {
            view.backgroundColor = #colorLiteral(red: 0.9020699263, green: 0.04277668148, blue: 0.41734761, alpha: 1)
        }
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        self.deselectTab()
        switch index {
        case 0:
            if let view = self.headerView.viewWithTag(Int(11)) {
                view.backgroundColor = #colorLiteral(red: 0.9020699263, green: 0.04277668148, blue: 0.41734761, alpha: 1)
            }
            return upcomingVC!
        case 1:
            if let view = self.headerView.viewWithTag(Int(12)) {
                view.backgroundColor = #colorLiteral(red: 0.9020699263, green: 0.04277668148, blue: 0.41734761, alpha: 1)
            }
            return paymentVC!
        default :
            return paymentVC!
      }
    }
    
    func deselectTab(){
        for i in 1...2 {
            let button = self.headerView.viewWithTag(i) as! UIButton
            button.isSelected = false
            if let view = self.headerView.viewWithTag(i+10) {
                view.backgroundColor = UIColor.clear
            }
        }
    }
    
    @IBAction func commonButtonAction(_ sender: Any) {
        carbonTabSwipeDashNavigation?.setCurrentTabIndex(UInt((sender as AnyObject).tag - 1), withAnimation: true)
    }
}
