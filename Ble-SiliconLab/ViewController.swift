//
//  ViewController.swift
//  Ble-SiliconLab
//
//  Created by Aminjoni Abdullozoda on 7/3/20.
//  Copyright © 2020 Aminjoni Abdullozoda. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController {

    var cbCentralManager : CBCentralManager!
    var peripheral : CBPeripheral?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cbCentralManager = CBCentralManager(delegate: self, queue: nil)
        
        
    }
}


extension ViewController : CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        if central.state == .poweredOn {
            central.scanForPeripherals(withServices: nil, options: nil)
            print("Scanning...")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        guard peripheral.name != nil else {return}
        if peripheral.name! == "Thunder Sense #33549" {
            print("Sensor Found!")
            print(advertisementData)
            //stopScan
            cbCentralManager.stopScan()
            //connect
            cbCentralManager.connect(peripheral, options: nil)
            self.peripheral = peripheral
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected : \(peripheral.name ?? "No Name")")
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected : \(peripheral.name ?? "No Name")")
        cbCentralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    
}

