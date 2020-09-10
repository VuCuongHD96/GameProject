//
//  SettingViewController.swift
//  GameProject
//
//  Created by nguyen viet hoang on 9/10/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var isSelected = pickerData[row]
        //print(isSelected)
    }
    

    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var etTime: UITextField!
    
    var pickerData : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.picker.delegate = self
        self.picker.dataSource = self
        pickerData = ["10" ,"20", "30", "40"]
        
    }
    @IBAction func savedSetting(_ sender: Any) {
        var a = picker.selectedRow(inComponent: 0)
        var setTime = etTime.text
        print(pickerData[a])
        print(setTime)
    }
}
