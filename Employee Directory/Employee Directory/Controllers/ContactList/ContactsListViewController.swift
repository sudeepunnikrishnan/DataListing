//
//  ContactsListViewController.swift
//  Employee Directory
//
//  Created by Sudeep.Unnikrishnan on 22/12/17.
//  Copyright © 2017 Sudeep Unnikrishnan. All rights reserved.
//

import UIKit

class ContactsListViewController: BaseViewController {
    
    //for Search
    
    
    @IBOutlet weak var contactTableView: UITableView!
    var refreshControl = UIRefreshControl()
    var searchModeOn : Bool = false
    var viewModel: ContactListViewModel = ContactListViewModel()
    let searchController = UISearchController(searchResultsController: nil)
    var isFromClearBtn : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        AddressBookManager.sharedInstance.askForPermission()
        configure()
    }
    
    func configure(){
        linkViewModel()
        configureUI()
        configureData()
    }
    
    func configureData(){
        addObservers()
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Data...")
        refreshControl.addTarget(self, action:#selector(refresh), for: UIControlEvents.valueChanged)
        contactTableView.addSubview(refreshControl)
        fetchData()
    }
    
    func fetchData(){
        showProgress()
        if isNetWorkAvailable {
            viewModel.fetchEmployeeData()
        }else{
            refreshControl.endRefreshing()
            hideProgress()
        }
    }
    
    @objc func refresh(sender:AnyObject) {
        if searchModeOn{
            fetchData()
        }else{
            refreshControl.endRefreshing()
        }
    }
    
    func configureUI(){
        searchController.searchBar.delegate = self 
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        contactTableView.tableHeaderView = searchController.searchBar
    }
    
    //MARK: - ViewModel
    private func linkViewModel() {
        viewModel.updateView = { [weak self]  in
            self?.hideProgress()
            if (self?.refreshControl.isRefreshing)! {
                self?.refreshControl.endRefreshing()
            }
            self?.viewModelDidUpdate()
        }
        viewModel.errorInData = { [weak self] errorString in
            self?.hideProgress()
            if (self?.refreshControl.isRefreshing)! {
                self?.refreshControl.endRefreshing()
            }
            self?.viewModelDidError(errorString: errorString)
        }
        viewModel.didSelectEmployee = { [weak self] employee in
            self?.showDetailPage(employee: employee)
        }
        viewModel.showContactPage = { [weak self] contact in
            self?.showContactsPage(contact:contact)
        }
    }
    private func viewModelDidUpdate() {
        hideProgress()
        contactTableView.reloadData()
        if searchModeOn && viewModel.filtered.count == 0 {
            searchController.showAlert(title: nil, message: "NO MATCHING DATA")
        }
        
    }
    private func viewModelDidError(errorString: String) {
        showAlert(title: "Error", message: errorString)
    }
    
    func showDetailPage(employee : Employee){
        let viewController = ContactDetailViewController.loadViewController()
        viewController.viewModel = ContactDetailViewModel.init(employee: employee)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.dismiss(animated: false, completion: nil)
    }
    
   
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(ContactsListViewController.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ContactsListViewController.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let keyboardSize = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        var inset = contactTableView.contentInset
        inset.bottom = keyboardSize.height
        contactTableView.contentInset = inset
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if #available(iOS 11, *)
        {
            contactTableView.contentInset = UIEdgeInsets.zero
        }else{
            print(contactTableView.contentInset)
            var inset = contactTableView.contentInset
            inset.bottom = 0
            contactTableView.contentInset = inset
        }
    }
    
}

extension ContactsListViewController: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if searchModeOn {
            return 0
        }
        return 29
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: view.frame.width, height: 29)))
        let titleLabel = UILabel.init(frame: CGRect(origin: CGPoint(x: 20, y: 0), size: CGSize(width: view.frame.width, height: 29)))
        titleLabel.backgroundColor = UIColor.color(red: 249, green: 249, blue: 254.0)
        headerView.backgroundColor = UIColor.color(red: 249, green: 249, blue: 254.0)
        titleLabel.text = viewModel.groupedContactList[section].position
        titleLabel.frame.size = CGSize.init(width: view.frame.width, height: 29)
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        titleLabel.textColor = Colors.PrimaryThemeColor
        headerView.addSubview(titleLabel)
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if searchModeOn {
            return 1
        }
        return viewModel.groupedContactList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchModeOn {
            return viewModel.filtered.count
        }
        return viewModel.groupedContactList[section].list.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchModeOn && viewModel.filtered.count > 0 {
            return viewModel.filtered[indexPath.row]
                .dequeueCell(tableView: tableView, indexPath: indexPath)
        }
        return viewModel.groupedContactList[indexPath.section].list[indexPath.row]
            .dequeueCell(tableView: tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchModeOn && viewModel.filtered.count > 0 {
            searchController.isActive = false; // Add this !
            viewModel.filtered[indexPath.row].cellSelected()
        }else{
            viewModel.groupedContactList[indexPath.section].list[indexPath.row].cellSelected()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            searchModeOn = true
        }else{
            if (searchController.searchBar.text?.isEmpty)! && !isFromClearBtn{
                searchModeOn = true
            }else{
                isFromClearBtn = false
                searchModeOn = false;
            }
        }
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            searchModeOn = true
        }else{
            searchModeOn = false;
            contactTableView.reloadData()
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchModeOn = false;
        contactTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchModeOn = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            searchModeOn = false;
            isFromClearBtn = true
            contactTableView.reloadData()
        }
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            searchModeOn = true;
            viewModel.generateSetForSearchedString(searchText: searchText)
        }
    }
    
    @objc func hideKeyboardWithSearchBar(bar:UISearchBar) {
        bar.resignFirstResponder()
        
    }
    
}


