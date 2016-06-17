//
//  ProfileViewController.swift
//  YardSaleFinder
//
//  Created by Donny Davis on 6/14/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import UIKit
import Gloss
import Firebase

enum ProfileTableCellsReference {
    case ProfilePhoto
    case Name
}

class ProfileViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
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
    
    var logoutBarButtonItem: UIBarButtonItem?
    var editBarButtonItem: UIBarButtonItem?
    var doneBarButtonItem: UIBarButtonItem?
    var cancelBarButtonItem: UIBarButtonItem?
    var saveBarButtonItem: UIBarButtonItem?
    var updatingBarButtonItem: UIBarButtonItem?
    var activityIndicator = UIActivityIndicatorView()
    
    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoutBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: #selector(logoutButtonTapped(_:)))
        editBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(editButtonTapped(_:)))
        doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(doneButtonTapped(_:)))
        cancelBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(cancelButtonTapped(_:)))
        saveBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(saveButtonTapped(_:)))
        updatingBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        
        navigationItem.leftBarButtonItem = editBarButtonItem
        navigationItem.rightBarButtonItems = [doneBarButtonItem!, logoutBarButtonItem!]

        imagePicker.delegate = self
        
        tapGesture.addTarget(self, action: #selector(profileTapGesture(_:)))
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 500.0
        
        userProfile = DataReference.sharedInstance.userProfile
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }

}

// MARK: Button Actions

extension ProfileViewController {
    
    @IBAction func logoutButtonTapped(sender: UIBarButtonItem) {
        DataReference.sharedInstance.signOut()
        performSegueWithIdentifier("UnwindToMapSegue", sender: nil)
    }
    
    @IBAction func editButtonTapped(sender: UIBarButtonItem) {
        isEditingProfile = true
        navigationItem.setLeftBarButtonItem(cancelBarButtonItem, animated: true)
        navigationItem.setRightBarButtonItems([saveBarButtonItem!], animated: true)
    }
    
    @IBAction func doneButtonTapped(sender: UIBarButtonItem) {
        performSegueWithIdentifier("UnwindToMapSegue", sender: nil)
    }
    
    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        isEditingProfile = false
        navigationItem.setLeftBarButtonItem(editBarButtonItem, animated: true)
        navigationItem.setRightBarButtonItems([doneBarButtonItem!, logoutBarButtonItem!], animated: true)
    }
    
    @IBAction func saveButtonTapped(sender: UIBarButtonItem) {
        isEditingProfile = false
        navigationItem.setRightBarButtonItems([updatingBarButtonItem!], animated: true)
        activityIndicator.startAnimating()
        
        let indexPath = NSIndexPath(forRow: 1, inSection: 0)
        let nameCell = tableView.cellForRowAtIndexPath(indexPath) as? NameTableViewCell
        updatedUserProfile?.name = nameCell!.nameTextField.text
        
        DataReference.sharedInstance.updateUserProfile(updatedUserProfile)
        DataReference.sharedInstance.usersRef.child(updatedUserProfile!.id!).updateChildValues((updatedUserProfile?.toJSON())!)
        
        if DirectoryServices.profileImageExists() {
            DataReference.sharedInstance.profileImageRef.putFile(NSURL(fileURLWithPath: DirectoryServices.getImagePath()), metadata: .None, completion: { (metaData, error) in
                    self.activityIndicator.stopAnimating()
                    self.navigationItem.setLeftBarButtonItem(self.editBarButtonItem, animated: true)
                    self.navigationItem.setRightBarButtonItems([self.doneBarButtonItem!, self.logoutBarButtonItem!], animated: true)
            })
        }
    }
    
}

// MARK: Table View Delegates

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        switch indexPath.row {
        case ProfileTableCellsReference.ProfilePhoto.hashValue:
            if let profilePhotoCell = tableView.dequeueReusableCellWithIdentifier("ProfilePhotoCell", forIndexPath: indexPath) as? ProfilePhotoTableViewCell {
                profilePhotoCell.configureCell(updatedUserProfile)
                profilePhotoCell.profileImageView.addGestureRecognizer(tapGesture)
                cell = profilePhotoCell
            }
            
        case ProfileTableCellsReference.Name.hashValue:
            if let nameCell = tableView.dequeueReusableCellWithIdentifier("NameCell", forIndexPath: indexPath) as? NameTableViewCell {
                nameCell.configureCell(updatedUserProfile)
                cell = nameCell
            }
            
        default:
            break
        }
        
        cell.tag = indexPath.row
        
        return cell
    }
    
}

// MARK: Gesture Recognizers

extension ProfileViewController {
    
    @IBAction func profileTapGesture(sender: UITapGestureRecognizer) {
        if sender.view?.tag == ProfileTableCellsReference.ProfilePhoto.hashValue && isEditingProfile {
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
                DataReference.sharedInstance.profileImageRef.deleteWithCompletion({ (error) in
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

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let editedPhoto = info[UIImagePickerControllerEditedImage] as? UIImage {
            DirectoryServices.writeImageToDirectory(editedPhoto)
            updatedUserProfile?.profilePhotoUpdated = true
            tableView.reloadData()
        } else if let photo = info[UIImagePickerControllerOriginalImage] as? UIImage {
            DirectoryServices.writeImageToDirectory(photo)
            updatedUserProfile?.profilePhotoUpdated = true
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

