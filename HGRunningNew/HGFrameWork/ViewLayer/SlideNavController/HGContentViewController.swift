//
//  HGContentViewController.swift
//  HGRunningTab
//
//  Created by 任是无情也动人 on 15/8/17.
//  Copyright (c) 2015年 ismyway. All rights reserved.
//

import UIKit

enum HGSlideOutState {
    case BothCollapsed
    case LeftPanelExpanded
}

class HGContentViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabbarController = UIStoryboard.tabbarViewController()
        tabbarController.panalDelegate = self
        addChildViewController(tabbarController)
        view.addSubview(tabbarController.view)
        tabbarController.didMoveToParentViewController(self)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    var currentState: HGSlideOutState = .BothCollapsed{
        didSet{
            let shouldShowShadow = currentState != .BothCollapsed

            showShadowForTabbarViewController(shouldShowShadow)
            addTapForTabbarViewController(shouldShowShadow)
        }
    }
    
    
    var  tabbarController :HGTabBarViewController!
    
    var leftViewController: HGSidePanelViewController?
    let tabbarPanelExpandedOffset: CGFloat = 60
    
}


private extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
    
    class func leftViewController() -> HGSidePanelViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("LeftViewController") as? HGSidePanelViewController
    }
    
    
    class func tabbarViewController() -> HGTabBarViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("HGTabBarViewController") as? HGTabBarViewController
    }
    
}



// MARK: CenterViewController delegate
extension HGContentViewController: HGTabBarViewControllerDelegata {
    func collapseSidePanels() {
        switch (currentState) {
        case .LeftPanelExpanded:
            leftSlideBtnClick()
        default:
            break
        }
    }
    
    
    func leftSlideBtnClick() {
        let notAlreadyExpanded = (currentState != .LeftPanelExpanded)//判断左侧边是否存在
        
        if notAlreadyExpanded{
            //左侧边不存在
            addLeftPanelViewController()
        }
        leftSidePanel(shouldExpand: notAlreadyExpanded)
    }
    
    
    /**
    判断左侧边是否是空，是空的时候添加
    */
    func addLeftPanelViewController(){
        if (leftViewController == nil){
            leftViewController = UIStoryboard.leftViewController()
            addChildSidePanelController(leftViewController!)
            
        }
    }
    
    
    /**
    添加侧边栏视图
    
    - parameter sidePanelController: 侧边栏视图控制器
    */
     func addChildSidePanelController(sidePanelController: HGSidePanelViewController) {
        
        sidePanelController.sideDelegate = tabbarController
        
        view.insertSubview(sidePanelController.view, atIndex: 0)
        addChildViewController(sidePanelController)
        sidePanelController.didMoveToParentViewController(self)

    }
    
    
    /**
    显示或隐藏侧边栏
    
    - parameter shouldExpand: true 显示侧边栏   false 隐藏侧边栏
    */
    func leftSidePanel(shouldExpand shouldExpand: Bool) {
        if (shouldExpand){
            currentState = .LeftPanelExpanded
            animateTabbarViewPanelXPosition(targetPosition: CGRectGetWidth(tabbarController.view.frame) - tabbarPanelExpandedOffset)

        }else{
            animateTabbarViewPanelXPosition(targetPosition: 0){ finished in
                self.currentState = .BothCollapsed
                
                self.leftViewController?.view.removeFromSuperview()
                self.leftViewController = nil
                
            }
        }
    }
    

    /**
    侧移动画
    
    - parameter targetPosition: <#targetPosition description#>
    - parameter completion:     <#completion description#>
    */
    func animateTabbarViewPanelXPosition(targetPosition targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.tabbarController.view.frame.origin.x = targetPosition
        }, completion: completion)
    }
    
    func showShadowForTabbarViewController(shouldShowShadow: Bool) {
        if (shouldShowShadow) {
            tabbarController.view.layer.shadowOpacity = 0.8
        } else {
            tabbarController.view.layer.shadowOpacity = 0
        }
    }
    
    func addTapForTabbarViewController(shouldShowShadow: Bool) {
        if(shouldShowShadow){
            tabbarController.view.addSubview(tabbarController.tapBtn)
        }else{
            tabbarController.tapBtn.removeFromSuperview()
        }
    }

    
    
    
}