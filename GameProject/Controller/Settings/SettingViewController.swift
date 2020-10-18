//
//  SettingViewController.swift
//  GameProject
//
//  Created by nguyen viet hoang on 9/10/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import GoogleSignIn
import Reusable

class SettingViewController: UIViewController {
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var etTime: UITextField!
    
    typealias handler = (Int, Int) -> ()
    var passData: handler?
    
    var pickerData = [10 ,20 , 30, 40]
    private var tableView: SettingTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        setViewButton()
        setTextField()
        guard let tableView = children.first as? SettingTableViewController else {
            return
        }
        self.tableView = tableView
        
    }
    
    func initView() {
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.etTime.delegate = self
        navigationItem.title = "Settings"
    }
    
    func setViewButton() {
        btnSave.layer.cornerRadius = 15
        btnSave.layer.borderColor = UIColor.white.cgColor
        btnSave.layer.borderWidth = 3
    }
    
    func setTextField() {
        var placeHolder = NSMutableAttributedString()
        let placeHolderText  = "10"
        placeHolder = NSMutableAttributedString(string:placeHolderText, attributes: [NSAttributedString.Key.font:UIFont(name: "Helvetica", size: 20.0)!])
        etTime.attributedPlaceholder = placeHolder
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func savedSetting(_ sender: Any) {
        let index = pickerView.selectedRow(inComponent: 0)
        var setTime = etTime.text!
        
        if setTime.isEmpty {
            setTime = "10"
        }
        else {
            let time = Int(setTime)!
            if (time >= 10) {
            }
            else {
                let alert = UIAlertController(title: "Thời gian quá ngắn", message: "Vui lòng nhập thời gian lớn hơn 10 giây", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
                self.present(alert, animated: true)
                return
            }
        }
        passData?(pickerData[index], Int(setTime)!)
        navigationController?.popViewController(animated: true)
    }
}

extension SettingViewController: UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(pickerData[row])
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = "0123456789"
        let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
        let typedCharacterSet = CharacterSet(charactersIn: string)
        return allowedCharacterSet.isSuperset(of: typedCharacterSet)
    }
}
