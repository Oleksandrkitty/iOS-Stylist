//
//  BGAppointmentReciptVC.swift
//  BogoArtistApp
//
//

import UIKit

class BGAppointmentReciptVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var contentView          : UIView!
    @IBOutlet weak var collectionView       : UICollectionView!
    @IBOutlet weak var confirmPaymentButton : UIButton!
    var indexSelect                         = 0
   
    // MARK:- ============ View Lifecycle Methods ==============
    override func viewDidLoad() {
        super.viewDidLoad()
        helperMethod()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - =============Helper Method=====================
    func helperMethod(){
        setShadowview(newView: contentView)
    }

    // MARK: - UICollectionView Delegate and Datasource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BGAppointmentReciptCVCell", for: indexPath) as! BGAppointmentReciptCVCell
        cell.tipView.tag = indexPath.row
        if (indexPath.row  == indexSelect){
            cell.tipView.tag = indexSelect
            cell.tipView.backgroundColor = #colorLiteral(red: 0.9556562304, green: 0.08721932024, blue: 0.45581007, alpha: 1)
            cell.percentLabel.textColor = UIColor.white
            cell.priceLabel.textColor = UIColor.white
        } else{
            cell.tipView.backgroundColor = #colorLiteral(red: 0.9293333888, green: 0.9294636846, blue: 0.9292923808, alpha: 1)
            cell.percentLabel.textColor = #colorLiteral(red: 0.9556562304, green: 0.08721932024, blue: 0.45581007, alpha: 1)
            cell.priceLabel.textColor = UIColor.darkGray
        }
        setShadowview(newView: cell.tipView)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         indexSelect = indexPath.row
      self.collectionView.reloadData()
        
    }
}
