//
//  AddProductTableViewController.swift
//  Shopping List
//
//  Created by Tolga Sarikaya on 24.01.23.
//

import UIKit
import CoreData

class AddProductTableViewController: UITableViewController {
    
    // MARK: - UI Elements
    @IBOutlet var productTextField: UITextField!
   
    
    

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Background image
        tableView.backgroundView = UIImageView(image: UIImage(named: "background2.png"))
        
       
        
    }
    
    // MARK: - Functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == "saveUnwind" else  { return }
        
        if productTextField.text == "" {
            makeAlert(titleInput: "Error", messageInput: "Product not found")
        } else {
           
            
            // Product Save
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let newProduct = NSEntityDescription.insertNewObject(forEntityName: "Products", into: context)
            
            newProduct.setValue(productTextField.text!, forKey: "name")
            newProduct.setValue(UUID(), forKey: "id")
            
            do {
                try context.save()
                print("succes")
            } catch {
                print("Error")
            }
            
            
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
       
     
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
