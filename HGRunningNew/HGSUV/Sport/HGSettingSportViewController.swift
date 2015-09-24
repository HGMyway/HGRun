//
//  HGSettingSportViewController.swift
//  HGRunningTab
//
//  Created by 任是无情也动人 on 15/8/18.
//  Copyright (c) 2015年 ismyway. All rights reserved.
//

import UIKit

import CoreLocation

class HGSettingSportViewController: HGBaseViewController {
    
    
    @IBOutlet weak var acceleLabel: UILabel!
    
    @IBOutlet weak var gyroLabel: UILabel!
    
    @IBOutlet weak var magnetometerLabel: UILabel!
    
    @IBOutlet weak var speedLabel: UILabel!
    
    
    //变量
    var speedValue :CLLocationSpeed{
        set{
            speedLabel.text = "\(newValue)"
        }
        
        get{
            return NSNumberFormatter().numberFromString(speedLabel.text!)!.doubleValue
        }
    }
    
    var currentLocation : CLLocation?{
        didSet{
            
            acceleLabel.text = currentLocation?.description
            gyroLabel.text = "\(currentLocation!.coordinate.latitude)  .   \(currentLocation!.coordinate.longitude)"
            magnetometerLabel.text = "\(currentLocation!.horizontalAccuracy) + \(currentLocation!.verticalAccuracy)"
            speedValue = currentLocation!.speed
        }
    }
    
    
    let hgLocationManager = HGLocationManager.shared
    
    @IBAction func startRunningAction(sender: UIButton) {
        
        if sender.selected == false {
            hgLocationManager.delegate = self
            
            let (enable,authorStatus) = hgLocationManager.startUpdatingLocation()
            
            if   enable{
                
                switch (authorStatus )
                {
                case CLAuthorizationStatus.NotDetermined: break//用户尚未做出决定是否启用定位服务
                case CLAuthorizationStatus.Restricted:break //没有获得用户授权使用定位服务,可能用户没有自己禁止访问授权
                case CLAuthorizationStatus.Denied :break //用户已经明确禁止应用使用定位服务或者当前系统定位服务处于关闭状态
                case CLAuthorizationStatus.AuthorizedAlways :break //应用获得授权可以一直使用定位服务，即使应用不在使用状态
                case CLAuthorizationStatus.AuthorizedWhenInUse: break//使用此应用过程中允许访问定位服务
                }

                
                sender.selected = true
                sender.setTitle("继续", forState: UIControlState.Normal)
            }else
            {
                sender.setTitle("定位失败", forState: UIControlState.Normal)
            }
            
        }else{
            hgLocationManager.stopUpdatingLocation()
            sender.selected = false
        }
    }
    
}


//MARK:定位管理中心，代理方法
extension HGSettingSportViewController: HGLocationManagerDelegate{
    
    func hglocationmanagerDidUpdateLocation(location: CLLocation) {
        currentLocation = location
    }
    
}



