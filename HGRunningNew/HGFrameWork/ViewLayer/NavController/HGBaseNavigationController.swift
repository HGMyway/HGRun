//
//  HGBaseNavigationController.swift
//  HGRunning
//
//  Created by 任是无情也动人 on 15/6/9.
//  Copyright (c) 2015年 ismyway. All rights reserved.
//

import UIKit

class HGBaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationBar.barTintColor = SWColor.themeColor()
        navigationBar.tintColor = UIColor.whiteColor()
        

        

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
