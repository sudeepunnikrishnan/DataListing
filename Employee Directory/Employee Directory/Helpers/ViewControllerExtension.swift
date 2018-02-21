//
//  ViewControllerExtension.swift
//  Employee Directory
//
//  Created by Sudeep.Unnikrishnan on 22/12/17.
//  Copyright © 2017 Sudeep Unnikrishnan. All rights reserved.
//


import UIKit
import Reachability

extension UIViewController {
    func showAlert(title: String?, message: String?) {
        let alerController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alerController.addAction(cancelAction)
        present(alerController, animated: true, completion: nil)
    }
    
    
    func showProgress(_ disableAll:Bool = false) {
        view.showActivity(disableAll)
    }
    
    func hideProgress() {
        view.hideActivity()
    }
    
    func showErrorAlert(message: String){
        showAlert(title: "Error!", message: message)
    }
    
    func showSucessAlert(message: String){
        showAlert(title: "Success!", message: message)
    }
    
    var isNetWorkAvailable: Bool {
        if Reachability()!.connection != .none{
            return true
        }else{
            showAlert(title: "NO INTERNET", message: "It seems you are not connected to internet.Please connect and retry again")
            return false
        }
    }
}
