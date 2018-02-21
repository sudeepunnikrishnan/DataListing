//
//  ContactsListCell.swift
//  Employee Directory
//
//  Created by Sudeep.Unnikrishnan on 23/12/17.
//  Copyright © 2017 Sudeep Unnikrishnan. All rights reserved.
//

import UIKit

protocol CellRepresentable {
    static func registerCell(tableView: UITableView)
    func dequeueCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func cellSelected()
}

class ContactsListCell: UITableViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var viewInContactsBtn: UIButton!
    @IBOutlet weak var lastNameRoundedLbl: UILabel!
    var contactAction: (() -> Void)?
    @IBOutlet weak var btnWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Public
    func setup(viewModel: ContactsListCellViewModel) {
        nameLbl.text = viewModel.name
        emailLbl.text = viewModel.email
        lastNameRoundedLbl.text = String(viewModel.iconLetter)
        viewInContactsBtn.isHidden = !(viewModel.isContactAvailable)
        btnWidthConstraint.constant = viewModel.isContactAvailable ? 108 : 0
        bringSubview(toFront: viewInContactsBtn)
        contactAction = { 
            viewModel.contactAction()
        }
    }
    
    @IBAction func viewInContactsAction(sender:UIButton){
        contactAction?()
    }

}
