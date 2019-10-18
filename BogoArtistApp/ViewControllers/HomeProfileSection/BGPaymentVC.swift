//
//  BGPaymentVCViewController.swift
//  BogoArtistApp
//
//

import UIKit

enum CircleType {
    case period, booked, payDay
}

class BGPaymentVC: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var ring1            : UIView!
    @IBOutlet weak var ring2            : UIView!
    @IBOutlet weak var ring3            : UIView!
    @IBOutlet weak var detailsTableView : UITableView!
    @IBOutlet weak var periodLabel      : UILabel!
    @IBOutlet weak var bookedLabel      : UILabel!
    @IBOutlet weak var payDayLabel      : UILabel!
    
    var indicatorColor                  = UIColor()
    var selectedData                    = "$35"
    var maxDateOfMonth                  = 0
    var isFromUpcommingBooking          = false
    var isFromcupocomingPeriod          = false
    var isMainApiCalledForPayment       = false
    var isNoDateIsThere                 = true
    var payDays                         = 0
    var isInitialLoading                = false
    var paymentDict                     = BGPaymentInfoModel()
    var paymentDetails                  = [BGPaymentInfoModel]()
    var newPayment                      = [BGPaymentInfoModel]()
    
    @IBOutlet weak var headerViewTableHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var rings: [NSLayoutConstraint]!
   
    
    // MARK: - UIViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if kWindowWidth == 320 {
            
            
            if kWindowHeight < 500 {
                
                self.headerViewTableHeightConstraint.constant = 40
                
                for aRing in rings {
                    
                    aRing.constant = aRing.constant * 0.8
                }
            }
            else {
                
                self.headerViewTableHeightConstraint.constant = 60
            }
        }
        else if kWindowWidth == 375 {
            
            self.headerViewTableHeightConstraint.constant = 150
        }
        else {
            self.headerViewTableHeightConstraint.constant = 240
        }
        
        indicatorColor = #colorLiteral(red: 0.4853838682, green: 0.8248652816, blue: 0.1157580242, alpha: 1)
        
        self.detailsTableView.isHidden = true
        
        self.detailsTableView.register(BGSummaryTVCell.self, forCellReuseIdentifier: "BGSummaryTVCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
        let calendar = Calendar.current
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        let weekday = components.day
        
        // Calculate start and end of the current year (or month with `.month`):
        if #available(iOS 10.0, *) {
            let interval = calendar.dateInterval(of: .month, for: date)!
            maxDateOfMonth = calendar.dateComponents([.day], from: interval.start, to: interval.end).day!
        } else {
            // Fallback on earlier versions
        } //change year it will no of days in a year , change it to month it will give no of days in a current month
        // Compute difference in days:
        
        if weekday == 1 || weekday == 15 {
            payDays = 0
        }else if weekday! > 1 && weekday! < 15{
            payDays = 15 - weekday!
        }else if weekday! > 15 && weekday! <= maxDateOfMonth{
            payDays = (maxDateOfMonth + 1) - weekday!
        }
        callApiForPayment()
    }
    
    func setUpCircleData() {
        
        periodLabel.text = "$" + "\(paymentDict.totalEarning)"
        bookedLabel.text = "$" + "\(paymentDict.totalUpcomingPayment)"
        if isNoDateIsThere{
            payDays = 0 
        }
        payDayLabel.text = "\(payDays)" + " Days"
        
        drawBaseCircle(circleView: ring1, type: .period)
        drawBaseCircle(circleView: ring2, type: .booked)
        drawBaseCircle(circleView: ring3, type: .payDay)
    }
    
    func drawBaseCircle(circleView: UIView, type: CircleType) {
        var path: UIBezierPath!
        let baseCircleLayer = CAShapeLayer()
        
        path = UIBezierPath(arcCenter: CGPoint(x: circleView.frame.size.width/2, y: circleView.frame.size.height/2 + 5),
                            radius: circleView.frame.size.height/2,
                            startAngle: CGFloat(130.0).toRadians(),
                            endAngle: CGFloat(50.0).toRadians(),
                            clockwise: true)
        baseCircleLayer.path = path.cgPath
        baseCircleLayer.lineWidth = 5
        baseCircleLayer.strokeColor = RGBA(r: 240, g: 240, b: 240, a: 1).cgColor
        baseCircleLayer.fillColor = UIColor.clear.cgColor
        circleView.layer.addSublayer(baseCircleLayer)
        
        let demoView = BGCircularView(frame: CGRect(x: 0,
                                                    y: 0,
                                                    width: circleView.frame.size.width,
                                                    height: circleView.frame.size.height))
        switch type.hashValue {
        case 0:
            if !isNoDateIsThere{
                if paymentDict.totalEarning != 0 {
                    demoView.pathColor = RGBA(r: 123, g: 211, b: 55, a: 1)
                    circleView.addSubview(demoView)
                }
            }else{
                demoView.pathColor = RGBA(r: 240, g: 240, b: 240, a: 1)
            }
            
            break
        case 1:
            if !isNoDateIsThere{
                if paymentDict.totalUpcomingPayment != 0 {
                    demoView.pathColor = RGBA(r: 245, g: 171, b: 97, a: 1)
                    circleView.addSubview(demoView)
                }
            }else{
                demoView.pathColor = RGBA(r: 240, g: 240, b: 240, a: 1)
            }
            
            break
        case 2:
            if !isNoDateIsThere{
                if payDays != 0 {
                    demoView.pathColor = RGBA(r: 139, g: 137, b: 251, a: 1)
                    demoView.endAngle = (20 * payDays) + 130
                    circleView.addSubview(demoView)
                }
            }else{
                demoView.pathColor = RGBA(r: 240, g: 240, b: 240, a: 1)
            }
            break
        default:
            demoView.pathColor = RGBA(r: 240, g: 240, b: 240, a: 1)
            break
        }
    }
    
    // MARK: - UITableView Delegate and DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return paymentDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: BGSummaryTVCell = tableView.dequeueReusableCell(withIdentifier: "BGSummaryTVCell", for: indexPath) as! BGSummaryTVCell
        var tempObj = BGPaymentInfoModel()
        tempObj = paymentDetails[indexPath.row]
        let rectShape = CAShapeLayer()
        rectShape.bounds = cell.indicatorLabel.frame
        rectShape.position = cell.indicatorLabel.center
        rectShape.path = UIBezierPath(roundedRect: cell.indicatorLabel.bounds, byRoundingCorners: [.bottomLeft , .topLeft], cornerRadii: CGSize(width: 5, height: 5)).cgPath
        setShadowview(newView: cell.summaryView)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.indicatorLabel.layer.mask = rectShape
        cell.indicatorLabel.backgroundColor = indicatorColor
        if !self.isMainApiCalledForPayment{
            cell.contentLabel.text = tempObj.upcomingBookingDate
            cell.summaryLabel.text = tempObj.upcomingFullName
        }else{
            cell.contentLabel.text = tempObj.payment
            cell.summaryLabel.text = tempObj.firstName + " " + tempObj.lastName
        }
        return cell
    }
    
    // MARK: - UIButton Actions
    @IBAction func periodButtonAction(_ sender: UIButton) {
        
        indicatorColor = #colorLiteral(red: 0.4853838682, green: 0.8248652816, blue: 0.1157580242, alpha: 1)
        selectedData = "\(self.paymentDict.totalEarning)"//String(self.paymentDict.totalEarning)
        isFromUpcommingBooking = false
        isFromcupocomingPeriod = false
        isMainApiCalledForPayment = true
    }
    
    @IBAction func bookedButtonAction(_ sender: UIButton) {
        
        indicatorColor = #colorLiteral(red: 0.9577540755, green: 0.6775102019, blue: 0.3479132652, alpha: 1)
        isFromUpcommingBooking = true
        isFromcupocomingPeriod = false
        self.isMainApiCalledForPayment = false
        self.callApiBookedPayment()
        selectedData = "\(self.paymentDict.totalUpcomingPayment)"
    }
    
    @IBAction func NextDayButtonAction(_ sender: UIButton) {
        
        indicatorColor = #colorLiteral(red: 0.5501134396, green: 0.5327460766, blue: 1, alpha: 1)
        selectedData = "9/31/17"
        isFromUpcommingBooking = false
        isFromcupocomingPeriod = true
        self.isMainApiCalledForPayment = false
        self.callApiBookedPayment()
    }
    
    //MARK:- WebService Method
    func callApiForPayment() {
        
        let dict = NSMutableDictionary()
        dict[pArtistID] = USERDEFAULT.string(forKey: pArtistID)
        ServiceHelper.request(params: dict as! Dictionary<String, AnyObject>, method: .post, apiName: kAPIPayment, hudType: .simple) { (result, error, status) in
            
            if (error == nil) {
                
                if let response = result as? Dictionary<String, AnyObject> {
                    
                    if (Int(truncating: response.validatedValue("status", expected: NSInteger() as AnyObject) as! NSNumber) == 1) {
                        
                        self.isNoDateIsThere = false
                        
                        let data : Dictionary<String, AnyObject> = response.validatedValue("artistPayment", expected: Dictionary<String, AnyObject>() as AnyObject) as! Dictionary<String, AnyObject>
                        
                        self.paymentDict = BGPaymentInfoModel.getPaymentList(list: data as NSDictionary)
                        
                        let paymentDetails  = data.validatedValue("clientPaymentArr", expected: Array<Dictionary<String, AnyObject>>() as AnyObject) as! Array<Dictionary<String, AnyObject>>
                        self.newPayment = BGPaymentInfoModel.getUpcomingBookingDetail(responseArray: paymentDetails as! Array<Dictionary<String, String>>)
                        if self.isMainApiCalledForPayment{
                            self.detailsTableView.isHidden = false
                            self.detailsTableView.reloadData()
                        }
                        
                        if !self.isInitialLoading {
                            self.setUpCircleData()
                        }
                    }else{
                        self.isNoDateIsThere = true
                        _ = response.validatedValue("message", expected: "" as AnyObject) as! String
                        self.setUpCircleData()
                    }
                }
            }
            else {
                _ = AlertController.alert(title: "", message: "\(error!.localizedDescription)")
            }
        }
    }
    
    func callApiBookedPayment() {
        var localApiType = ""
        if isFromUpcommingBooking{
            localApiType = kBookedPayment
        }else if isFromcupocomingPeriod{
            localApiType = "artistPastWeekPayment"
            
        }else{
            localApiType = "artistPayment"
        }
        let dict = NSMutableDictionary()
        dict[pArtistID] = USERDEFAULT.string(forKey: pArtistID)
        
        ServiceHelper.request(params: dict as! Dictionary<String, AnyObject>, method: .post, apiName: localApiType, hudType: .simple) { (result, error, status) in
            if (error == nil) {
                if let response = result as? Dictionary<String, AnyObject> {
                    self.detailsTableView.isHidden = false
                    
                    if (Int(truncating: response.validatedValue("status", expected: NSInteger() as AnyObject) as! NSNumber) == 1) {
                        let dataArray = response.validatedValue(kDataSchedule, expected: [] as AnyObject)
                        self.paymentDetails = BGPaymentInfoModel.getPaymentDetails(responseArray: dataArray as! Array<Dictionary<String, String>>)
                        self.detailsTableView.reloadData()
                        
                    }else{
                        AlertController.alert(message: response.validatedValue("message", expected: "" as AnyObject) as! String)
                    }
                }else{
                }
            }
            else {
                _ = AlertController.alert(title: "", message: "\(error!.localizedDescription)")
            }
        }
    }
}

