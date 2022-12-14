//
//  ViewControllerDetails.swift
//  DiscountList
//
//  Created by Enes Keskin on 8/11/22.
//

import UIKit
import CoreData

class ViewControllerDetails: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var productTrademark: UITextField!
    @IBOutlet weak var productLocation: UITextField!
    @IBOutlet weak var productSize: UITextField!
    @IBOutlet weak var productPrice: UITextField!
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    
    var selectedProductName = ""
    var selectedProductUUID : UUID?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if selectedProductName != ""{
            // See fore data selected product info
            btnSave.isHidden = true
            
            if let uuidString = selectedProductUUID?.uuidString{
                //if get UUID
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Shopping")
                fetchRequest.returnsObjectsAsFaults = false
                
                //Add filter
                fetchRequest.predicate = NSPredicate(format: "id = %@", uuidString)
                
                do {
                    let results = try context.fetch(fetchRequest)
                    if results.count > 0 {
                        for result in results as! [NSManagedObject]{
                            if let name = result.value(forKey: "name") as? String{
                                productName.text = name
                            }
                            if let price = result.value(forKey: "price") as? Int{
                                productPrice.text = String(price)
                            }
                            if let size = result.value(forKey: "size") as? String{
                                productSize.text = size
                            }
                            if let location = result.value(forKey: "location") as? String{
                                productLocation.text = location
                            }
                            if let trademark = result.value(forKey: "trademark") as? String{
                                productTrademark.text = trademark
                            }
                            if let imageData = result.value(forKey: "image") as? Data{
                                let image = UIImage(data: imageData)
                                imageView.image = image
                            }
                        }
                    }
                                                    
                } catch{
                    print("error")
                }
            }
            
        }
        else{
            btnSave.isHidden = false
            btnSave.isEnabled = false
            productName.text = ""
            productSize.text = ""
            productPrice.text = ""
            productLocation.text = ""
            productTrademark.text = ""
        }
        

        // Click to screen
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(keywordClose))
        view.addGestureRecognizer(gestureRecognizer)
        
        // Click to imageView
        imageView.isUserInteractionEnabled = true
        let imageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.addGestureRecognizer(imageGestureRecognizer)
    }
    
    @objc func keywordClose(){
        // Keyword close
        view.endEditing(true)
    }
    
    @objc func selectImage(){
        // Selected Image forward photoLibrary and editing
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let shopping = NSEntityDescription.insertNewObject(forEntityName: "Shopping", into: context)
        
        shopping.setValue(productName.text!, forKey: "name")
        shopping.setValue(productSize.text!, forKey: "size")
        shopping.setValue(productTrademark.text!, forKey: "trademark")
        shopping.setValue(productLocation.text!, forKey: "location")
        
        if let price = Int(productPrice.text!){
            shopping.setValue(price, forKey: "price")
        }
        
        // Universal unique id
        shopping.setValue(UUID(), forKey: "id")
        
        let convertData = imageView.image!.jpegData(compressionQuality: 0.5)
        
        shopping.setValue(convertData, forKey: "image")
        
        do{
            try context.save()
            print("Registered.")
        } catch{
            print("Error")
        }
        
        
        NotificationCenter.default.post(name: NSNotification.Name("enteredData"), object: nil)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Show editedImage on imageView
        imageView.image = info[.editedImage] as? UIImage
        btnSave.isEnabled = true
        self.dismiss(animated: true, completion: nil)
        
    }
}
