//
//  TabBarVC.swift
//  Capturise
//
//  Created by apple on 11/12/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit

var tabBottom : CGFloat = 0

class TabBarVC: UITabBarController, UITabBarControllerDelegate {
    
    let BarHeight = 110
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getDeviceType()
        self.delegate = self
        
        self.tabBar.unselectedItemTintColor = UIColor.init(red: 118/255, green: 118/255, blue: 118/255, alpha: 1.0)
        self.tabBar.tintColor = appColor
        
        self.setTabBarItems()
    }
    
    func setTabBarItems(){
        let myTabBarItem1 = (self.tabBar.items?[0])! as UITabBarItem
        myTabBarItem1.image = UIImage(named: "tabHome")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem1.selectedImage = UIImage(named: "tabHome1")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem1.title = "Home"
        
        let myTabBarItem2 = (self.tabBar.items?[1])! as UITabBarItem
        myTabBarItem2.image = UIImage(named: "tabSearch")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem2.selectedImage = UIImage(named: "tabSearch1")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem2.title = "Search"
        
        let myTabBarItem3 = (self.tabBar.items?[2])! as UITabBarItem
        myTabBarItem3.title = "Orders"
        if currentOrder == nil{
            myTabBarItem3.image = UIImage(named: "tabOrder")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            myTabBarItem3.selectedImage = UIImage(named: "tabOrder1")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        } else{
            myTabBarItem3.image = UIImage(named: "tabOrderBadge")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            myTabBarItem3.selectedImage = UIImage(named: "tabOrderBedge1")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        }
        
        let myTabBarItem4 = (self.tabBar.items?[3])! as UITabBarItem
        myTabBarItem4.image = UIImage(named: "tabFaves")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem4.selectedImage = UIImage(named: "tabFaves1")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem4.title = "Faves"
        
        let myTabBarItem5 = (self.tabBar.items?[4])! as UITabBarItem
        myTabBarItem5.image = UIImage(named: "tabProfile")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem5.selectedImage = UIImage(named: "tabProfile1")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem5.title = "Profile"
    }
    
    func getDeviceType(){
        for i in 0..<(self.tabBar.items?.count ?? 0){
            self.tabBar.items?[i].imageInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        ApiInterface.getCurrentOrder {_ in }
        
        let newSelectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController)
        
        let warningView = ((self.viewControllers?[0] as? UINavigationController)?.viewControllers.first as? HomeVC)?.showDistanceWarning ?? false
        if self.selectedIndex == 0 && newSelectedIndex == 1 && warningView == true{
            ((self.viewControllers?[0] as? UINavigationController)?.viewControllers.first as? HomeVC)?.farAwayView.isHidden = false
            return false
        }else{
            guard deleteOrderFlag == false else {
                deleteOrder { (result) in
                    if newSelectedIndex == 1{
                        (self.viewControllers?[newSelectedIndex ?? 0] as? UINavigationController)?.popToRootViewController(animated: false)
                        
                        ((self.viewControllers?[newSelectedIndex ?? 0] as? UINavigationController)?.viewControllers.first as? SearchPlaceVC)?.searchType = 1
                        if ((self.viewControllers?[newSelectedIndex ?? 0] as? UINavigationController)?.viewControllers.first as? SearchPlaceVC)?.collectionURL != nil{
                            ((self.viewControllers?[newSelectedIndex ?? 0] as? UINavigationController)?.viewControllers.first as? SearchPlaceVC)?.searchField.text = ""
                            ((self.viewControllers?[newSelectedIndex ?? 0] as? UINavigationController)?.viewControllers.first as? SearchPlaceVC)?.arrangeViews()
                        }
                        self.selectedIndex = newSelectedIndex ?? 0
                    } else if newSelectedIndex == 2{
                        self.checkOrder()
                    }else if newSelectedIndex == 3{
                        if checkLogin(){
                            (self.viewControllers?[newSelectedIndex ?? 0] as? UINavigationController)?.popToRootViewController(animated: false)
                            self.selectedIndex = newSelectedIndex ?? 0
                        }
                    }else if newSelectedIndex == 4{
                        toggleMenu(self)
                    } else{
                        (self.viewControllers?[newSelectedIndex ?? 0] as? UINavigationController)?.popToRootViewController(animated: false)
                        self.selectedIndex = newSelectedIndex ?? 0
                    }
                }
                return false
            }
            
            switch newSelectedIndex {
            case 1:
                (viewController as? UINavigationController)?.popToRootViewController(animated: false)
                ((viewController as? UINavigationController)?.viewControllers.first as? SearchPlaceVC)?.searchType = 1
                if ((viewController as? UINavigationController)?.viewControllers.first as? SearchPlaceVC)?.collectionURL != nil{
                    ((viewController as? UINavigationController)?.viewControllers.first as? SearchPlaceVC)?.searchField.text = ""
                    ((viewController as? UINavigationController)?.viewControllers.first as? SearchPlaceVC)?.arrangeViews()
                }
                return true
            case 2:
                self.checkOrder()
                return false
            case 3:
                if checkLogin(){
                    (viewController as? UINavigationController)?.popToRootViewController(animated: false)
                    return true
                } else{
                    return false
                }
            case 4:
                toggleMenu(self)
                return false
            default:
                (viewController as? UINavigationController)?.popToRootViewController(animated: false)
                return true
            }
        }
        
    }
    
    func checkOrder(){
        self.setTabBarItems()
        if currentOrder == nil{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CurrentOrderVC")as! CurrentOrderVC
            (self.viewControllers?[2] as? UINavigationController)?.viewControllers = [vc]
        }else{
            if (currentOrder?.status == orderStatus.complete) && (currentOrder?.isRate ?? "0") == "0"{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "DeliveryCompletedVC")as! DeliveryCompletedVC
                (self.viewControllers?[2] as? UINavigationController)?.viewControllers = [vc]
            } else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CD_SeeDetailVC")as! CD_SeeDetailVC
                (self.viewControllers?[2] as? UINavigationController)?.viewControllers = [vc]
            }
        }
        self.selectedIndex = 2
    }
}



