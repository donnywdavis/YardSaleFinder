//
//  ProfileTableViewController.swift
//  YardSaleFinder
//
//  Created by Donny Davis on 6/22/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var aptSuiteTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var editPhotoLabel: UILabel!
    
    // MARK: Properties
    
    var imagePicker = UIImagePickerController()
    var userProfile: Profile?
    
    var isEditingProfile = false
    var isDeletingImage = false
    
    var editBarButtonItem: UIBarButtonItem?
    var doneBarButtonItem: UIBarButtonItem?
    var cancelBarButtonItem: UIBarButtonItem?
    var saveBarButtonItem: UIBarButtonItem?
    var updatingBarButtonItem: UIBarButtonItem?
    var activityIndicator = UIActivityIndicatorView()
    var statePickerView = UIPickerView()
    
    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        editBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(editButtonTapped(_:)))
        doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(doneButtonTapped(_:)))
        cancelBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(cancelButtonTapped(_:)))
        saveBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(saveButtonTapped(_:)))
        updatingBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        
        navigationItem.leftBarButtonItem = editBarButtonItem
        navigationItem.rightBarButtonItem = doneBarButtonItem
        
        imagePicker.delegate = self
        editPhotoLabel.hidden = true
        
        streetTextField.delegate = self
        aptSuiteTextField.delegate = self
        cityTextField.delegate = self
        stateTextField.delegate = self
        zipCodeTextField.delegate = self
        
        statePickerView.delegate = self
        statePickerView.showsSelectionIndicator = true
        stateTextField.inputView = statePickerView
        keyboardAccessoryButtons()
        
        userProfile = DataServices.userProfile
        
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.layer.borderColor = UIColor(red: 0/255.0, green: 178/255.0, blue: 51/255.0, alpha: 1.0).CGColor
        profileImageView.layer.borderWidth = 4.0
        profileImageView.clipsToBounds = true
        
        allowTextFieldsToBeEditable(false)
        
        loadProfileData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
        case 3 where isEditingProfile, 4 where isEditingProfile:
            return 0
            
        default:
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    
    // MARK: Utility Functions
    func loadProfileData() {
        if DirectoryServices.tempProfileImageExists() {
            profileImageView.image = UIImage(contentsOfFile: DirectoryServices.getTempImagePath())
        } else if DirectoryServices.profileImageExists() {
            profileImageView.image = UIImage(contentsOfFile: DirectoryServices.getImagePath())
        } else {
            profileImageView.image = UIImage(named: "profile100")
        }
        nameTextField.text = userProfile?.name
        streetTextField.text = userProfile?.address?.street
        aptSuiteTextField.text = userProfile?.address?.aptSuite
        cityTextField.text = userProfile?.address?.city
        stateTextField.text = userProfile?.address?.state
        zipCodeTextField.text = userProfile?.address?.zipCode
    }
    
    func allowTextFieldsToBeEditable(editable: Bool) {
        nameTextField.enabled = editable
        streetTextField.enabled = editable
        aptSuiteTextField.enabled = editable
        cityTextField.enabled = editable
        stateTextField.enabled = editable
        zipCodeTextField.enabled = editable
    }

}

// MARK: Gesture Recognizers

extension ProfileTableViewController {
    
    @IBAction func profileTapGesture(sender: UITapGestureRecognizer) {
        if isEditingProfile {
            let imageOptions = UIAlertController(title: nil, message: "Profile Photo Options", preferredStyle: .ActionSheet)
            let choosePhoto = UIAlertAction(title: "Choose Photo", style: .Default) { (action) in
                self.imagePicker.sourceType = .PhotoLibrary
                self.imagePicker.allowsEditing = true
                self.imagePicker.modalPresentationStyle = .CurrentContext
                self.imagePicker.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
                self.imagePicker.navigationBar.barTintColor = UIColor(red: 0/255.0, green: 178/255.0, blue: 51/255.0, alpha: 1.0)
                self.presentViewController(self.imagePicker, animated: true, completion: nil)
            }
            let removePhoto = UIAlertAction(title: "Remove Photo", style: .Default, handler: { (action) in
                self.profileImageView.image = UIImage(named: "profile100")
                self.isDeletingImage = true
                
            })
            let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            
            imageOptions.addAction(choosePhoto)
            imageOptions.addAction(removePhoto)
            imageOptions.addAction(cancel)
            
            presentViewController(imageOptions, animated: true, completion: nil)
        }
    }
}

// MARK: Image Picker Delegate

extension ProfileTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let editedPhoto = info[UIImagePickerControllerEditedImage] as? UIImage {
            DirectoryServices.writeTempImageToDirectory(editedPhoto)
            profileImageView.image = UIImage(contentsOfFile: DirectoryServices.getTempImagePath())
            tableView.reloadData()
        } else if let photo = info[UIImagePickerControllerOriginalImage] as? UIImage {
            DirectoryServices.writeTempImageToDirectory(photo)
            profileImageView.image = UIImage(contentsOfFile: DirectoryServices.getTempImagePath())
            tableView.reloadData()
        } else {
            MessageServices.displayMessage("Image Error", message: "There was an error selecting the photo. Please try again.", presentingViewController: self)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

// MARK: Button Actions

extension ProfileTableViewController {
    
    @IBAction func logoutButtonTapped(sender: UIButton) {
        if DirectoryServices.profileImageExists() {
            DirectoryServices.removeImage()
        }
        DataServices.signOut()
        performSegueWithIdentifier("UnwindToMapSegue", sender: nil)
    }
    
    @IBAction func editButtonTapped(sender: UIBarButtonItem) {
        isEditingProfile = true
        editPhotoLabel.hidden = false
        allowTextFieldsToBeEditable(true)
        navigationItem.setLeftBarButtonItem(cancelBarButtonItem, animated: true)
        navigationItem.setRightBarButtonItem(saveBarButtonItem, animated: true)
        tableView.reloadData()
    }
    
    @IBAction func doneButtonTapped(sender: UIBarButtonItem) {
        performSegueWithIdentifier("UnwindToMapSegue", sender: nil)
    }
    
    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        if DirectoryServices.tempProfileImageExists() {
            DirectoryServices.removeTempImage()
        }
        loadProfileData()
        isEditingProfile = false
        editPhotoLabel.hidden = true
        allowTextFieldsToBeEditable(false)
        navigationItem.setLeftBarButtonItem(editBarButtonItem, animated: true)
        navigationItem.setRightBarButtonItem(doneBarButtonItem, animated: true)
        
        view.endEditing(true)
        tableView.reloadData()
    }
    
    @IBAction func saveButtonTapped(sender: UIBarButtonItem) {
        isEditingProfile = false
        editPhotoLabel.hidden = false
        allowTextFieldsToBeEditable(false)
        cancelBarButtonItem?.enabled = false
        navigationItem.setRightBarButtonItem(updatingBarButtonItem, animated: true)
        activityIndicator.startAnimating()
        
        userProfile?.name = nameTextField.text
        userProfile?.address = Address(street: streetTextField.text, aptSuite: aptSuiteTextField.text, city: cityTextField.text, state: stateTextField.text, zipCode: zipCodeTextField.text)
        
        if DirectoryServices.tempProfileImageExists() {
            let tempImage = UIImage(contentsOfFile: DirectoryServices.getTempImagePath())
            DirectoryServices.writeImageToDirectory(tempImage!)
            DirectoryServices.removeTempImage()
        }
        
        if DirectoryServices.profileImageExists() && isDeletingImage {
            DirectoryServices.removeImage()
            DataServices.removeRemoteProfileImage(self.userProfile!.id!, completion: { (error) in
            })
        }
        
        DataServices.updateUserProfile(userProfile!)
        DataServices.updateRemoteUserProfile(userProfile!)
        
        if DirectoryServices.profileImageExists() {
            DataServices.uploadProfileImage(userProfile!.id!, fromPath: NSURL(fileURLWithPath: DirectoryServices.getImagePath()), completion: { (metadata, error) in
                if error != nil {
                    MessageServices.displayMessage("Upload Error", message: "There was an issue uploading your profile photo. Please try again.", presentingViewController: self)
                } else {
                    self.activityIndicator.stopAnimating()
                    self.cancelBarButtonItem?.enabled = true
                    self.navigationItem.setLeftBarButtonItem(self.editBarButtonItem, animated: true)
                    self.navigationItem.setRightBarButtonItem(self.doneBarButtonItem, animated: true)
                    self.view.endEditing(true)
                    self.tableView.reloadData()
                }
            })
        } else {
            activityIndicator.stopAnimating()
            cancelBarButtonItem?.enabled = true
            navigationItem.setLeftBarButtonItem(editBarButtonItem, animated: true)
            navigationItem.setRightBarButtonItem(doneBarButtonItem, animated: true)
            view.endEditing(true)
            tableView.reloadData()
        }
        
    }
    
}

// MARK: Picker View Delegates

extension ProfileTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return StateCodes.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let state = StateCodes.getStateCode(row)
        return state.description
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let state = StateCodes.getStateCode(row)
        stateTextField.text = state.shortDescription
    }
    
}

// MARK: Text Field Methods 

extension ProfileTableViewController: UITextFieldDelegate {
    
    func keyboardAccessoryButtons() {
        let stateKeyboardToolbar = UIToolbar()
        let zipKeyboardToolbar = UIToolbar()
        stateKeyboardToolbar.sizeToFit()
        zipKeyboardToolbar.sizeToFit()
        
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace,
                                            target: nil, action: nil)
        let nextBarButton = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: #selector(nextButtonTapped))
        let stateDoneBarButton = UIBarButtonItem(barButtonSystemItem: .Done,
                                            target: self, action: #selector(dismissKeyboard))
        let zipDoneBarButton = UIBarButtonItem(barButtonSystemItem: .Done,
                                            target: self, action: #selector(dismissKeyboard))
        
        nextBarButton.tintColor = UIColor(red: 0/255.0, green: 178/255.0, blue: 51/255.0, alpha: 1.0)
        stateDoneBarButton.tintColor = UIColor(red: 0/255.0, green: 178/255.0, blue: 51/255.0, alpha: 1.0)
        zipDoneBarButton.tintColor = UIColor(red: 0/255.0, green: 178/255.0, blue: 51/255.0, alpha: 1.0)
        
        stateKeyboardToolbar.items = [nextBarButton, flexBarButton, stateDoneBarButton]
        stateTextField.inputAccessoryView = stateKeyboardToolbar
        
        zipKeyboardToolbar.items = [flexBarButton, zipDoneBarButton]
        zipCodeTextField.inputAccessoryView = zipKeyboardToolbar
    }
    
    @IBAction func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func nextButtonTapped() {
        textFieldShouldReturn(stateTextField)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == stateTextField {
            if let state = stateTextField.text {
                statePickerView.selectRow(StateCodes.getIndexForState(state), inComponent: 0, animated: true)
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if streetTextField.isFirstResponder() {
            streetTextField.resignFirstResponder()
            aptSuiteTextField.becomeFirstResponder()
        } else if aptSuiteTextField.isFirstResponder() {
            aptSuiteTextField.resignFirstResponder()
            cityTextField.becomeFirstResponder()
        } else if cityTextField.isFirstResponder() {
            cityTextField.resignFirstResponder()
            stateTextField.becomeFirstResponder()
        } else if stateTextField.isFirstResponder() {
            stateTextField.resignFirstResponder()
            zipCodeTextField.becomeFirstResponder()
        } else if zipCodeTextField.isFirstResponder() {
            zipCodeTextField.resignFirstResponder()
        }
        
        return true
    }
    
}