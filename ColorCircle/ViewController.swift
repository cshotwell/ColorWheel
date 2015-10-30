//
//  ViewController.swift
//  ColorCircle
//
//  Created by Carl Shotwell on 10/4/14.
//  Copyright (c) 2014 carl. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ESTBeaconManagerDelegate
{

    let beaconManager : ESTBeaconManager = ESTBeaconManager()
    let BEACONS : [NSNumber : String] =
    [   45711 : "RED",
        45031 : "GREEN",
        34611 : "BLUE" ]
    let distanceBetweenBeacons = 4.41

    var redValue : Double = 0.0
    var blueValue : Double = 0.0
    var greenValue : Double = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        beaconManager.delegate = self
    
        var beaconRegion : ESTBeaconRegion = ESTBeaconRegion(proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, identifier: "regionName")
        
        beaconManager.startEstimoteBeaconsDiscoveryForRegion(beaconRegion)

    }

    
func beaconManager(manager: ESTBeaconManager!, didDiscoverBeacons beacons: [AnyObject]!, inRegion region: ESTBeaconRegion!) {
    if (beacons.count > 0) {
            updateColorValues(beacons as! [ESTBeacon])
            updateBackgroundColor()
        }
    }
    
    func updateColorValues(beacons: [ESTBeacon]) {
        
        for i in 0..<beacons.count {
            var intensity : Double = findColorIntensity(estimateBeaconDistance(beacons[i]))
            switch BEACONS[beacons[i].major] as String? {
            case "RED"?:
                redValue = intensity
            case "GREEN"?:
                greenValue = intensity
            case "BLUE"?:
                blueValue = intensity
            default:
                print("nothing")
            }
//            println("\(beacons[i].rssi) \(beacons[i].measuredPower) \(BEACONS[beacons[i].major])")
            print("\(estimateBeaconDistance(beacons[i] as ESTBeacon))")
        }

    }

    func findColorIntensity(estimatedDistance: Double) -> Double {
        var intensity = ((distanceBetweenBeacons - estimatedDistance) / distanceBetweenBeacons)
        return intensity
    }
    
    func updateBackgroundColor() {
        var color : UIColor = UIColor(red: CGFloat(redValue), green: CGFloat(greenValue), blue: CGFloat(blueValue), alpha: 1.0)
        self.view.backgroundColor = color
    }
    
    func estimateBeaconDistance(beacon: ESTBeacon) -> Double {
        let ratio:Int = beacon.measuredPower as Int - beacon.rssi
        
        var ratio_db = Double(ratio);
        
        var lhs = 10.0
        var rhs = ratio_db / 10.0
        
        var ratio_linear = pow(lhs, rhs)
        
        var r = sqrt(ratio_linear);
        
        return r;
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
