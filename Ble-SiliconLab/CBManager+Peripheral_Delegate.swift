//
//  CBManagerDelegate.swift
//  Ble-SiliconLab
//
//  Created by Aminjoni Abdullozoda on 7/3/20.
//  Copyright © 2020 Aminjoni Abdullozoda. All rights reserved.
//

import Foundation
import CoreBluetooth

extension ViewController :  CBCentralManagerDelegate {
    
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
           peripheral.discoverServices(nil)
           peripheral.delegate = self
       }
       
       func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
           print("Disconnected : \(peripheral.name ?? "No Name")")
           cbCentralManager.scanForPeripherals(withServices: nil, options: nil)
       }
}


//MARK:- CBPeripheralDelegate
extension ViewController : CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
       if let services = peripheral.services {
        for service in services {
            
            if service.uuid == AutomationIO {
                   //environment found
                   print(service.uuid.uuidString)
                peripheral.discoverCharacteristics(nil, for: service)
               
            }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        if let charac = service.characteristics {
            for chactecteristics in charac {
                print(chactecteristics)
            }
        }
        
    }
    
}
