//
//  HomeViewController.swift
//  CustomLoginDemo
//
//  Created by Christopher Ching on 2019-07-22.
//  Copyright © 2019 Christopher Ching. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class HomeViewController: UIViewController {
    
    
    
    
    
    @IBOutlet weak var field: UILabel!
    
    let ref = Firestore.firestore().collection("users").document("pV5bcBgtjK0pYreIRnxV")
    
    override func viewDidLoad() {
        ref.addSnapshotListener {(DocumentSnapshot,error) in
        guard let document = DocumentSnapshot else {
            print("에러발견: \(error!)")
            return
        }
        
        super.viewDidLoad()
        let name = document.get("lastname") as! String
        self.field.text = name
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
