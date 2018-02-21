//
//  AddressBookManager.swift
//  Employee Directory
//
//  Created by Sudeep.Unnikrishnan on 22/12/17.
//  Copyright © 2017 Sudeep Unnikrishnan. All rights reserved.
//

import AddressBook
import Contacts
import ContactsUI

class AddressBookManager: NSObject {
    static let sharedInstance = AddressBookManager()
    fileprivate override init() {}
    
    fileprivate var _contacts:[UserContact]?
    fileprivate(set) open var contacts:[UserContact]? {
        get {
            if needToLoadContacts() {
                self._contacts = allContactsFromAddressBook()
            }
            return _contacts
        }
        set {
            _contacts = newValue
        }
    }
    
    open func findContactWithPhoneNumber(_ phoneNumber:String) -> UserContact? {
        let predicate:NSPredicate = NSPredicate(format: "numbers contains %@", phoneNumber)
        let contact: UserContact? = contacts?.filter{predicate.evaluate(with: $0)}.last
        return contact
    }
    
    open func findContactWithName(_ name:String?) -> UserContact? {
        if(name != nil){
        let predicate:NSPredicate = NSPredicate(format: "name like[c] %@", name!)
        let contact: UserContact? = contacts?.filter{(predicate.evaluate(with: $0))}.last
        return contact
        }
        return nil
    }
    
    open func findContactWithNameParameters(_ fname:String?,lname:String?) -> UserContact? {
        if(fname != nil && lname != nil){
            let predicate:NSPredicate = NSPredicate(format: "fName like[c] %@ && lName like[c] %@ ", fname!,lname!)
            let contact: UserContact? = contacts?.filter{(predicate.evaluate(with: $0))}.last
            return contact
        }
        return nil
    }
    
    open func findContactWithEmail(_ email:String) -> UserContact? {
        let predicate:NSPredicate = NSPredicate(format: "emails contains %@", email)
        let contact: UserContact? = contacts?.filter{predicate.evaluate(with: $0)}.last
        return contact
    }
    
    open func askForPermission() {
            askContactPermission()
    }
    
    fileprivate func allContactsFromAddressBook() -> [UserContact]? {
        return fetchContacts()
    }
    
    fileprivate func needToLoadContacts() -> Bool {
        
        var load = false
        let status:CNAuthorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        if _contacts == nil && (status == CNAuthorizationStatus.authorized || status == CNAuthorizationStatus.notDetermined) {
            load = true
        }
        
        return load
    }
    
    func askContactPermission() {
        let store = CNContactStore()
        
        if CNContactStore.authorizationStatus(for: .contacts) == .notDetermined {
            store.requestAccess(for: .contacts, completionHandler: { (authorized: Bool, error: Error?) -> Void in
                
            })
        }
    }
    
    func fetchContacts() -> [UserContact]? {
        
        var contacts: [UserContact]?
        let store = CNContactStore()
        
        if CNContactStore.authorizationStatus(for: .contacts) == .authorized {
            contacts = retrieveContactsWithStore(store)
        }
        
        return contacts
    }
    
    func retrieveContactsWithStore(_ store: CNContactStore) -> [UserContact]? {
        
        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactEmailAddressesKey,
            CNContactPhoneNumbersKey,CNContactViewController.descriptorForRequiredKeys()] as [Any]
        
        // Get all the containers
        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }
        
        var rawContacts: [CNContact] = []
        
        // Iterate all containers and append their contacts to our results array
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            
            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                rawContacts.append(contentsOf: containerResults)
            } catch {
                print("Error fetching results for container")
            }
        }
        
        let formatter = CNContactFormatter()
        var contacts: [UserContact]? = nil
        
        if rawContacts.count > 0 {
            contacts = [UserContact]()
        }
        
        for rawContact in rawContacts {
            var contact:UserContact = UserContact()
            contact.name = formatter.string(from: rawContact)
            
            if nil != contact.name {
                var phoneNumbers:[String] = [String]()
                var emails:[String] = [String]()
                
                contact.fName = rawContact.givenName
                contact.lName = rawContact.familyName
                
                for rawPhoneNumber in rawContact.phoneNumbers {
                    let phoneNumber:CNPhoneNumber = rawPhoneNumber.value
                    phoneNumbers.append(phoneNumber.stringValue)
                }
                for rawEmail in rawContact.emailAddresses {
                    let email : String = String(rawEmail.value)
                    emails.append(email)
                }
                contact.numbers = phoneNumbers
                contact.emails = emails
                contact.contactInfo = rawContact
                contacts?.append(contact)
            }
        }
        
        return contacts
    }
}
