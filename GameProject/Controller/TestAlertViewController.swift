//
//  TestAlertViewController.swift
//  GameProject
//
//  Created by nguyen viet hoang on 9/11/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit

class TestAlertViewController: UIViewController {

   
    private let myArray: NSArray = ["First","Second","Third"]
    private var myTableView: UITableView!
    @IBOutlet weak var btnSetting: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
//    func setViewTable () {
//        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
//        let displayWidth: CGFloat = self.view.frame.width
//        let displayHeight: CGFloat = 300
//
//        myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
//        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
//        myTableView.dataSource = self
//        myTableView.delegate = self
//        self.view.addSubview(myTableView)
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("Num: \(indexPath.row)")
//        print("Value: \(myArray[indexPath.row])")
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return myArray.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
//        cell.textLabel!.text = "\(myArray[indexPath.row])"
//        return cell
//    }
//
//    @IBAction func clickSetting(_ sender: Any) {
//       showalert()
//
//    }
//    func showalert () {
//        let alert = UIAlertController(title: "Setting", message: "", preferredStyle: .actionSheet)
//
//        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
//
//        self.present(alert, animated: true)
//    }
}
