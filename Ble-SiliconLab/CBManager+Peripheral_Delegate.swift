//
//  CBManagerDelegate.swift
//  Ble-SiliconLab
//
//  Created by Aminjoni Abdullozoda on 7/3/20.
//  Copyright © 2020 Aminjoni Abdullozoda. All rights reserved.
//

import Foundation
import CoreBluetooth

let Temperature = CBUUID(string: "0x2A6E")
let Digital = CBUUID(string: "0x2A56")

fileprivate var ledMask: UInt8    = 0
fileprivate let digitalBits = 2 // TODO: each digital uses two bits


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
               
                if chactecteristics.uuid == Digital {
                     print("Digital : \(chactecteristics)")
                     setDigitalOutput(1, on: true, characteristic: chactecteristics)
                    //peripheral.readValue(for: chactecteristics)
               }
               
               
            }
        }
        
    }
    

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
            if characteristic.uuid == Temperature {
                           print("Temp : \(characteristic)")
                let temp = characteristic.tb_uint16Value()
             
                print(Double(temp!) / 100)
            }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        print("WRITE VALUE : \(characteristic)")
    }
    
//    func writeValueForCharacteristic(_ uuid: CBUUID, value: Data) {
//        guard let characteristics = self.findCharacteristics(uuid, properties: .write) else {
//            return
//        }
//
//        characteristics.forEach({
//            log.debug("writing value to characteristic \($0)")
//            self.cbPeripheral.writeValue(value, for: $0, type: .withResponse)
//        })
//    }
   
    fileprivate func setDigitalOutput(_ index: Int, on: Bool, characteristic  :CBCharacteristic) {
           let shift = UInt(index) * UInt(digitalBits)
           var mask = ledMask
           
           if on {
               mask = mask | UInt8(1 << shift)
           }
           else {
               mask = mask & ~UInt8(1 << shift)
           }
           
           let data = Data(bytes: [mask])
            self.peripheral?.writeValue(data, for: characteristic, type: .withResponse)
           //self.bleDevice.writeValueForCharacteristic(CBUUID.Digital, value: data)
           
           // *** Note: sending notification optimistically ***
           // Since we're writing the full mask value, LILO applies here,
           // and we *should* end up consistent with the device. Waiting to
           // read back after write causes rubber-banding during fast write sequences. -tt
           ledMask = mask
          // notifyLedState()
       }
    
}

extension CBCharacteristic  {
   func tb_int16Value() -> Int16? {
        if let data = self.value {
            var value: Int16 = 0
            (data as NSData).getBytes(&value, length: 2)
            
            return value
        }
        
        return nil
    }
    func tb_uint16Value() -> UInt16? {
        if let data = self.value {
            var value: UInt16 = 0
            (data as NSData).getBytes(&value, length: 2)
            
            return value
        }
        
        return nil
    }
}
