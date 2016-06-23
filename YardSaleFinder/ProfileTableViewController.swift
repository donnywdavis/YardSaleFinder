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
    
    // MARK: Properties
    
    var imagePicker = UIImagePickerController()
    var updatedUserProfile: Profile? = Profile()
    var userProfile: Profile? {
        didSet {
            updatedUserProfile = userProfile
        }
    }
    
    var tapGesture = UITapGestureRecognizer()
    var isEditingProfile = false
    
    var editBarButtonItem: UIBarButtonItem?
    var doneBarButtonItem: UIBarButtonItem?
    var cancelBarButtonItem: UIBarButtonItem?
    var saveBarButtonItem: UIBarButtonItem?
    var updatingBarButtonItem: UIBarButtonItem?
    var activityIndicator = UIActivityIndicatorView()
    
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
        
        tapGesture.addTarget(self, action: #selector(profileTapGesture(_:)))
        
        userProfile = DataServices.userProfile
        
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.layer.borderColor = UIColor(red: 0/255.0, green: 178/255.0, blue: 51/255.0, alpha: 1.0).CGColor
        profileImageView.layer.borderWidth = 4.0
        profileImageView.clipsToBounds = true
        profileImageView.addGestureRecognizer(tapGesture)
        
        nameTextField.enabled = false
        streetTextField.enabled = false
        aptSuiteTextField.enabled = false
        cityTextField.enabled = false
        stateTextField.enabled = false
        zipCodeTextField.enabled = false
        
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
    
    func loadProfileData() {
        profileImageView.image = UIImage(contentsOfFile: DirectoryServices.getImagePath())
        nameTextField.text = userProfile?.name
        streetTextField.text = userProfile?.address?.street
        aptSuiteTextField.text = userProfile?.address?.aptSuite
        cityTextField.text = userProfile?.address?.city
        stateTextField.text = userProfile?.address?.street
        zipCodeTextField.text = userProfile?.address?.zipCode
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
                DirectoryServices.removeImage()
                DataServices.removeRemoteProfileImage(self.updatedUserProfile!.id!, completion: { (error) in
                })
                self.tableView.reloadData()
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
    
    @IBAction func logoutButtonTapped(sender: UIBarButtonItem) {
        DataServices.signOut()
        performSegueWithIdentifier("UnwindToMapSegue", sender: nil)
    }
    
    @IBAction func editButtonTapped(sender: UIBarButtonItem) {
        isEditingProfile = true
        nameTextField.enabled = true
        streetTextField.enabled = true
        aptSuiteTextField.enabled = true
        cityTextField.enabled = true
        stateTextField.enabled = true
        zipCodeTextField.enabled = true
        navigationItem.setLeftBarButtonItem(cancelBarButtonItem, animated: true)
        navigationItem.setRightBarButtonItem(saveBarButtonItem, animated: true)
    }
    
    @IBAction func doneButtonTapped(sender: UIBarButtonItem) {
        performSegueWithIdentifier("UnwindToMapSegue", sender: nil)
    }
    
    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        if DirectoryServices.tempProfileImageExists() {
            DirectoryServices.removeTempImage()
        }
        isEditingProfile = false
        navigationItem.setLeftBarButtonItem(editBarButtonItem, animated: true)
        navigationItem.setRightBarButtonItem(doneBarButtonItem, animated: true)
    }
    
    @IBAction func saveButtonTapped(sender: UIBarButtonItem) {
        isEditingProfile = false
        cancelBarButtonItem?.enabled = false
        navigationItem.setRightBarButtonItem(updatingBarButtonItem, animated: true)
        activityIndicator.startAnimating()
        
        updatedUserProfile?.name = nameTextField.text
        updatedUserProfile?.address?.street = streetTextField.text
        updatedUserProfile?.address?.aptSuite = aptSuiteTextField.text
        updatedUserProfile?.address?.city = cityTextField.text
        updatedUserProfile?.address?.state = stateTextField.text
        updatedUserProfile?.address?.zipCode = zipCodeTextField.text
        
        if DirectoryServices.tempProfileImageExists() {
            let tempImage = UIImage(contentsOfFile: DirectoryServices.getTempImagePath())
            DirectoryServices.writeImageToDirectory(tempImage!)
            DirectoryServices.removeTempImage()
        }
        
        DataServices.updateUserProfile(updatedUserProfile!)
        DataServices.updateRemoteUserProfile(updatedUserProfile!)
        
        if DirectoryServices.profileImageExists() {
            DataServices.uploadProfileImage(updatedUserProfile!.id!, fromPath: NSURL(fileURLWithPath: DirectoryServices.getImagePath()), completion: { (metadata, error) in
                self.activityIndicator.stopAnimating()
                self.cancelBarButtonItem?.enabled = true
                self.navigationItem.setLeftBarButtonItem(self.editBarButtonItem, animated: true)
                self.navigationItem.setRightBarButtonItem(self.doneBarButtonItem, animated: true)
            })
        }
    }
    
}
