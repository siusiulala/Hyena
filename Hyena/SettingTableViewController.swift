//
//  SettingTableViewController.swift
//  Hyena
//
//  Created by kbala on 2017/7/20.
//  Copyright © 2017年 kbala. All rights reserved.
//

import UIKit
import CoreData

class SettingTableViewController: UITableViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var pickerBtn: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var cameraBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnStyle()
        clearBtn.addTarget(self, action: #selector(self.onClearData(_:)), for: .touchUpInside) // when button in table cell, add target for it
        pickerBtn.addTarget(self, action: #selector(self.pickPicture(_:)), for: .touchUpInside)
        cameraBtn.addTarget(self, action: #selector(self.shootPhoto(_:)), for: .touchUpInside)
    }
    
    func btnStyle()
    {
        pickerBtn.layer.borderColor = UIColor.gray.cgColor
        pickerBtn.layer.borderWidth = 1.0
        cameraBtn.layer.borderColor = UIColor.gray.cgColor
        cameraBtn.layer.borderWidth = 1.0
    }
    
    func onClearData(_ sender: Any) {
        self.deleteAllData(entity: "Spot")
    }

    func deleteAllData(entity: String)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
            
            appDelegate.saveContext()
            //
            alertMessage(_title: "Clear Data", _message: "Data clear successfully.")
            
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
            alertMessage(_title: "Fail", _message: "Data clear faild.")
        }
    }
    
    func alertMessage(_title: String, _message: String)
    {
        let alert = UIAlertController(title: _title, message: _message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func pickPicture(_ sender: Any) {
        // go to "Info.plist" setting "Privacy - Photo Library Usage Description"
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true)
            
            imagePicker.delegate = self
        }
    }
    
    // Class: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imgView.image = selectedImage
            imgView.contentMode = .scaleAspectFit
            imgView.clipsToBounds = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func shootPhoto(_ sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.modalPresentationStyle = .fullScreen
            present(imagePicker,animated: true,completion: nil)
            
            imagePicker.delegate = self
        }
        else
        {
            noCamera() //for simulator no camera crash
        }
        
    }
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   

   }
