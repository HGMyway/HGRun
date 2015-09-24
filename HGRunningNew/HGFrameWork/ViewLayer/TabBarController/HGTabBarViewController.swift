//
//  HGTabBarViewController.swift
//  HGRunningTab
//
//  Created by 任是无情也动人 on 15/8/17.
//  Copyright (c) 2015年 ismyway. All rights reserved.
//

import UIKit


@objc
protocol HGTabBarViewControllerDelegata{
    
    /**
    点击左按钮显示／隐藏侧边栏
    */
    optional func leftSlideBtnClick()
    /**
    点击侧边栏中
    */
    optional func collapseSidePanels()
}

class HGTabBarViewController: UITabBarController {
    
    
    var panalDelegate: HGTabBarViewControllerDelegata?
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        tap = UITapGestureRecognizer(target: self, action: "hideSidePanal:")
        
        
        tapBtn = UIButton(type: UIButtonType.Custom)
        tapBtn.frame = view.frame
        tapBtn.backgroundColor = UIColor.clearColor()
        tapBtn.addTarget(self, action: "hideSidePanalClick:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
//    var tap : UITapGestureRecognizer!
    
    var tapBtn : UIButton!
    
    func hideSidePanalClick(btn : UIButton){
        panalDelegate?.collapseSidePanels?()
    }

    
    func hideSidePanal(tap : UITapGestureRecognizer){
        panalDelegate?.collapseSidePanels?()
    }
    
    /**
    点击导航栏左按钮时调用
    */
    func leftItemClick(){
        panalDelegate?.leftSlideBtnClick?()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}



// MARK: 侧边栏中的代理方法
extension HGTabBarViewController: HGSidePanelViewControllerDelegate {
    
    func panelCellClick(selectedModel: HGSideCellModel) {
        panalDelegate?.collapseSidePanels?()
        
        selectedIndex = selectedModel.selectIndex
        
    }
}


