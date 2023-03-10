//
//  ToDoViewController.swift
//  ToDoList
//
//  Created by Rohit Sharma on 04/01/23.
//

import UIKit
import CoreData
import SwipeCellKit
import ChameleonFramework

class ToDoViewController: SwipeViewController {
    
    // Custom list of array
    var itemList : [Item]?
    
    var selectedCategory : Category?{
        didSet{
            fetchItems()
        }
    }
    
    // Generic Context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var tableView : UITableView = {
        let tableView = UITableView()
        tableView.register(SwipeTableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let headerView = HeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 130))
        
        headerView.delegate = self
        
        headerView.label.text = selectedCategory?.name
        
        headerView.searchBar.barTintColor = HexColor((selectedCategory?.categoryColor)!)
        
        headerView.back.backgroundColor = HexColor((selectedCategory?.categoryColor)!)
        
        headerView.label.backgroundColor = HexColor((selectedCategory?.categoryColor)!)
        
        headerView.addItem.backgroundColor = HexColor((selectedCategory?.categoryColor)!)
        
        let color = ContrastColorOf(HexColor((selectedCategory?.categoryColor)!)!, returnFlat: true)
        
        headerView.back.setTitleColor(color, for: .normal)
        
        headerView.label.textColor = color
        
        headerView.addItem.setTitleColor(color, for: .normal)
       
        tableView.tableHeaderView = headerView
        
        view.addSubview(tableView)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    //MARK: This function to save the items on Persistent Container
    
    
    override func deleteRow(with indexPath: IndexPath) {
        if let itemDeleted = itemList?[indexPath.row] {
            
            context.delete(itemDeleted)
            itemList?.remove(at: indexPath.row)
            do{
                try context.save()
            }catch{
                print("Error occurs inside delete category \(error)")
            }
            
        }
    }
    
    
    func saveItems(){
        do{
            try context.save()
        }catch{
            print("Error occur while Saving the item : \(error)")
        }
        
        tableView.reloadData()
    }
    
    //MARK: This function to fetch the items from Persistent Container
    
    func fetchItems(with request : NSFetchRequest<Item> = Item.fetchRequest(),with predicate : NSPredicate? = nil){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate,categoryPredicate])
        }
        else{
            request.predicate = categoryPredicate
        }
        
        do{
            itemList = try context.fetch(request)
        }catch{
            print("Error occur while fetching item list : \(error)")
        }
        
        tableView.reloadData()
    }
    
}

//MARK: - Extension to handle all the methods of TableView like height of cell , row selected

extension ToDoViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SwipeTableViewCell else {return UITableViewCell()}
        cell.textLabel?.text = itemList?[indexPath.row].title
        
        if let color = selectedCategory?.categoryColor{
            let backgroundcolor = UIColor(hexString: color)?.darken(byPercentage: (CGFloat(indexPath.row) / CGFloat(itemList!.count)))
            cell.backgroundColor = backgroundcolor
            cell.textLabel?.textColor = ContrastColorOf(backgroundcolor!, returnFlat: true)
        }
        print((CGFloat(indexPath.row) / CGFloat(itemList!.count)))
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        saveItems()
    }
    
}

//MARK: - Extension for Methods Under HeaderViewDelegate Protocol

extension ToDoViewController : HeaderViewDelegate {
    
    func dismissToDoVC(_ view: HeaderView) {
        DispatchQueue.main.async { [self] in
            dismiss(animated: true)
        }
        
    }
    
    
    //MARK: This function calls when we click on cross button on search bar then show original item list
    
    func toShowOriginalItemList(_ view: HeaderView) {
        fetchItems()
    }
    
    
    //MARK: This function to query for related title in COREDATA and show in tableView
    
    func queryOfItemInList(_ view: HeaderView, with title: String) {
        print(title)
       
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", title)
            
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            self.fetchItems(with: request , with: predicate)
       
        
        
    }
    
    
    //MARK: This Funtion When we click on Add button near heading of table View
    
    func addItemOnListAndReLoadList(_ view: HeaderView) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Item To List", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default){ [self] alerts in
            guard let getItem = textField.text  else {return}
            let newItem = Item(context: context)
            newItem.title = getItem
            newItem.done = false
            newItem.parentCategory = selectedCategory
            itemList?.append(newItem)
            saveItems()
        }
        alert.addTextField(){ alertTextField in
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    
}
