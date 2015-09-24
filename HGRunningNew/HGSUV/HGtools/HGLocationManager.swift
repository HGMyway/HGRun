//
//  HGLocationManager.swift
//  HGRunningTab
//
//  Created by 任是无情也动人 on 15/8/25.
//  Copyright (c) 2015年 ismyway. All rights reserved.
//

import Foundation

import CoreLocation

protocol HGLocationManagerDelegate : class {
    func hglocationmanagerDidUpdateLocation(location:CLLocation)
}


public class HGLocationManager: NSObject {

    //代理
    weak var delegate: HGLocationManagerDelegate?
    
    
    //    提供静态访问方法
    public class  var shared: HGLocationManager{
        dispatch_once(&Inner.token){
            Inner.instance = HGLocationManager()
        }
        return Inner.instance!
    }
    
    //    通过结构体保存实例的引用
    private struct Inner {
        private static var instance: HGLocationManager?
        private static var token: dispatch_once_t = 0
    }
    
    private let locationManager: CLLocationManager
    
    
    private  override init() {
        //私有化init方法，防止其他对象使用这个类的默认的（）
        locationManager = CLLocationManager()
    }
    
    
//MARK: 私有方法
    private func checkCurrentStatus() -> ( enable: Bool, authorStatus: CLAuthorizationStatus)
    {
        
        
        let authorStatus = CLLocationManager.authorizationStatus()
        
        if CLLocationManager.locationServicesEnabled(){
            
            locationManager.delegate = self
            locationManager.desiredAccuracy  = kCLLocationAccuracyBest //定位精度
            locationManager.distanceFilter = 0.5 //距离过滤，设备移动更新位置信息的最小距离
            
            switch (authorStatus )
            {
            case CLAuthorizationStatus.NotDetermined: //用户尚未做出决定是否启用定位服务
                locationManager.requestWhenInUseAuthorization()
                break
            case CLAuthorizationStatus.Restricted://没有获得用户授权使用定位服务,可能用户没有自己禁止访问授权
                locationManager.requestWhenInUseAuthorization()
                break
            case CLAuthorizationStatus.Denied ://用户已经明确禁止应用使用定位服务或者当前系统定位服务处于关闭状态
                break
            case CLAuthorizationStatus.AuthorizedAlways ://应用获得授权可以一直使用定位服务，即使应用不在使用状态
                locationManager.startUpdatingLocation()
                break
            case CLAuthorizationStatus.AuthorizedWhenInUse://使用此应用过程中允许访问定位服务
                locationManager.startUpdatingLocation()
                break
            }
            
            return (true,authorStatus)
        }
        
        return (false,authorStatus)
    }
    
    
    
//MARK: 共有方法
    func startUpdatingLocation() -> ( enable: Bool, authorStatus: CLAuthorizationStatus) {
        return checkCurrentStatus()
    }
    
    func stopUpdatingLocation(){
        locationManager.stopUpdatingLocation()
    }
    
}


//MARK:CLLocationManagerDelegate 代理方法
extension HGLocationManager: CLLocationManagerDelegate{
    public func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.last  as CLLocation!
        
        delegate?.hglocationmanagerDidUpdateLocation(currentLocation)
        
        
    }
    
    public func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        //用户权限状态改变时调用
    }
    
    
}



