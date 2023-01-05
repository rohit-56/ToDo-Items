//
//  ViewController.swift
//  ToDoList
//
//  Created by Rohit Sharma on 04/01/23.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(switchToDoVC), userInfo: nil, repeats: false)
        
    }
    
    @objc func switchToDoVC(){
        let storyboard = UIStoryboard(name: "ToDo", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ToDoViewController") as UIViewController
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true)
    }
}


    

