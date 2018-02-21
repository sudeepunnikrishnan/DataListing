//
//  ContactDetailViewController.swift
//  Employee Directory
//
//  Created by Sudeep.Unnikrishnan on 22/12/17.
//  Copyright © 2017 Sudeep Unnikrishnan. All rights reserved.
//

import UIKit

class ContactDetailViewController: BaseViewController {
    
    @IBOutlet private weak var nameLbl: UILabel!
    @IBOutlet private weak var nameRoundedLbl: UILabel!
    @IBOutlet private weak var positionLbl: PaddingLabel!
    @IBOutlet private weak var mobileTitlLbl: UILabel!
    @IBOutlet private weak var mobileLbl: UILabel!
    @IBOutlet private weak var emailTitleLbl: UILabel!
    @IBOutlet private weak var emailLbl: UILabel!
    @IBOutlet private weak var projectCount: UILabel!
    var viewModel : ContactDetailViewModel!
    @IBOutlet private weak var projectOverViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var projectContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var viewInContactsHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var projectNameContainer: UIView!
    
    class func loadViewController() -> ContactDetailViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ContactDetailViewController") as! ContactDetailViewController
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configure(){
        NotificationCenter.default.addObserver(self, selector: #selector(ContactDetailViewController.orientationDidChange(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        configureUI()
    }
    
    func configureUI(){
        updateNavigation()
        nameLbl.text = viewModel.name
        nameRoundedLbl.text = viewModel.iconLetter
        positionLbl.text = "     " + viewModel.position + "     "
        mobileTitlLbl.text = "mobile"
        mobileLbl.text = viewModel.mobile
        emailTitleLbl.text = "email"
        emailLbl.text = viewModel.email
        if !viewModel.isContactAvailable{
            viewInContactsHeightConstraint.constant = 0
        }
        if viewModel.projectCount == "0"{
            projectOverViewHeightConstraint.constant = 0
            projectContainerHeightConstraint.constant = 0
        }else{
            projectCount.text = viewModel.projectCount
            createProjectListView()
        }
        
        
    }
    
    @objc func orientationDidChange(_ notification : Notification) {
        createProjectListView()
    }
    
    func updateNavigation(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = Colors.PrimaryThemeColor
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = Colors.PrimaryThemeColor
    }
    
    
    func createProjectListView(){
        if let _ = viewModel.projects {
            var offset  : CGFloat = 14
            var topView : CGFloat = 20
            let lineSpacing : CGFloat = 10
            let innerLabelPadding : CGFloat = 16
            let betweenViews : CGFloat = 6
            let labelHeight : CGFloat = 30
            var  row : CGFloat = 0
            
            projectNameContainer.subviews.forEach { $0.removeFromSuperview() }
            for project in viewModel.projects!{
                let label = UILabel.init()//PaddingLabel.init(padding: UIEdgeInsetsMake(5, 16, 16, 5))
                label.text = project
                label.backgroundColor = UIColor.white
                label.textColor = Colors.PrimaryThemeColor
                label.font = UIFont.systemFont(ofSize: 11, weight: .medium)
                label.border_Width = 1.0
                label.border_Color = Colors.PrimaryThemeColor
                label.textAlignment = .center
                projectNameContainer.addSubview(label)
                label.layoutIfNeeded()
                if label.intrinsicContentSize.width + betweenViews + offset + 20 > view.frame.width{
                    row += 1
                    topView += lineSpacing + labelHeight //row height plus vertical offset
                    offset = 14 //horizontal initial offset
                }
                
                label.frame = CGRect.init(origin: CGPoint(x:offset,y:topView), size:CGSize.init(width: label.intrinsicContentSize.width + innerLabelPadding, height: labelHeight) ) //16 for padding
                offset += label.intrinsicContentSize.width + betweenViews + innerLabelPadding //16 for padding
                label.corner_Radius = labelHeight/2 // height/2
                projectContainerHeightConstraint.constant = topView + labelHeight + lineSpacing
            }
            projectNameContainer.layoutSubviews()
            projectNameContainer.layoutIfNeeded()
        }
    }
    @IBAction func viewInContactsAction(_ sender: Any) {
        if viewModel.contact != nil {
            showContactsPage(contact: viewModel.contact!)
        }
    }
}
