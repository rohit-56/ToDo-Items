//
//  ToDoViewController.swift
//  ToDoList
//
//  Created by Rohit Sharma on 04/01/23.
//

import UIKit

class ToDoViewController: UIViewController {
    
    var itemList = ["Shopping" , "Study" ,"Visit Doctor" , "Pay Bills"]
    
    private var tableView : UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let headerView = HeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 100))
        
        headerView.delegate = self
        
        tableView.tableHeaderView = headerView
        
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    
}
extension ToDoViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = itemList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(itemList[indexPath.row])
    }
    
}
extension ToDoViewController : HeaderViewDelegate {
    func addItemOnListAndReLoadList(_ view: HeaderView) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Item To List", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default){ [self] alerts in
            guard let getItem = textField.text  else {return}
            itemList.append(getItem)
            tableView.reloadData()
        }
        alert.addTextField(){ alertTextField in
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
}
