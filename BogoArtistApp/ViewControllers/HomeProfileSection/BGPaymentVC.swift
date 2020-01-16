//
//  BGPaymentVCViewController.swift
//  BogoArtistApp
//
//

import UIKit

enum CircleType {
    case thisPeriod, booked, nextPayDay
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
    var maxDateOfMonth                  = 0
    var selectedPaymentList: CircleType = .thisPeriod
    var isNoDateIsThere                 = true
    var payDays                         = 0
    var isInitialLoading                = false
    var paymentDict                     = BGPaymentInfoModel()
    var paymentDetails                  = [BGPaymentInfo]()
    var newPayment                      = [BGPaymentInfoModel]()

    @IBOutlet weak var headerViewTableHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var rings: [NSLayoutConstraint]!
   
    
    // MARK: - UIViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        adjustHeaderHeight()

        indicatorColor = #colorLiteral(red: 0.4853838682, green: 0.8248652816, blue: 0.1157580242, alpha: 1)
        
        detailsTableView.isHidden = true

        setUpCircleData()
    }

    private func adjustHeaderHeight() {
        if kWindowWidth == 320 {
            if kWindowHeight < 500 {
                self.headerViewTableHeightConstraint.constant = 40
                for aRing in rings {
                    aRing.constant = aRing.constant * 0.8
                }
            } else {
                self.headerViewTableHeightConstraint.constant = 60
            }
        } else if kWindowWidth == 375 {
            self.headerViewTableHeightConstraint.constant = 150
        } else {
            self.headerViewTableHeightConstraint.constant = 240
        }
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
        } else if weekday! > 1 && weekday! < 15 {
            payDays = 15 - weekday!
        } else if weekday! > 15 && weekday! <= maxDateOfMonth {
            payDays = (maxDateOfMonth + 1) - weekday!
        }

        callApiForPayments()
    }
    
    func setUpCircleData() {
        periodLabel.text = "$" + "\(paymentDict.totalEarning)"
        bookedLabel.text = "$" + "\(paymentDict.totalUpcomingPayment)"
        if isNoDateIsThere{
            payDays = 0 
        }
        payDayLabel.text = "\(payDays)" + " Days"
        
        drawBaseCircle(circleView: ring1, type: .thisPeriod)
        drawBaseCircle(circleView: ring2, type: .booked)
        drawBaseCircle(circleView: ring3, type: .nextPayDay)
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

        let rect = CGRect(x: 0, y: 0, width: circleView.frame.size.width, height: circleView.frame.size.height)

        let demoView = BGCircularView(frame: rect)

        switch type {
            case .thisPeriod:
                if !isNoDateIsThere {
                    if paymentDict.totalEarning != 0 {
                        demoView.pathColor = RGBA(r: 123, g: 211, b: 55, a: 1)
                        circleView.addSubview(demoView)
                    }
                } else {
                    demoView.pathColor = RGBA(r: 240, g: 240, b: 240, a: 1)
                }

            case .booked:
                if !isNoDateIsThere {
                    if paymentDict.totalUpcomingPayment != 0 {
                        demoView.pathColor = RGBA(r: 245, g: 171, b: 97, a: 1)
                        circleView.addSubview(demoView)
                    }
                } else {
                    demoView.pathColor = RGBA(r: 240, g: 240, b: 240, a: 1)
                }

            case .nextPayDay:
                if !isNoDateIsThere {
                    if payDays != 0 {
                        demoView.pathColor = RGBA(r: 139, g: 137, b: 251, a: 1)
                        demoView.endAngle = (20 * payDays) + 130
                        circleView.addSubview(demoView)
                    }
                } else {
                    demoView.pathColor = RGBA(r: 240, g: 240, b: 240, a: 1)
                }

        }
    }
    
    // MARK: - UITableView Delegate and DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        paymentDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BGSummaryTVCell", for: indexPath) as! BGSummaryTVCell
        let payment = paymentDetails[indexPath.row]

        let rectShape = CAShapeLayer()
        rectShape.bounds = cell.indicatorLabel.frame
        rectShape.position = cell.indicatorLabel.center
        rectShape.path = UIBezierPath(roundedRect: cell.indicatorLabel.bounds, byRoundingCorners: [.bottomLeft , .topLeft], cornerRadii: CGSize(width: 5, height: 5)).cgPath

        setShadowview(newView: cell.summaryView)

        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.indicatorLabel.layer.mask = rectShape
        cell.indicatorLabel.backgroundColor = indicatorColor

        cell.contentLabel.text = payment.bookingDate
        cell.summaryLabel.text = payment.clientFirstName + " " + payment.clientLastName
        
        return cell
    }
    
    // MARK: - UIButton Actions
    @IBAction func periodButtonAction(_ sender: UIButton) {
        indicatorColor = #colorLiteral(red: 0.4853838682, green: 0.8248652816, blue: 0.1157580242, alpha: 1)
        selectedPaymentList = .thisPeriod
    }
    
    @IBAction func bookedButtonAction(_ sender: UIButton) {
        indicatorColor = #colorLiteral(red: 0.9577540755, green: 0.6775102019, blue: 0.3479132652, alpha: 1)
        selectedPaymentList = .booked
        self.callApiForPayments()
    }
    
    @IBAction func nextDayButtonAction(_ sender: UIButton) {
        indicatorColor = #colorLiteral(red: 0.5501134396, green: 0.5327460766, blue: 1, alpha: 1)
        selectedPaymentList = .nextPayDay
        self.callApiForPayments()
    }

    func callApiForPayments() {
        let endpoint: Api

        switch selectedPaymentList {
            case .booked: endpoint = Api.stylistsBookedPayments(params: [ "id": currentUserId() ])
            case .thisPeriod: endpoint = Api.payments(params: [ "id": currentUserId() ])
            case .nextPayDay: endpoint = Api.stylistsNextPaydayPayments(params: [ "id": currentUserId() ])
        }

        Api.requestMappableArray(endpoint, success: {
            (payments: [BGPaymentInfo]) -> Void in
            self.detailsTableView.isHidden = false
            self.paymentDetails = payments
            self.detailsTableView.reloadData()
        })
    }
}

