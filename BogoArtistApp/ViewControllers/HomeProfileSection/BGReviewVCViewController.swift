//
//  BGReviewVCViewController.swift
//  BogoArtistApp
//
//

import UIKit
import HCSStarRatingView

class BGReviewVCViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    @IBOutlet weak var noReviewLabel    : UILabel!
    @IBOutlet weak var tableview        : UITableView!
    var reviewInfow                     = BGReviewList()
    var reviwListArray                  = [BGReviewList]()

    //MARK:- =============Viewlife Cycle Methods==============================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.callApiForGetReviewList()
        noReviewLabel.isHidden                      = true
        self.tableview.showsVerticalScrollIndicator = false
        self.tableview.estimatedRowHeight           = 114
        APPDELEGATE.isReviewOnTop                   = true
        NotificationCenter.default.addObserver(self, selector: #selector(reloadChatAPI), name: NSNotification.Name(rawValue: "ReloadReviewListApi"), object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        APPDELEGATE.isReviewOnTop = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func reloadChatAPI(){
        self.callApiForGetReviewList()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviwListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BGReviewCell", for: indexPath) as! BGReviewCell
        let reviewObj = reviwListArray[indexPath.row]
        cell.nameLabel.text = reviewObj.reviewerFullname
        cell.rateLabel.allowsHalfStars = true
        cell.rateLabel.value = CGFloat((reviewObj.rateValue as NSString).floatValue)
        cell.rateBottomNameLabel.text = reviewObj.review
        cell.profileImageView.sd_setImage(with:URL(string: reviewObj.reviewerImage ) , placeholderImage: UIImage(named: "profile_default") , options: .refreshCached)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableview.rowHeight
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    //MARK:- WebService Method
    /*
     Call service for event Creation*/
    
    func callApiForGetReviewList() {
        let dict = NSMutableDictionary()
        dict[pArtistID] = USERDEFAULT.value(forKey: pArtistID)
        ServiceHelper.request(params: dict as! Dictionary<String, AnyObject>, method: .post, apiName: kReviewList, hudType: .smoothProgress) { (result, error, status) in
            
            if (error == nil) {
                if let response = result as? Dictionary<String, AnyObject> {
                    let messageStatus = response.validatedValue(kMessageSchedule, expected: "" as AnyObject)
                    if messageStatus as! String == "No reviews records are found"{
                        AlertController.alert(message: messageStatus as! String )
                        self.noReviewLabel.isHidden = false
                        self.tableview.isHidden = true
                    }else{
                        self.noReviewLabel.isHidden = true
                        self.tableview.isHidden = false

                        let dataArray = response.validatedValue(kDataSchedule, expected: [] as AnyObject)
                        self.reviwListArray = BGReviewList.getReviewList(responseArray: dataArray as! Array<Dictionary<String, String>>)
                        self.tableview.reloadData()
                    }
                }
            }
            else {
                _ = AlertController.alert(title: "", message: "\(error!.localizedDescription)")
                
            }
        }
    }
}
