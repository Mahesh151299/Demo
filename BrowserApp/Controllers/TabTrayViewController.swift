//
//  TabTrayViewController.swift
//  Browser App
//
//  Created by Gaurav Gupta on 10/3/21. on 11/7/17.
//  .
//

import UIKit
import Then


class TabTrayViewController: UIViewController {
    
    static let identifier = "TabTrayIdentifier"
    
    var collectionView: UICollectionView!
    @objc var closeButton: UIButton?
    @objc var viewUpper: UIView?
    @objc var lblTitle: UILabel?
    @objc var addTabButton: UIButton?
    var addTapPress:(()->())?
    override func viewDidLoad() {
        super.viewDidLoad()
    
        viewUpper = UIView().then { [unowned self] in
          
            $0.backgroundColor = .clear
            self.view.addSubview($0)
            $0.snp.makeConstraints { (make) in
                make.width.equalToSuperview()
                make.height.equalTo(70)
                make.top.equalTo(self.view).offset(20)
               // make.left.equalTo(self.view.snp.right).offset(-15)
            }
        }
        
        lblTitle = UILabel().then { [unowned self] in
            $0.text = ""
            $0.font = UIFont.boldSystemFont(ofSize: 20)
            self.viewUpper?.addSubview($0)
            $0.snp.makeConstraints { (make) in
//                make.width.equalTo(40)
//                make.height.equalTo(40)
                make.centerY.equalTo(self.viewUpper!).offset(10)
               // make.top.equalTo(self.viewUpper!.snp.top).offset(15)
                make.left.equalTo(self.viewUpper!).offset(15)
            }
        }
        
        
        
        closeButton = UIButton().then { [unowned self] in
            $0.setImage(UIImage(named: "menu_close"), for: .normal)
            $0.tintColor = .black
            $0.addTarget(self, action: #selector(viewClose(sender:)), for: .touchUpInside)
            self.viewUpper?.addSubview($0)
            $0.snp.makeConstraints { (make) in
                make.width.equalTo(40)
                make.height.equalTo(40)
                make.centerY.equalTo(self.viewUpper!).offset(10)
               // make.top.equalTo(self.viewUpper!.snp.top).offset(15)
                make.right.equalTo(self.viewUpper!.snp.right).offset(-15)
            }
        }
        
        addTabButton = UIButton().then { [unowned self] in
            $0.setImage(UIImage(named: "addTab"), for: .normal)
            $0.addTarget(self, action: #selector(addTab(sender:)), for: .touchUpInside)
            self.viewUpper?.addSubview($0)
            $0.snp.makeConstraints { (make) in
                make.width.equalTo(40)
                make.height.equalTo(40)
                make.centerY.equalTo(self.closeButton!)
               // make.top.equalTo(self.viewUpper!.snp.top).offset(15)
                make.right.equalTo(self.closeButton!.snp.left).offset(-8)
            }
        }
        view.backgroundColor = TabContainerView.currentInstance?.isPrivateEnable ?? false ? Colors.darkBg : .white
        closeButton?.tintColor = TabContainerView.currentInstance?.isPrivateEnable ?? false ? Colors.whiteBg : .black
        addTabButton?.tintColor = TabContainerView.currentInstance?.isPrivateEnable ?? false ? Colors.whiteBg : .black
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width * 0.4, height: UIScreen.main.bounds.height * 0.3)
        flowLayout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
            $0.dataSource = self
            $0.delegate = self
            $0.backgroundColor = TabContainerView.currentInstance?.isPrivateEnable ?? false ? Colors.darkBg : .white
            
            self.view.addSubview($0)
            $0.snp.makeConstraints { make in
//                if #available(iOS 11.0, *) {
//                    make.edges.equalTo(self.view.safeAreaLayoutGuide)
//                } else {
//                    make.edges.equalTo(self.view)
//                }
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.top.equalTo(self.viewUpper!.snp.bottom).offset(0)
                make.bottom.equalToSuperview()
            }
        }
        
        collectionView.register(TabCollectionViewCell.self, forCellWithReuseIdentifier: TabTrayViewController.identifier)
        collectionView.reloadData()
        let index = IndexPath(item: TabContainerView.currentInstance?.selectedTabIndex ?? 0, section: 0)
        self.collectionView.scrollToItem(at: index, at: .bottom, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func addTab(sender: UIButton) {
        addTapPress?()
        self.dismiss(animated: true)
    }
    
    @objc func viewClose(sender: UIButton) {
        self.dismiss(animated: true)
    }

}

extension TabTrayViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if TabContainerView.currentInstance?.isPrivateEnable ?? false
        {
            return TabContainerView.currentInstance?.privateTabList.count ?? 0
        }
        return TabContainerView.currentInstance?.tabList.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabTrayViewController.identifier, for: indexPath) as? TabCollectionViewCell
        
        let tab = TabContainerView.currentInstance?.isPrivateEnable ?? false ? TabContainerView.currentInstance?.privateTabList[indexPath.item] :  TabContainerView.currentInstance?.tabList[indexPath.item]
       
//        if let image = tab?.webContainer?.currentScreenshot
//        {
//            cell?.screenshotView.image = image
//        }
        cell?.backgroundColor = TabContainerView.currentInstance?.isPrivateEnable ?? false ? Colors.darkBg : .white
        cell?.screenshotView.image = tab?.webContainer?.currentScreenshot ?? #imageLiteral(resourceName: "globe")
        print("screenshot get image \(tab?.webContainer?.currentScreenshot)")
        if let faviconURLString = tab?.webContainer?.favicon?.getPreferredURL(), let faviconURL = URL(string: faviconURLString) {
            cell?.faviconView.sd_setImage(with: faviconURL, placeholderImage: #imageLiteral(resourceName: "globe"))
        } else {
            cell?.faviconView.image = #imageLiteral(resourceName: "globe")
        }
        cell?.pageTitle.text = tab?.webContainer?.webView?.title
        
        cell?.closeTabButton.tag = indexPath.item
        cell?.delegate = self
        cell?.layer.cornerRadius = 5
        if tab == TabContainerView.currentInstance?.currentTab {
            cell?.layer.borderWidth = 3
            cell?.layer.borderColor = TabContainerView.currentInstance?.isPrivateEnable ?? false ? UIColor.blue.cgColor : UIColor.blue.cgColor
           // cell?.screenshotView.isHidden = false
        } else {
            cell?.layer.borderWidth = 3
            cell?.layer.borderColor = UIColor.lightGray.cgColor
           // cell?.screenshotView.isHidden = true
        }
        cell?.clipsToBounds = true
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if TabContainerView.currentInstance?.isPrivateEnable ?? false
        {
            guard let tab = TabContainerView.currentInstance?.privateTabList[indexPath.item] else { return }
            
            TabContainerView.currentInstance?.didTap(tab: tab)
            self.dismiss(animated: true, completion: nil)
        }
        else
        {
            guard let tab = TabContainerView.currentInstance?.tabList[indexPath.item] else { return }
            
            TabContainerView.currentInstance?.didTap(tab: tab)
            self.dismiss(animated: true, completion: nil)
        }
       
    }
}

extension TabTrayViewController: TabTrayCellDelegate {
    func didTapCloseBtn(tabCell: TabCollectionViewCell, tag: Int) {
        guard let tab = TabContainerView.currentInstance?.tabList[tag] else { return }
        
        if TabContainerView.currentInstance?.close(tab: tab) ?? false {
            collectionView.performBatchUpdates({
                self.collectionView.deleteItems(at: [IndexPath(item: tag, section: 0)])
            }, completion: { _ in
                self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
            })
        }
    }
}
