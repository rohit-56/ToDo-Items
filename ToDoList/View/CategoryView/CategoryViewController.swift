//
//  CategoryViewController.swift
//  ToDoList
//
//  Created by Rohit Sharma on 06/01/23.
//

import UIKit
import CoreData
import SwipeCellKit
import ChameleonFramework


class CategoryViewController: SwipeViewController {
    
    var categoryList : [Category]?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    private var categoryTable : UITableView = {
       let tableView = UITableView()
        tableView.register(SwipeTableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        view.addSubview(categoryTable)
      
        categoryTable.delegate = self
        categoryTable.dataSource = self
        
        let categoryHeaderView = CategoryHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 80))
        
        categoryHeaderView.delegate = self
        
        categoryTable.tableHeaderView = categoryHeaderView
        fetchCategoriesList()
     
       
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        categoryTable.frame = view.bounds
    }
    
    
    //MARK: Below functions are for data manipulation in Persistent Container
    
    override func deleteRow(with indexPath: IndexPath) {
        if let categoryDeleted = categoryList?[indexPath.row] {
            
            context.delete(categoryDeleted)
            categoryList?.remove(at: indexPath.row)
            do{
                try context.save()
            }catch{
                print("Error occurs inside delete category \(error)")
            }
            
        }
    }
    
    func saveCategory(){
        do{
            try context.save()
        }catch{
            print("Error while saving the category \(error)")
        }
        
        categoryTable.reloadData()
    }
    
    func fetchCategoriesList(with request : NSFetchRequest<Category> = Category.fetchRequest()){
        do{
            categoryList = try context.fetch(request)
        }catch{
            print("Error while fetching the category \(error)")
        }
        
        categoryTable.reloadData()
    }
}
extension CategoryViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SwipeTableViewCell else {return UITableViewCell()}
        cell.textLabel?.text = categoryList![indexPath.row].name
        let backgroundcolor = UIColor(hexString: (categoryList?[indexPath.row].categoryColor)!)
        cell.backgroundColor = backgroundcolor
        cell.textLabel?.textColor = ContrastColorOf(backgroundcolor!, returnFlat: true)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ToDoViewController()
        vc.selectedCategory = categoryList?[indexPath.row]
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

extension CategoryViewController : CategoryHeaderViewDelegate {
    func addCategoryOnListAndReLoadList(_ view: CategoryHeaderView) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Category To List", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default){ [self] result in
            let newCategory = Category(context: context)
            newCategory.name = textField.text!
            newCategory.categoryColor = RandomFlatColor().hexValue()
            categoryList?.append(newCategory)
            saveCategory()
        }
        
        alert.addTextField(){ alertTextField in
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
}

