//
//  HGMotionKit.swift
//  HGRunningTab
//
//  Created by 任是无情也动人 on 15/8/18.
//  Copyright (c) 2015年 ismyway. All rights reserved.
//

import Foundation
import CoreMotion

@objc

protocol  HGMotionKitDelegate{
    optional  func retrieveAccelerometerValues (x: Double, y:Double, z:Double, absoluteValue: Double)
    optional  func retrieveGyroscopeValues     (x: Double, y:Double, z:Double, absoluteValue: Double)
    optional  func retrieveDeviceMotionObject  (deviceMotion: CMDeviceMotion)
    optional  func retrieveMagnetometerValues  (x: Double, y:Double, z:Double, absoluteValue: Double)
    
    optional  func getAccelerationValFromDeviceMotion        (x: Double, y:Double, z:Double)
    optional  func getGravityAccelerationValFromDeviceMotion (x: Double, y:Double, z:Double)
    optional  func getRotationRateFromDeviceMotion           (x: Double, y:Double, z:Double)
    optional  func getMagneticFieldFromDeviceMotion          (x: Double, y:Double, z:Double)
    optional  func getAttitudeFromDeviceMotion               (attitude: CMAttitude)
    
}


public class HGMotionKit{
    let hgMotionManager = CMMotionManager()
    var delegate: HGMotionKitDelegate?


    
    class var sharedInstance : HGMotionKit {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : HGMotionKit? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = HGMotionKit()
              print("CMMotionManager 是啥啊")
        }
        return Static.instance!
    }
    
    

    
    /**
    ＊  获取手机的重力加速度
    *   Starts accelerometer updates, providing data to the given handler through the given queue.
    *   Note that when the updates are stopped, all operations in the
    *   given NSOperationQueue will be cancelled. You can access the retrieved values either by a
    *   Trailing Closure or through a Delgate.
    
    - parameter interval: 获取加速度时间间隔
    - parameter values:   用于回调的block
    - parameter x:        屏幕横向的维度，同frame
    - parameter y:        屏幕纵向的维度，同frame
    - parameter z:        穿过屏幕的维度，
    */
    public func getAccelerometerValues (interval: NSTimeInterval = 0.1, values: ((x: Double, y: Double, z: Double) -> ())? ){
        
        var valX: Double!
        var valY: Double!
        var valZ: Double!
        if hgMotionManager.accelerometerAvailable {
            hgMotionManager.accelerometerUpdateInterval = interval
            

            
            hgMotionManager.startAccelerometerUpdatesToQueue(NSOperationQueue()) {
                (data: CMAccelerometerData?, error: NSError?) in
                
                if let isError = error {
                    NSLog("Error: %@", isError)
                }
                valX = data!.acceleration.x
                valY = data!.acceleration.y
                valZ = data!.acceleration.z
                
                if values != nil{
                    values!(x: valX,y: valY,z: valZ)
                }
                let absoluteVal = sqrt(valX * valX + valY * valY + valZ * valZ)
                self.delegate?.retrieveAccelerometerValues!(valX, y: valY, z: valZ, absoluteValue: absoluteVal)
            }
            
        } else {
            NSLog("The Accelerometer is not available")
        }
        
        
    }
    
    
    /**
    *   陀螺仪，获取手机当前方向
    *   Starts gyro updates, providing data to the given handler through the given queue.
    *   Note that when the updates are stopped, all operations in the
    *   given NSOperationQueue will be cancelled. You can access the retrieved values either by a
    *   Trailing Closure or through a Delegate.
    - parameter interval: <#interval description#>
    - parameter values:   <#values description#>
    - parameter y:        <#y description#>
    - parameter z:        <#z description#>
    */
    
    
    /**
      陀螺仪，获取手机当前方向
    
    - parameter interval: 获取陀螺状态时间间隔
    - parameter values:   <#values description#>
    - parameter y:        <#y description#>
    - parameter z:        <#z description#>
    */
    public func getGyroValues (interval: NSTimeInterval = 0.1, values: ((x: Double, y: Double, z:Double) -> ())? ) {
        var valX: Double!
        var valY: Double!
        var valZ: Double!
        if hgMotionManager.gyroAvailable{
            hgMotionManager.gyroUpdateInterval = interval
            hgMotionManager.startGyroUpdatesToQueue(NSOperationQueue()) {
                (data:CMGyroData?, error:NSError?) in
                if let isError = error{
                    print("陀螺仪错误：\(isError)")
                }
                
                valX = data!.rotationRate.x
                valY = data!.rotationRate.y
                valZ = data!.rotationRate.z
                
                if values != nil{
                    values!(x:valX,y:valY,z:valZ)
                }
                let absoluteVal = sqrt(valX * valX + valY * valY + valZ * valZ)
                self.delegate?.retrieveGyroscopeValues!(valX, y: valY, z: valZ, absoluteValue: absoluteVal)
                
            }
        }else{
            print("陀螺仪不可用")
        }
    }
    
    @available(iOS, introduced=5.0)
    public func getMagnetometerValues (interval: NSTimeInterval = 0.1, values: ((x: Double, y:Double, z:Double) -> ())? ){
        
        var valX: Double!
        var valY: Double!
        var valZ: Double!
        if hgMotionManager.magnetometerAvailable {
            hgMotionManager.magnetometerUpdateInterval = interval
            
            
            
            
            
            hgMotionManager.startMagnetometerUpdatesToQueue(NSOperationQueue()){
                (data: CMMagnetometerData?, error: NSError?) in
                
                if let isError = error{
                    NSLog("Error: %@", isError)
                }
                valX = data!.magneticField.x
                valY = data!.magneticField.y
                valZ = data!.magneticField.z
                
                if values != nil{
                    values!(x: valX, y: valY, z: valZ)
                }
                let absoluteVal = sqrt(valX * valX + valY * valY + valZ * valZ)
                self.delegate?.retrieveMagnetometerValues!(valX, y: valY, z: valZ, absoluteValue: absoluteVal)
            }
            
        } else {
            NSLog("Magnetometer is not available")
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    /*  MARK :- DEVICE MOTION APPROACH STARTS HERE  */
    
    /*
    *  getDeviceMotionValues:interval:values:
    *
    *  Discussion:
    *   Starts device motion updates, providing data to the given handler through the given queue.
    *   Uses the default reference frame for the device. Examine CMMotionManager's
    *   attitudeReferenceFrame to determine this. You can access the retrieved values either by a
    *   Trailing Closure or through a Delegate.
    */
    public func getDeviceMotionObject (interval: NSTimeInterval = 0.1, values: ((deviceMotion: CMDeviceMotion) -> ())? ) {
        
        if hgMotionManager.deviceMotionAvailable{
            hgMotionManager.deviceMotionUpdateInterval = interval
            hgMotionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue()){
                (data: CMDeviceMotion?, error: NSError?) in
                
                if let isError = error{
                    NSLog("Error: %@", isError)
                }
                if values != nil{
                    values!(deviceMotion: data!)
                }
                self.delegate?.retrieveDeviceMotionObject!(data!)
            }
            
        } else {
            NSLog("Device Motion is not available")
        }
    }
    
    
    /*
    *   getAccelerationFromDeviceMotion:interval:values:
    *   You can retrieve the processed user accelaration data from the device motion from this method.
    */
    public func getAccelerationFromDeviceMotion (interval: NSTimeInterval = 0.1, values: ((x:Double, y:Double, z:Double) -> ())? ) {
        
        var valX: Double!
        var valY: Double!
        var valZ: Double!
        if hgMotionManager.deviceMotionAvailable{
            hgMotionManager.deviceMotionUpdateInterval = interval
            hgMotionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue()){
                (data: CMDeviceMotion?, error: NSError?) in
                
                if let isError = error{
                    NSLog("Error: %@", isError)
                }
                valX = data!.userAcceleration.x
                valY = data!.userAcceleration.y
                valZ = data!.userAcceleration.z
                
                if values != nil{
                    values!(x: valX, y: valY, z: valZ)
                }
                
                self.delegate?.getAccelerationValFromDeviceMotion!(valX, y: valY, z: valZ)
            }
            
        } else {
            NSLog("Device Motion is unavailable")
        }
    }
    
    /*
    *   getGravityAccelerationFromDeviceMotion:interval:values:
    *   You can retrieve the processed gravitational accelaration data from the device motion from this
    *   method.
    */
    public func getGravityAccelerationFromDeviceMotion (interval: NSTimeInterval = 0.1, values: ((x:Double, y:Double, z:Double) -> ())? ) {
        
        var valX: Double!
        var valY: Double!
        var valZ: Double!
        if hgMotionManager.deviceMotionAvailable{
            hgMotionManager.deviceMotionUpdateInterval = interval
            hgMotionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue()){
                (data: CMDeviceMotion?, error: NSError?) in
                
                if let isError = error{
                    NSLog("Error: %@", isError)
                }
                valX = data!.gravity.x
                valY = data!.gravity.y
                valZ = data!.gravity.z
                
                if values != nil{
                    values!(x: valX, y: valY, z: valZ)
                }
            
                _ = sqrt(valX * valX + valY * valY + valZ * valZ)
                self.delegate?.getGravityAccelerationValFromDeviceMotion!(valX, y: valY, z: valZ)
            }
            
        } else {
            NSLog("Device Motion is not available")
        }
    }
    
    
    /*
    *   getAttitudeFromDeviceMotion:interval:values:
    *   You can retrieve the processed attitude data from the device motion from this
    *   method.
    */
    public func getAttitudeFromDeviceMotion (interval: NSTimeInterval = 0.1, values: ((attitude: CMAttitude) -> ())? ) {
        
        if hgMotionManager.deviceMotionAvailable{
            hgMotionManager.deviceMotionUpdateInterval = interval
            hgMotionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue()){
                (data: CMDeviceMotion?, error: NSError?) in
                
                if let isError = error{
                    NSLog("Error: %@", isError)
                }
                if values != nil{
                    values!(attitude: data!.attitude)
                }
                
                self.delegate?.getAttitudeFromDeviceMotion!(data!.attitude)
            }
            
        } else {
            NSLog("Device Motion is not available")
        }
    }
    
    /*
    *   getRotationRateFromDeviceMotion:interval:values:
    *   You can retrieve the processed rotation data from the device motion from this
    *   method.
    */
    public func getRotationRateFromDeviceMotion (interval: NSTimeInterval = 0.1, values: ((x:Double, y:Double, z:Double) -> ())? ) {
        
        var valX: Double!
        var valY: Double!
        var valZ: Double!
        if hgMotionManager.deviceMotionAvailable{
            hgMotionManager.deviceMotionUpdateInterval = interval
            hgMotionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue()){
                (data: CMDeviceMotion?, error: NSError?) in
                
                if let isError = error{
                    NSLog("Error: %@", isError)
                }
                valX = data!.rotationRate.x
                valY = data!.rotationRate.y
                valZ = data!.rotationRate.z
                
                if values != nil{
                    values!(x: valX, y: valY, z: valZ)
                }
                
//                var absoluteVal = sqrt(valX * valX + valY * valY + valZ * valZ)
                _ = sqrt(valX * valX + valY * valY + valZ * valZ)
                self.delegate?.getRotationRateFromDeviceMotion!(valX, y: valY, z: valZ)
            }
            
        } else {
            NSLog("Device Motion is not available")
        }
    }
    
    
    /*
    *   getMagneticFieldFromDeviceMotion:interval:values:
    *   You can retrieve the processed magnetic field data from the device motion from this
    *   method.
    */
    public func getMagneticFieldFromDeviceMotion (interval: NSTimeInterval = 0.1, values: ((x:Double, y:Double, z:Double, accuracy: Int32) -> ())? ) {
        
        var valX: Double!
        var valY: Double!
        var valZ: Double!
        var valAccuracy: Int32!
        if hgMotionManager.deviceMotionAvailable{
            hgMotionManager.deviceMotionUpdateInterval = interval
            hgMotionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue()){
                (data: CMDeviceMotion?, error: NSError?) in
                
                if let isError = error{
                    NSLog("Error: %@", isError)
                }
                valX = data!.magneticField.field.x
                valY = data!.magneticField.field.y
                valZ = data!.magneticField.field.z
                valAccuracy = data!.magneticField.accuracy.rawValue
                
                
                if values != nil{
                    values!(x: valX, y: valY, z: valZ, accuracy: valAccuracy)
                }
                
                self.delegate?.getMagneticFieldFromDeviceMotion!(valX, y: valY, z: valZ)
            }
            
        } else {
            NSLog("Device Motion is not available")
        }
    }
    
    /*  MARK :- DEVICE MOTION APPROACH ENDS HERE    */
    
    
    /*
    *   From the methods hereafter, the sensor values could be retrieved at
    *   a particular instant, whenever needed, through a trailing closure.
    */
    
    /*  MARK :- INSTANTANIOUS METHODS START HERE  */
    
    public func getAccelerationAtCurrentInstant (values: (x:Double, y:Double, z:Double) -> ()){
        self.getAccelerationFromDeviceMotion(0.5) { (x, y, z) -> () in
            values(x: x,y: y,z: z)
            self.stopDeviceMotionUpdates()
        }
    }
    
    public func getGravitationalAccelerationAtCurrentInstant (values: (x:Double, y:Double, z:Double) -> ()){
        self.getGravityAccelerationFromDeviceMotion(0.5) { (x, y, z) -> () in
            values(x: x,y: y,z: z)
            self.stopDeviceMotionUpdates()
        }
    }
    
    public func getAttitudeAtCurrentInstant (values: (attitude: CMAttitude) -> ()){
        self.getAttitudeFromDeviceMotion(0.5) { (attitude) -> () in
            values(attitude: attitude)
            self.stopDeviceMotionUpdates()
        }
        
    }
    
    public func getMageticFieldAtCurrentInstant (values: (x:Double, y:Double, z:Double) -> ()){
        self.getMagneticFieldFromDeviceMotion(0.5) { (x, y, z, accuracy) -> () in
            values(x: x,y: y,z: z)
            self.stopDeviceMotionUpdates()
        }
    }
    
    public func getGyroValuesAtCurrentInstant (values: (x:Double, y:Double, z:Double) -> ()){
        self.getRotationRateFromDeviceMotion(0.5) { (x, y, z) -> () in
            values(x: x,y: y,z: z)
            self.stopDeviceMotionUpdates()
        }
    }

    
    
    
        /*  MARK :- INSTANTANIOUS METHODS END HERE  */
    
    /**
    停止重量加速度监听
    */
    func  stopAccelerometerUpdates(){
        hgMotionManager.stopAccelerometerUpdates()
        print("停止监听重力加速度")
    }
    
    /**
    停止监听陀螺仪
    */
    public func stopGyroUpdates(){
        hgMotionManager.stopGyroUpdates()
        print("停止监听陀螺仪")
    }
    
    
    /*
    *  stopDeviceMotionUpdates
    *
    *  Discussion:
    *   Stops device motion updates.
    */
    public func stopDeviceMotionUpdates() {
        hgMotionManager.stopDeviceMotionUpdates()
        NSLog("Device Motion Updates Status - Stopped")
    }
    
    /*
    *  stopMagnetometerUpdates
    *
    *  Discussion:
    *   Stops magnetometer updates.
    */
    @available(iOS, introduced=5.0)
    public func stopmagnetometerUpdates() {
        hgMotionManager.stopMagnetometerUpdates()
        NSLog("Magnetometer Updates Status - Stopped")
    }

    
    
    
    
    
    
}