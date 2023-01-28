//
//  ProductListTableViewController.swift
//  Shopping List
//
//  Created by Tolga Sarikaya on 25.01.23.
//

import UIKit
import CoreData

class ProductListTableViewController: UITableViewController {

    // MARK: - Properties
    var nameArray = [String]()
    var idArray = [UUID]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Background image
        tableView.backgroundView = UIImageView(image: UIImage(named: "background.png"))
        
        
        getData()
        
    }
   
    
    // MARK: - Functions
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData),
         name: NSNotification.Name(rawValue: "newData"), object: nil)
    }
    
    @objc func  getData() {
      
        nameArray.removeAll(keepingCapacity: false)
        idArray.removeAll(keepingCapacity: false)
      
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      let context = appDelegate.persistentContainer.viewContext
      
      let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Products")
      fetchRequest.returnsObjectsAsFaults = false
      
      do {
          let results = try context.fetch(fetchRequest)
          if results.count > 0 {
              
          }
          
          for result in results as! [NSManagedObject] {
              if let name = result.value(forKey: "name") as? String {
                  self.nameArray.append(name)
              }
              
              if let id = result.value(forKey: "id") as? UUID {
                  self.idArray.append(id)
              }
              
              self.tableView.reloadData()
          }
          
      } catch {
          print("Error")
      }
      
      
  }

  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return nameArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = nameArray[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
    
  
     // Checkmark to be toggled on and off when tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
            } else {
                cell.accessoryType = .checkmark
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
       return.delete
    }

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Products")
            
            let idString = idArray[indexPath.row].uuidString
            
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
            
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                
                    for result in results as! [NSManagedObject] {
                        
                        if let id = result.value(forKey: "id") as? UUID {
                            
                            if id == idArray[indexPath.row] {
                                context.delete(result)
                                nameArray.remove(at: indexPath.row)
                                idArray.remove(at: indexPath.row)
                                
                                tableView.reloadData()
                                
                                do {
                                    try context.save()
                                    
                                }catch {
                                    print("Error")
                                }
                                
                                break
                                
                            }
                        }
                    }
                    
                }
            } catch {
                
            }
        }
    }

    // MARK: - Actions
    
    // For Editing
    @IBAction func trashButtonTapped(_ sender: Any) {
        let tableViewTrashMode = tableView.isEditing
        tableView.setEditing(!tableViewTrashMode, animated: true)
    }
    
    
    
    @IBAction func unwindFromNewProduct(_ segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else  { return }
    }
}
