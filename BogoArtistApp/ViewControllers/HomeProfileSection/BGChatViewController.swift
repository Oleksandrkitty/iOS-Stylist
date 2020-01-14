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

    var messages = [BGMessageInfo]()

    // either stylistId should be not null or stylist.id should be not -1
    var stylist: BGStylistInfo?
    var stylistId: String?

    var bookingId = ""
    var clientId = "" // currently is not used. was used before API update

    var messageArray = ["What's goin on"]
    var messageString = ""
    var keyBoardHeight = CGFloat()
    var isFromBooking: Bool = false
    var pageNo: Int = 1
    var maxPageNo: Int = 1
    var totalCount: Int = 1
    var refreshControl: UIRefreshControl!

    // MARK:- View LifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setShadowview(newView: baseContainerView)
        callWebApiToGetChatHistory()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        APPDELEGATE.isChatOnTop = true
        APPDELEGATE.threadId = bookingId
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let rectShape = CAShapeLayer()
        rectShape.path = UIBezierPath(roundedRect: subHeaderView.bounds, byRoundingCorners: [.topRight, .topLeft], cornerRadii: CGSize(width: 5, height: 5)).cgPath
        subHeaderView.layer.mask = rectShape
    }

    // MARK:- Initial Setup Method
    func setUpView() {
        messageTextView.placeholder = "Your message"
        messageTextView.placeholderColor = UIColor.gray
        messageTextView.delegate = self
        self.artistName.text = "\(stylist?.firstName ?? "") \(stylist?.lastName ?? "")"
        
//        let url = client
//        self.artistImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "profile_default") , options: .refreshCached)
        
        
        // self.dateLabel.text = "\(booking.bookingDate) @ \(booking.bookingTime)"
        
        //Pull Down Refreshment
        refreshControl .addTarget(self, action: #selector(BGChatViewController.refresh), for: UIControl.Event.valueChanged)
        if #available(iOS 10.0, *) {
            chatTableView.refreshControl = refreshControl
        } else {
            chatTableView.addSubview(refreshControl)
        }
        //notifiacation to manage keyboard
        //APPDELEGATE.threadId = isFromNotification ? bookingID : userInfoObj.bookingID
        APPDELEGATE.isChatOnTop = true

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown), name: UIResponder.keyboardWillShowNotification, object: nil);

        //add gesture to tableView to dismiss keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapOnTable))
        chatTableView.addGestureRecognizer(tap)
    }
    
    @objc func refresh(_ sender: Any) {
        callWebApiToGetChatHistory()
        refreshControl.endRefreshing()
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
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]

        if message.stylist != nil {
            let receiverCell = tableView.dequeueReusableCell(withIdentifier: "BGChatReceivedTableViewCell", for: indexPath) as! BGChatReceivedTableViewCell
            receiverCell.messageBodyLabel.text = message.text
            let userImageUrl = URL(string: message.stylist?.image ?? "")
            receiverCell.profileImageView.sd_setImage(with: userImageUrl, placeholderImage: UIImage(named: "placeHolderImg"))
            receiverCell.timeLabel.text = message.created_at
            return receiverCell
        } else {
            let senderCell = tableView.dequeueReusableCell(withIdentifier: "BGChatSendTableViewCell", for: indexPath) as! BGChatSendTableViewCell
            senderCell.messageBodyLabel.text = message.text
            let userImageUrl = URL(string: message.client?.profilePicUrl ?? "")
            senderCell.profileImage.sd_setImage(with: userImageUrl, placeholderImage: UIImage(named: "service_place"))
            senderCell.timeLabelSend.text = message.created_at
            return senderCell
        }
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
        if textView.text.trimWhiteSpace.length > 0 {
            messageTextView.placeholder = ""
            messageString = textView.text.trimWhiteSpace
        } else {
            messageTextView.placeholder = "Your message"
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        messageTextView.placeholder = textView.text.trimWhiteSpace.length > 0 ? "" : "Your message"
        UIView.animate(withDuration: 0.3) {
            self.baseViewContainerbottom.constant = 10
            self.view.layoutIfNeeded()
        }
    }

    // MARK:- IBAction Methods
    @IBAction func sendButtonAction(_ sender: UIButton) {
        if messageString.length > 0 {
            let chatListInfo = BGChatInfoModel()
            // chatListInfo.strUserImage = (UserDefaults.standard.value(forKey: "userProfilePic") as AnyObject) as! String
            chatListInfo.isSelfMessage = true
            chatListInfo.strMessageText = messageString
            chatListInfo.strUserId = currentUserId()
            // chatListInfo.strMessageTimeStamp = "\(NSDate().timeIntervalSince1970)"

            chatListInfo.strMessageTimeStamp = String(format: "%ld", "\(NSDate().timeIntervalSince1970)")

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy HH:mm a"
            chatListInfo.strMessageDate = dateFormatter.string(from: Date())

            chatListInfo.strBookingId = bookingId
            callApiToSendMessage()
        } else {
            AlertController.alert(message: "Please enter the message.")
        }
    }
    
    @IBAction func crossButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        APPDELEGATE.threadId = ""
        APPDELEGATE.isChatOnTop = false
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "bubbleRemove"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }

    func callApiToSendMessage() {
        let params = [
            "messages": [
                "booking_id": bookingId,
                "client_id": currentUserId(),
                "stylist_id": stylistId ?? String(stylist?.id ?? 0),
                "text": messageTextView.text
            ]
        ]

        Api.requestJSON(.sendMessage(params: params), success: {
            response in
            self.messageTextView.text = ""
            self.refresh(self)
        })
    }

    func callWebApiToGetChatHistory() {
        let params = [
            "booking_id": bookingId,
//            "client_id": currentUserId(),
//            "stylist_id": stylistId ?? String(stylist?.id ?? 0),
        ]

        Api.requestMappableArray(.messages(params: params), success: {
            (messages: [BGMessageInfo]) in
            self.messages = messages
            self.chatTableView.reloadData()
        })
    }
    
    @objc func scrollToBottom() {
        if self.messages.count > 0 {
            chatTableView.scrollToRow(at: IndexPath(item: self.messages.count - 1, section: 0), at: .bottom, animated: false)
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
