//
//  ContactsTableViewController.swift
//  ContactApp
//
//  Created by user238354 on 4/10/23.
//

import UIKit
import CoreData

class ContactsTableViewController: UITableViewController {
    @objc func addButtonTapped(){
        print("Adding contact")
    }
    //let contacts =    ["Jim","John","Dana","Rosie","Jeremy","Sarah","Matt","Joe","Donald","Jeff"]
    var contacts:[NSManagedObject] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        title = "Contacts"
        loadDataFromDatabase()
        tableView.reloadData()
       // let addContact = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        //self.navigationItem.rightBarButtonItem = addContact
        
            // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

      
         self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadDataFromDatabase()
        tableView.reloadData()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //DIspose of resources that can be recreated
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditContact"{
            let contactController = segue.destination as? ContactsViewController
            let selectedRow = self.tableView.indexPath(for: sender as! UITableViewCell)?.row
            let selectedContact = contacts[selectedRow!] as? Contact
            contactController?.currentContact = selectedContact!
        }
    }
    func loadDataFromDatabase(){
        
        let settings = UserDefaults.standard
        let sortField = settings.string(forKey: Constants.kSortField)
        let sortAscending = settings.bool(forKey: Constants.kSortDirectionAscending)
        
        let context = appDelegate.persitentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "Contact")
        
        let sortDescriptor = NSSortDescriptor(key: sortField, ascending: sortAscending)
        let sortDescriptiorArray = [sortDescriptor]
        request.sortDescriptors = sortDescriptiorArray
        
        do {
            contacts = try context.fetch(request)
        }catch let error as NSError {
            print("Cound not fetch. \(error),\(error.userInfo)")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }  

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return contacts.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"ContactsCell", for: indexPath)
//Configure the cell
        let contact = contacts[indexPath.row] as? Contact
        
        
        cell.textLabel?.text =  "\(contact?.name ?? "") from \(contact?.city ?? "")"
        
        let dateformat = DateFormatter()
        dateformat.dateFormat = "MMM dd, yyyy"
        
        if let birthday = contact?.birthday {
            let birthdayString = dateformat.string(from: birthday)
            cell.detailTextLabel?.text = "Born on: \(birthdayString)"
        }
        
        
        //cell.detailTextLabel?.text = contact?.city
        cell.accessoryType = UITableViewCell.AccessoryType.detailDisclosureButton
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            let contact = contacts[indexPath.row] as? Contact
            let context = appDelegate.persitentContainer.viewContext
            context.delete(contact!)
            do {
                try context.save()
            }
            catch {
                fatalError("Error saving context: \(error)")
            }
            loadDataFromDatabase()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert{
            //create a new instance of the appropiate clasee, insert it into the array
            // and add a new row to the table
        }
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedContact = contacts[indexPath.row] as? Contact
        let name = selectedContact!.name!
        let actionHandler = { (action:UIAlertAction!) -> Void in
            self.performSegue(withIdentifier: "EditContact", sender:tableView.cellForRow(at: indexPath))
            }
        let alertController = UIAlertController(title: "Contact selected", message: "Selected row: \(indexPath.row) (\(name)", preferredStyle: .alert)
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let actionDetails = UIAlertAction(title: "Show Details", style : .default, handler: actionHandler)
        
        alertController.addAction(actionCancel)
        alertController.addAction(actionDetails)
        present(alertController, animated: true, completion: nil)
        }
    
    
    
    


   

   
    // MARK: - Navigation

    
}
