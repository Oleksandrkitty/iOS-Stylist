//
//  BGChatViewController.swift
//  BogoArtistApp
//
//

import UIKit



class BGChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    @IBOutlet var chatTableView             : UITableView!
    @IBOutlet var baseContainerView         : UIView!
    @IBOutlet var subHeaderView             : UIView!
    @IBOutlet var baseViewContainerbottom   : NSLayoutConstraint!
    @IBOutlet weak var messageTextView      : UITextView!
    @IBOutlet weak var artistImageView      : UIImageView!
    @IBOutlet weak var artistName           : UILabel!
    @IBOutlet weak var dateLabel            : UILabel!
    @IBOutlet weak var timeLabel            : UILabel!
    var messageList                         = [BGMessageInfo]()
    var messageInfo                         = BGMessageInfo()
    var messageString                       = ""
    var keyBoardHeight                      = CGFloat()
    var bookingID                           = String()
    var isfromAppointment                   = false
    var cleintID                            = String()
    var chatInfo                            = BGUpcomingInfoModel()
    var messageDate                         = String()
    var refreshControl                      =  UIRefreshControl()
    var artistID                            = String()
    
    var pageNo : Int                        = 1
    var maxPageNo                           = Int()
    var totalCount                          = Int()
    
    // MARK:- View LifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setShadowview(newView: baseContainerView)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadChatAPI), name: NSNotification.Name(rawValue: "ReloadChatAPI"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(chatDismiss), name: NSNotification.Name(rawValue: "ChatDismiss"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(callApiToget), name: NSNotification.Name(rawValue: "forgroundChat"), object: nil)
        
        callWebApiToGetDetail()
        self.callApiForFetchMessage(pageNo: 1 , isFromPullToRefresh: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        APPDELEGATE.isChatOnTop = true
        APPDELEGATE.threadId = bookingID
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func chatDismiss() {
        self.view.endEditing(true)
        APPDELEGATE.threadId = ""
        APPDELEGATE.isChatOnTop = false
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func callApiToget() {
        callWebApiToGetDetail()
    }
    
    @objc func reloadChatAPI() {
        self.callApiForFetchMessage(pageNo: 1 ,isFromPullToRefresh: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        APPDELEGATE.isChatOnTop = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let rectShape = CAShapeLayer()
        rectShape.path = UIBezierPath(roundedRect: subHeaderView.bounds, byRoundingCorners: [.topRight,.topLeft], cornerRadii: CGSize(width: 5, height: 5)).cgPath
        subHeaderView.layer.mask = rectShape
    }
    
    @objc func chatNotificationMethod(notification: NSNotification) {
        messageList.removeAll()
        if let info = notification.userInfo as? Dictionary<String,String> {
            artistID = info["msgArId"]!
            USERDEFAULT.set(artistID, forKey: pArtistID)
            bookingID = info["msgBkId"]!
        }
        callWebApiToGetDetail()
        callApiForFetchMessage(pageNo: 1 ,isFromPullToRefresh: false)
    }
    
    func dealloc() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK:- Initial Setup Method
    func setUpView() {
        messageTextView.placeholder = "Your message"
        messageTextView.placeholderColor = UIColor.gray
        messageTextView.delegate = self
        self.artistName.text = chatInfo.clientFirstName + " " + chatInfo.clientLastName
        self.artistImageView.sd_setImage(with:URL(string: chatInfo.clientImage ) , placeholderImage: UIImage(named: "profile_default") , options: .refreshCached)
        if(chatInfo.bookingDate == getFormatStringFromDate(date: Date())){
            self.dateLabel.text = "Today @ \(chatInfo.bookingTime)"
        }else if(chatInfo.bookingDate == getFormatStringFromDate(date:Date().addingTimeInterval(24 * 60 * 60))){
            self.dateLabel.text = "Tomorrow @ \(chatInfo.bookingTime)"
        }else{
            self.dateLabel.text = "\(chatInfo.bookingDate) @ \(chatInfo.bookingTime)"
        }
        //Pull Down Refreshment
        refreshControl .addTarget(self, action: #selector(BGChatViewController.refresh), for: UIControl.Event.valueChanged)
        if #available(iOS 10.0, *) {
            chatTableView.refreshControl = refreshControl
        } else {
            chatTableView.addSubview(refreshControl)
        }
        //notifiacation to manage keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown), name:UIResponder.keyboardWillShowNotification, object: nil);
        
        //add gesture to tableView to dismiss keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapOnTable))
        chatTableView.addGestureRecognizer(tap)
    }
    
    @objc func refresh(_ sender: Any) {
        if(self.pageNo < maxPageNo) {
            pageNo += 1
            callApiForFetchMessage(pageNo: pageNo, isFromPullToRefresh: true)
        }
        self.refreshControl.endRefreshing()
    }
    
    @objc func tapOnTable(){
        self.view.endEditing(true)
    }
    
    @objc func keyboardShown(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyBoardHeight = keyboardFrame.height
    }
    
    // MARK:- UITableView DataSource & Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let senderCell = tableView.dequeueReusableCell(withIdentifier: "BGChatSendTableViewCell", for: indexPath) as! BGChatSendTableViewCell
        let receiverCell = tableView.dequeueReusableCell(withIdentifier: "BGChatReceivedTableViewCell", for: indexPath) as! BGChatReceivedTableViewCell
        let infoObject = self.messageList[indexPath.row]
        if(self.messageList.count > 0){
            if infoObject.isSelfMessage != true{
                senderCell.messageBodyLabel.text = infoObject.message
                senderCell.timeLabelSend.text = infoObject.convertedDate
                senderCell.profileImage.sd_setImage(with:URL(string: self.chatInfo.clientImage ) , placeholderImage: UIImage(named: "profile_default") , options: .refreshCached)
                return senderCell
            }
            else {
                receiverCell.messageBodyLabel.text = infoObject.message
                receiverCell.timeLabel.text = infoObject.convertedDate
                receiverCell.profileImageView.sd_setImage(with:URL(string: self.messageInfo.strUserImage ) , placeholderImage: UIImage(named: "profile_default") , options: .refreshCached)
                return receiverCell
            }
        }
        return senderCell
    }
    
    //MARK:- UITextViewDelegate Methods
    func textViewDidBeginEditing(_ textView: UITextView){
        UIView.animate(withDuration: 0.3) {
            self.baseViewContainerbottom.constant = self.keyBoardHeight
            self.chatTableView.tableViewScrollToBottom(animated: false)
            self.view.layoutIfNeeded()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.trimWhiteSpace.length >  0 {
            messageTextView.placeholder = ""
        }else {
            messageTextView.placeholder = "Your message"
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        messageTextView.placeholder = textView.text.trimWhiteSpace.length > 0 ? "" : "Your message"
        messageString = textView.text.trimWhiteSpace
        messageInfo.message = textView.text.trimWhiteSpace
        UIView.animate(withDuration: 0.3) {
            self.baseViewContainerbottom.constant = 10
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK:- IBAction Methods
    @IBAction func sendButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if messageString.length > 0 {
            let chatListInfo = BGMessageInfo()
            chatListInfo.isSelfMessage = true
            chatListInfo.message = messageString
            self.messageList.append(chatListInfo)
            self.messageTextView.becomeFirstResponder()
            self.messageTextView.text = ""
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateString = dateFormatter.string(from:Date())
            let arryaSeprator = dateString.components(separatedBy: " ")
            chatListInfo.sepratedTime = getTimeForMessageSend(time: arryaSeprator[1])
            chatListInfo.messageDate = dateString
            chatListInfo.convertedDate = BGChatViewController.changeDateFormat(dateString: chatListInfo.messageDate) + " " + chatListInfo.sepratedTime
            messageTextView.placeholder = "Your message"
            self.callApiToSendMessage()
            self.chatTableView.reloadData()
        } else {
            AlertController.alert(message: "Please enter the message.")
        }
    }
    
    @IBAction func crossButtonAction(_ sender: UIButton) {
        APPDELEGATE.threadId = ""
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "bubbleRemove"), object: nil, userInfo: ["msgBkId": bookingID])
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- WebService Method
    func callApiForFetchMessage(pageNo : Int ,isFromPullToRefresh : Bool) {
        let dict = NSMutableDictionary()
        dict[pArtistID]     = USERDEFAULT.string(forKey: pArtistID)
        dict[pBookingID]    = bookingID
        dict["pageNo"]      =  String(format: "%d",pageNo) as AnyObject
        
        ServiceHelper.request(params: dict as! Dictionary<String, AnyObject>, method: .post, apiName: kAPINameGetMessageList, hudType: .smoothProgress) { (result, error, status) in
            
            if (error == nil) {
                if let response = result as? Dictionary<String, AnyObject> {
                    if(response.validatedValue("status", expected:"" as AnyObject)).boolValue{
                        
                        let data : Array<Dictionary<String, AnyObject>> = response.validatedValue("messages", expected: Array<Dictionary<String, AnyObject>>() as AnyObject) as! Array<Dictionary<String, AnyObject>>
                        
                        self.maxPageNo = response.validatedValue("totalPage", expected: 0 as AnyObject) as! Int
                        if self.pageNo == 1 {
                            self.messageList.removeAll()
                        }
                        self.messageList.insert(contentsOf: BGMessageInfo.getMessageList(list: data), at: 0)
                        
                        if self.messageList.count == 0{
                            
                        }else{
                            self.messageDate = (self.messageList.last?.messageDate)!
                        }
                        if !isFromPullToRefresh
                        {
                            self.perform(#selector(self.scrollToBottom), with: nil, afterDelay: 0.2)
                        }
                        self.chatTableView.reloadData()
                    }
                }
            }
            else {
                _ = AlertController.alert(title: "", message: "\(error!.localizedDescription)")
            }
        }
    }
    
    func callApiToSendMessage() {
        let dict = NSMutableDictionary()
        dict[pCleintID] = cleintID
        dict[pBookingID] = bookingID
        dict[pMessage] =  messageString
        ServiceHelper.request(params: dict as! Dictionary<String, AnyObject>, method: .post, apiName: kAPINameSendMessage, hudType: .smoothProgress) { (result, error, status) in
            
            if (error == nil) {
                
                if let response = result as? Dictionary<String, AnyObject> {
                    if(response.validatedValue(pStatus, expected:"" as AnyObject)).boolValue{
                    }
                }
            }
            else {
                _ = AlertController.alert(title: "", message: "\(error!.localizedDescription)")
            }
        }
    }
    
    func callWebApiToGetDetail() {
        let requestDic = NSMutableDictionary()
        requestDic["booking_id"] =  bookingID
        ServiceHelper.request(params: requestDic as! [String : Any], method: .post, apiName: bookingDetail, hudType: .simple) { (response, error, statusCode) in
            
            guard let result = response as? Dictionary<String, AnyObject> else{
                AlertController.alert(title: kError, message: (error?.localizedDescription)!)
                return
            }
            guard result.validatedValue(pStatus, expected: "" as AnyObject).boolValue == true else {
                AlertController.alert(message: result.validatedValue("message", expected: "" as AnyObject) as! String)
                return
            }
            let detailDict = result.validatedValue("data", expected:NSArray())
            
            if (detailDict.count > 0) {
                
                for rowItem in detailDict as! Array<Dictionary<String,Any>> {
                    
                    self.chatInfo.clientName = rowItem.validatedValue("client_Fname", expected: "" as AnyObject) as! String + " " + (rowItem.validatedValue("client_Lname", expected: "" as AnyObject) as! String)
                    
                    let bookingStatus = rowItem.validatedValue("bookingStatus", expected: "" as AnyObject) as! String
                    let fullalertString = "Your appointment has been canceled from by " + self.chatInfo.clientName
                    if bookingStatus == "cancel" ||   bookingStatus == "complete"{
                        AlertController.alert(title: "", message: fullalertString, buttons: ["Ok"], tapBlock: { (alert, index) in
                            self.dismiss(animated: false, completion: nil)
                        })
                    }
                    
                    self.chatInfo.clientImage = rowItem.validatedValue("client_pic", expected: "" as AnyObject) as! String
                    self.messageInfo.strUserImage = rowItem.validatedValue("artist_pic", expected:"" as AnyObject) as! String
                    self.artistName.text = self.chatInfo.clientName
                    self.artistImageView.sd_setImage(with:URL(string: self.chatInfo.clientImage ) , placeholderImage: UIImage(named: "profile_default") , options: .refreshCached)
                    var dateStr = rowItem.validatedValue("bookingDate", expected: "" as AnyObject) as! String
                    dateStr = getSubNameFromMonth(date: dateStr)
                    dateStr = dateStr.replaceString("\n", withString: " ")
                    let timeStr = getTimeWithAmPm(time: rowItem.validatedValue("bookingTime", expected: "" as AnyObject) as! String)
                    self.dateLabel.text = "\(dateStr) @ \(timeStr)"
                }
                self.chatTableView.reloadData()
            }
        }
    }
    
    @objc func scrollToBottom() {
        if self.messageList.count > 0 {
            chatTableView.scrollToRow(at: IndexPath(item:self.messageList.count-1, section: 0), at: .bottom, animated: true)
        }
    }
    
    //MARK:- Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    class func changeDateFormat(dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.date(from: dateString)
        formatter.dateFormat = "MMM dd, yyyy"
        if date != nil{
            return formatter.string(from: date!)
        }else{
            return ""
        }
    }
}
