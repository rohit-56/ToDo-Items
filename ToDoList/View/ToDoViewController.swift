//
//  ToDoViewController.swift
//  ToDoList
//
//  Created by Rohit Sharma on 04/01/23.
//

import UIKit
import CoreData

class ToDoViewController: UIViewController {
    
    // Custom list of array
    var itemList = [Item]()
    
    // Generic Context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var tableView : UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let headerView = HeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 130))
        
        headerView.delegate = self
       
        tableView.tableHeaderView = headerView
        
        view.addSubview(tableView)
        
        fetchItems()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    //MARK: This function to save the items on Persistent Container
    
    func saveItems(){
        do{
            try context.save()
        }catch{
            print("Error occur while Saving the item : \(error)")
        }
        
        tableView.reloadData()
    }
    
    //MARK: This function to fetch the items from Persistent Container
    
    func fetchItems(){
        let request : NSFetchRequest<Item>
        request = Item.fetchRequest()
        
        do{
            itemList = try context.fetch(request)
        }catch{
            print("Error occur while fetching item list : \(error)")
        }
    }
    
}

//MARK: - Extension to handle all the methods of TableView like height of cell , row selected

extension ToDoViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = itemList[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        saveItems()
        print(itemList[indexPath.row])
    }
    
}

//MARK: - Extension for Methods Under HeaderViewDelegate Protocol

extension ToDoViewController : HeaderViewDelegate {
    
    //MARK: This Funtion When we click on Add button near heading of table View
    
    func addItemOnListAndReLoadList(_ view: HeaderView) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Item To List", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default){ [self] alerts in
            guard let getItem = textField.text  else {return}
            let newItem = Item(context: context)
            newItem.title = getItem
            newItem.done = false
            itemList.append(newItem)
            saveItems()
        }
        alert.addTextField(){ alertTextField in
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
}
