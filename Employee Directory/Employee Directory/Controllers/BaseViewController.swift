//
//  ViewController.swift
//  Employee Directory
//
//  Created by Sudeep.Unnikrishnan on 22/12/17.
//  Copyright © 2017 Sudeep Unnikrishnan. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showContactsPage(contact:CNContact){
        DispatchQueue.main.async() {[weak self] () ->  Void in
            guard let `self` = self else {return}
            let contactViewController = CNContactViewController.init(for: contact)
            contactViewController.contactStore = CNContactStore()
            self.navigationController?.pushViewController(contactViewController, animated: true)
        }
        
    }
}

