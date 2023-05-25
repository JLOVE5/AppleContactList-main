//
//  ContactsViewController.swift
//  ContactApp
//
//  Created by user238354 on 3/27/23.
//

import UIKit
import CoreData


class ContactsViewController: UIViewController, UITextFieldDelegate, DateControllerDelegate {

    var currentContact: Contact?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    @IBOutlet weak var sgmtEditMode: UISegmentedControl!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtZip: UITextField!
    @IBOutlet weak var txtHome: UITextField!
    @IBOutlet weak var txtCell: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblBirthdate: UILabel!
    @IBOutlet weak var btnChange: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        changeEditMode(self)
        let textFields: [UITextField] = [txtName, txtAddress, txtCity, txtState, txtZip, txtHome, txtCell, txtEmail]
        for textField in textFields {
            textField.addTarget(self, action: #selector(UITextFieldDelegate.textFieldShouldEndEditing(_:)), for: UIControl.Event.editingDidEnd)
            
        }
        // Do any additional setup after loading the view.
        if currentContact != nil {
            txtName.text = currentContact!.name
            txtAddress.text = currentContact!.strAddress
            txtCity.text = currentContact!.city
            txtState.text = currentContact!.state
            txtZip.text = currentContact!.zipCode
            txtHome.text = currentContact!.homeNum
            txtCell.text = currentContact!.cellNum
            txtEmail.text = currentContact!.email
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            if currentContact!.birthday != nil {
                lblBirthdate.text = formatter.string(from: currentContact!.birthday as! Date)
            }
        }
        changeEditMode(self)
        
        let textFieldss: [UITextField] = [txtName, txtAddress, txtCity, txtState, txtZip, txtHome,txtCell,txtEmail]
        for textField in textFieldss {
            textField.addTarget(self, action: #selector(UITextFieldDelegate.textFieldShouldEndEditing(_:)),
                                for: UIControl.Event.editingDidEnd)
        }
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if currentContact == nil {
            let context = appDelegate.persitentContainer.viewContext
            currentContact = Contact(context: context)
        }
        currentContact?.name = txtName.text
        currentContact?.strAddress = txtAddress.text
        currentContact?.city = txtCity.text
        currentContact?.state = txtState.text
        currentContact?.zipCode = txtZip.text
        currentContact?.cellNum = txtCell.text
        currentContact?.homeNum = txtHome.text
        currentContact?.email = txtEmail.text
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.didReceiveMemoryWarning()
    }
    @objc func saveContact(){
        appDelegate.saveContext()
        sgmtEditMode.selectedSegmentIndex = 0
        changeEditMode(self)
    }
    func dateChanged(date: Date)			{
        if currentContact == nil {
            let context = appDelegate.persitentContainer.viewContext
            currentContact = Contact(context: context)
        }
        currentContact?.birthday = date
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        lblBirthdate.text = formatter.string(from: date)
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if(segue.identifier == "segueContactDate"){
            let dateController = segue.destination as! DateViewController
            dateController.delegate = self
        }
    }
    @IBAction func changeEditMode(_ sender: Any) {
        let textFields: [UITextField] = [txtName,txtAddress,txtCity,txtState,txtZip,txtHome,txtCell,txtEmail]
        if sgmtEditMode.selectedSegmentIndex == 0 {
            for textField in textFields {
                textField.isEnabled = false
                textField.borderStyle = UITextField.BorderStyle.none
            }
            btnChange.isHidden = true
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveContact))	
        }
        else if sgmtEditMode.selectedSegmentIndex == 1 {
            for textField in textFields {
                textField.isEnabled = true
                textField.borderStyle = UITextField.BorderStyle.roundedRect
            }
            btnChange.isHidden = false
        }
    }
}


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


