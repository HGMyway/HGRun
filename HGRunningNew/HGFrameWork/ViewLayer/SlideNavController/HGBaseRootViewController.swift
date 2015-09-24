//
//  HGBaseRootViewController.swift
//  HGRunningTab
//
//  Created by 任是无情也动人 on 15/8/20.
//  Copyright (c) 2015年 ismyway. All rights reserved.
//

import UIKit

class HGBaseRootViewController: HGBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        hgTabbarController = tabBarController as! HGTabBarViewController
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "left", style: UIBarButtonItemStyle.Done, target: self, action: "leftSlideBtnClick:")
        
        hidesBottomBarWhenPushed = true
    

    }
    


    var hgTabbarController : HGTabBarViewController!
    
    
    func leftSlideBtnClick(sender: UIBarButtonItem) {
        hgTabbarController.leftItemClick()
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
