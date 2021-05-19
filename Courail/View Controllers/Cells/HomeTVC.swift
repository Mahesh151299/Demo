//
//  HomeTVC.swift
//  Courail
//
//  Created by Omeesh Sharma on 13/10/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

protocol HomeDelegate : class{
    func CollectionItemClicked(data: OfferModel, type: Int)
}

class HomeTVC: UITableViewCell {
    
    //MARK: OUTLETS
    
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var innerView : UIView!
    @IBOutlet weak var title : UILabel!
    @IBOutlet weak var subTitle : UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var iconHeight: NSLayoutConstraint!
    @IBOutlet weak var grayView: UIView!
    
    //MARK: VARIABLES
    
    var type = 0
    
    var timer = Timer()
    
    weak var delegate: HomeDelegate?
    
    var dataModel = [OfferModel]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        guard self.collectionView != nil else {return}
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupData(type: Int, data: [OfferModel]){
        self.type = type
        self.dataModel = data
        self.timer.invalidate()
        
        if self.type == 0 {
            self.collectionView.isPagingEnabled = true
            self.scrollToMid()
        }else{
            self.collectionView.isPagingEnabled = false
        }
        self.collectionView.reloadData()
    }
    
    func scrollToMid(){
        guard self.dataModel.count > 1 else {return}
        let mid = 500000 / 2
        let midIndexPath = IndexPath.init(row: mid, section: 0)
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: midIndexPath, at: .centeredHorizontally, animated: false)
        }
        self.startTimer()
    }
    
    func startTimer() {
        self.timer.invalidate()
        guard self.dataModel.count > 1 else {return}
        
        let timeInterval : TimeInterval = JSON(self.dataModel.first?.SetAdsTimeintervel ?? 0).doubleValue
        self.timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(self.autoScroll), userInfo: nil, repeats: true)
    }

    @objc func autoScroll() {
        if let coll  = self.collectionView {
            for cell in coll.visibleCells {
                if let indexPath = coll.indexPath(for: cell){
                    var nextIndexPath = IndexPath.init(row: indexPath.row + 1, section: indexPath.section)
                    if nextIndexPath.row < self.collectionView.numberOfItems(inSection: indexPath.section){
                        coll.scrollToItem(at: nextIndexPath, at: .right, animated: true)
                    }else{
                        nextIndexPath = IndexPath.init(row: 0, section: indexPath.section)
                        coll.scrollToItem(at: nextIndexPath, at: .right, animated: false)
                    }
                }
            }
        }
    }
    
}

extension HomeTVC: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard self.type != 0 else{
            guard self.dataModel.count > 1 else {
                return self.dataModel.count
            }
            
            return 500000
        }
        
        return self.dataModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard self.type != 0 else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdCVC2", for: indexPath) as! AdCVC
            cell.icon.sd_imageIndicator = SDWebImageActivityIndicator.gray
            let ad = self.dataModel[indexPath.row % self.dataModel.count]
            cell.icon.sd_setImage(with: URL(string: ad.image ?? ""), placeholderImage: nil, options: [], completed: nil)
            return cell
        }
        
        let ad = self.dataModel[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OfferCVC", for: indexPath) as! AdCVC
        cell.icon.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.icon.sd_setImage(with: URL(string: ad.image ?? ""), placeholderImage: nil, options: [], completed: nil)
        cell.title.text = (ad.title ?? " ").htmlToString.htmlToString
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard self.type != 0 else{
            return .init(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        return .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        guard self.type != 0 else{
            return 0
        }
        
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        guard self.type != 0 else{
            return 0
        }
        
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard self.type != 0 else{
            return .init(width: collectionView.frame.width , height: collectionView.frame.height)
        }
        
        let width = (collectionView.frame.width - 24) / 4
        return .init(width: width, height: width + 25)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard self.type == 0 else {return}
        cell.alpha = 0
        UIView.animate(withDuration: 0.8) {
            cell.alpha = 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard self.type != 0 else{
            self.timer.invalidate()
            let ad = self.dataModel[indexPath.row % self.dataModel.count]
            self.delegate?.CollectionItemClicked(data: ad, type: self.type)
            return
        }
        
        self.delegate?.CollectionItemClicked(data: self.dataModel[indexPath.row], type: self.type)
    }
    

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard self.type == 0 else {return}
        guard scrollView == self.collectionView else {return}
        self.startTimer()
        print("manually end Decelerating")
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard self.type == 0 else {return}
        guard scrollView == self.collectionView else {return}
        self.timer.invalidate()
        print("manually start dragging")
    }

}
