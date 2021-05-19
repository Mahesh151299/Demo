//
//  boardingVC.swift
//  Courail
//
//  Created by Omeesh Sharma on 06/11/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class boardingCVC: UICollectionViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
}

class boardingVC: UIViewController {
    
    //MARK: OUTLETS
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    //MARK: VARIABLES
    
    let titleArr = [
        "One App for Everything",
        "We Are Different",
        "Get it in 30 Minutes",
        "Have It Your Way",
        "Reliable Service",
    ]
    
    let subtitleArr = [
        "Welcome to Courial, the courier app for\neverything. No more app-switching.\nHave your dry cleaning, lunch, electronics,\nfurniture, documents, even your groceries,\nall delivered by using the same app.",
        "We are not an e-commerce platform.\nYou’re in control. You order, we pickup.\nUse our search engine to find local\nmerchants and order anything you want.\nThen book us and we’ll grab it for you.",
        "That’s right. We fast y’all!\nWe focus on local merchants, so\nbook us as soon as you know your\npackage is ready, then relax and\nwe’ll see you in 30 minutes.",
        "Unlike others, we do not curate items or\nmerchants. We connect you with any\nmerchant so you can order exactly what you\nwant, the way you want it and easily make\nchanges to your order prior to pickup.",
        "Our Courial partners experience\ntransparency, keep 100% of tips and 80% of the delivery fee. By treating Courials as true partners, our customers are rewarded with reliable, outstanding service."
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func pageControlAction(_ sender: UIPageControl) {
        self.collectionView.scrollToItem(at: IndexPath(row: sender.currentPage, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    @IBAction func signInBtn(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func signUpBtn(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignUpAVC") as! SignUpAVC
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension boardingVC: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout , UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.titleArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "boardingCVC", for: indexPath) as! boardingCVC
        cell.icon.image = UIImage(named: "onboard\(indexPath.row + 1)")
        cell.title.text = self.titleArr[indexPath.row]
        cell.subtitle.text = self.subtitleArr[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
}
