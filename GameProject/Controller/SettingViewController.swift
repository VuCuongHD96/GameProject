//
//  SettingViewController.swift
//  GameProject
//
//  Created by nguyen viet hoang on 9/10/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import GoogleSignIn

class SettingViewController: UIViewController {

    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var etTime: UITextField!
    
    typealias handler = (Int, Int) -> ()
    var passData: handler?
    
    var pickerData = [10 ,20 , 30, 40]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        setViewButton()
        setTextField()
    }

    func  initView(){
        self.picker.delegate = self
        self.picker.dataSource = self
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
        let index = picker.selectedRow(inComponent: 0)
        var setTime = etTime.text!
        
        if setTime.isEmpty {
            setTime = "10"
//            guard let vc = self.storyboard?.instantiateViewController(identifier: "categoryScreen") as? CategoryViewController else {
//                 return
//             }
//            vc.timeToPlay = Int(setTime) ?? 0
//            vc.numberOfQuestion = Int(pickerData[index]) ?? 0
//            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            let time = Int(setTime)!
            if (time >= 10) {
//                guard let vc = self.storyboard?.instantiateViewController(identifier: "categoryScreen") as? CategoryViewController else {
//                     return
//                 }
//                 vc.timeToPlay = Int(setTime) ?? 0
//                 vc.numberOfQuestion = Int(pickerData[index]) ?? 0
//                self.navigationController?.pushViewController(vc, animated: true)
                
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
