# DataListing
A Simple Data Listing app

Requirements to compile and run program

Support given from iOS 10 and above.
Used Xcode 9.1 and swift 4
Supports iPhone X and devices below till iPhone 5
Supports both orientations - landscape & Portait

Architecture Pattern Used -

Made use of MVVM Architecture.
Used in both Detail Page Implementation and Listing Page Implementation
Classes name -
ContactDetailViewController, ContactDetailViewModel
ContactsListViewController, ContactListViewModel

Used this implementation because it involves with lot of logic for data being displayed on the controllers.Hence helping to make the controllers light and pass on the apt amount of data to the controllers.

Utilised protocol oriented programming along with MVVM which gives out best in implementation.

Complex solution/algorithms for some feature -

func generateHeaderAndRowSetForList() -
For getting the set of positions from the large response and sorting the same made use of - map functionality and then used Set to get unique items of positions, utilised sorted functionality to sort.

For getting the group of employees under each group made use of filter functionality by validating for employee position , later making use of sort functionality to sort employees based on last names.

Both the results are stored as tuple within an array.

Other implementation -

func generateSetForSearchedString()
func checkContactAvailibility()
Implemented Search using searchcontroller.

Usage of third party library is being limited only to Reachability being used.

