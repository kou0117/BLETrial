//
//  ViewController.swift
//  BluetoothWithIos
//
//  Created by kotaroharada on 2018/03/05.
//  Copyright © 2018年 kou0117. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {

    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral!
    
    @IBOutlet var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    @IBAction func startButtonTapped(_ sender: Any) {
        centralManager.scanForPeripherals(withServices:nil, options: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print(central.state)
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(RSSI)
        print(peripheral)
        
        self.peripheral = peripheral
        centralManager.connect(self.peripheral, options: nil)
        centralManager.stopScan()
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("peripheral connected")
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("services discovered")

        guard let services = peripheral.services else {
            abort()
        }
        
        for obj in services {
            peripheral.discoverCharacteristics(nil, for: obj)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("characteristics discovered")

        let characteristics = service.characteristics!
        
        for characteristic in characteristics  {
            self.peripheral.readValue(for: characteristic)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("got value")

        guard let value = characteristic.value else {
            print("value is nil")
            return
        }
        print(value)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("disconnected")
    }
}
