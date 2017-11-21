//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Nikhil Dasari on 11/14/17.
//  Copyright © 2017 Nikhil. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: Outlets
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topToolBar: UIToolbar!

    //Mark: Properties
    let textFieldDelegate = TextFieldDelegate()
    var memedImage: UIImage?
    var hide: Bool = true

    // MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Disable the share button
        self.shareButton.isEnabled = false
        
        //set default attributes for top and bottom text fields
        textFieldDelegate.setDefaultTextFieldAttributes(textField: topTextField)
        textFieldDelegate.setDefaultTextFieldAttributes(textField: bottomTextField)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //enable camera button based on its availability on device
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    // MARK: Actions
    @IBAction func pickAnImage(_ sender: UIBarButtonItem) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        //Based on button title, determine the source type of image picker controller to present
        if sender.title == "Albums" {
            imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        } else {
            imagePickerController.sourceType = UIImagePickerControllerSourceType.camera
        }
        //present image picker controller
        self.present(imagePickerController, animated: true, completion: nil)
    }

    @IBAction func shareMeme(_ sender: Any) {
        self.memedImage = generateMemedImage()
        //initialize the activity view controller with the generated meme image
        let activityViewController = UIActivityViewController(activityItems: [memedImage!], applicationActivities: nil)
        //present the activity controller and upon completion of user specified task, call save()
        self.present(activityViewController, animated: true, completion: nil)
        //after successfully completing the user selected action, save meme
        activityViewController.completionWithItemsHandler = {(activityType, completed, items, error) in
            if completed { self.save() }
        }
    }

    // MARK: Image Picker Controller Delegate methods

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
        }
        //dismiss picker controller once the image is picked
        dismissViewController()

        //enable share button
        shareButton.isEnabled = true
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //dismiss picker view controller when the user cancels
        dismissViewController()
    }

    // MARK: Helper methods

    func generateMemedImage() -> UIImage {
        //setToolbarState(
        setToolbarsStateToHidden(isRequired: hide)
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        setToolbarsStateToHidden(isRequired: !hide)
        return memedImage
    }

    func setToolbarsStateToHidden(isRequired: Bool) {
        topToolBar.isHidden = isRequired ? hide : !hide
        bottomToolBar.isHidden = isRequired ? hide : !hide
    }

    func save() {
        // save the meme
        _ = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: self.memedImage!)
    }

    func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }

    // add this view controller as an observer to keyboard show and hide events
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }

    // remove this view controller from keyboard show and hide events
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }

    //When the keyboardWillShow notification is received for bottom textfield, shift the view's frame up
    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = getKeyboardHeight(notification) * (-1)
            //view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }

    //Reset the frame when the KeyBoardWillHide notification is received for bottom textfield.
    @objc func keyboardWillHide(_ notification: Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
    }

    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
}
