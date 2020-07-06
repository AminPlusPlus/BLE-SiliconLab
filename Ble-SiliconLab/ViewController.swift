//
//  ViewController.swift
//  Ble-SiliconLab
//
//  Created by Aminjoni Abdullozoda on 7/3/20.
//  Copyright © 2020 Aminjoni Abdullozoda. All rights reserved.
//

/// Environmental Sensing (org.bluetooth.service.environmental_sensing)
let EnvironmentalSensing = CBUUID(string: "0x181A")
let AutomationIO = CBUUID(string: "0x1815")

import UIKit
import CoreBluetooth
class ViewController: UIViewController {
    
    //MARK:-UI Elements
    @IBOutlet weak var batteryImage : UIImageView!
    @IBOutlet weak var lightSwitch : UISwitch!
    
    
    //MARK:- CBluetooth
    var cbCentralManager : CBCentralManager!
    var peripheral : CBPeripheral?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        //Start manager
        cbCentralManager = CBCentralManager(delegate: self, queue: nil)
                
    }
}


