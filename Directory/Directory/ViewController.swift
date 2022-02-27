//
//  ViewController.swift
//  Directory
//
//  Created by MacBook on 26.02.2022.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as! AppDelegate

class ViewController: UIViewController {
    
    let context = appDelegate.persistentContainer.viewContext
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var personsTableView: UITableView!
    
    var personsList = [Kisiler]()
    
    var searching = false
    var searchWord:String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        personsTableView.delegate = self
        personsTableView.dataSource = self
        
        searchBar.delegate = self
        
        getPersons()
        
        initializeHideKeyboard()
        
    }
    

    @IBAction func addButton(_ sender: Any) {
        
        let specAlert = UIAlertController(title: "Add Person", message: nil, preferredStyle: .alert)
        
        specAlert.addTextField{ textfield in
            textfield.placeholder = "Person Name"
            textfield.keyboardType = .namePhonePad
        }
        specAlert.addTextField{ textfield in
            textfield.placeholder = "Telephone Number"
            textfield.keyboardType = .numberPad
        }
        
        let cancelAction = UIAlertAction(title: "cancel", style: .destructive, handler: nil)
        
        specAlert.addAction(cancelAction)
        
        let addAction = UIAlertAction(title: "kaydet", style: .default){ [self] action in
            
            let name = specAlert.textFields!.first!.text!
            let phoneNumber = specAlert.textFields!.last!.text!
            
            if name != "" && phoneNumber != ""{
                
                let kisi = Kisiler(context: self.context)
                
                kisi.kisi_ad = name
                kisi.kisi_tel = phoneNumber
                
                appDelegate.saveContext()
                
                getPersons()
                personsTableView.reloadData()
            }
        }
        
        specAlert.addAction(addAction)
        self.present(specAlert, animated: true)
    }
    
    func getPersons(){
        
        let fetchrequest:NSFetchRequest<Kisiler> = Kisiler.fetchRequest()
        
        do{
            personsList = try context.fetch(fetchrequest)
        }catch{
            print(error)
        }
    }
    
    func doSearch(person_name:String){
        
        let fetchrequestt:NSFetchRequest<Kisiler> = Kisiler.fetchRequest()
        
        fetchrequestt.predicate = NSPredicate(format: "kisi_ad CONTAINS %@", person_name)
        
        do{
            personsList = try context.fetch(fetchrequestt)
        }catch{
            print(error)
        }
    }
    
}

extension ViewController {
    
    func initializeHideKeyboard(){

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard(){
   
        view.endEditing(true)
    }
}

extension ViewController:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let person = personsList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "persons", for: indexPath) as! DirectoryTableViewCell
        
        cell.personLabel.text = "\(person.kisi_ad!) - \(String(describing: person.kisi_tel!))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [self]
            (contextualAction, view, boolValue) in
            
            let person = self.personsList[indexPath.row]
            
            context.delete(person)
            appDelegate.saveContext()
            
            if searching{
                doSearch(person_name: searchWord!)
            }else{
                getPersons()
            }
            personsTableView.reloadData()
            
        }
        
        let updateAction = UIContextualAction(style: .normal, title: "Update"){(contextualAction, view, boolValue)in
            
            let specAlert = UIAlertController(title: "Add Person", message: nil, preferredStyle: .alert)
            
            specAlert.addTextField{ textfield in
                textfield.placeholder = self.personsList[indexPath.row].kisi_ad!
                textfield.keyboardType = .namePhonePad
            }
            specAlert.addTextField{ textfield in
                textfield.placeholder = self.personsList[indexPath.row].kisi_tel!
                textfield.keyboardType = .numberPad
            }
            
            let cancelAction = UIAlertAction(title: "cancel", style: .destructive, handler: nil)
            
            specAlert.addAction(cancelAction)
            
            let addAction = UIAlertAction(title: "kaydet", style: .default){ [self] action in
                
                let name = specAlert.textFields!.first!.text!
                let phoneNumber = specAlert.textFields!.last!.text!
                
                
                if name != "" && phoneNumber != ""{
                    
                    let kisi = self.personsList[indexPath.row]
                    
                    kisi.kisi_ad = name
                    kisi.kisi_tel = phoneNumber
                    
                    appDelegate.saveContext()
                    
                    getPersons()
                    personsTableView.reloadData()
                }
            }
            
            specAlert.addAction(addAction)
            self.present(specAlert, animated: true)
            
        }
        return UISwipeActionsConfiguration(actions: [updateAction,deleteAction])
    }
}



extension ViewController:UISearchBarDelegate{

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchWord = searchText
        
        if searchText == ""{
            searching = false
            getPersons()
        }else{
            searching = true
            doSearch(person_name: searchWord!)
        }
        personsTableView.reloadData()
    }
    
}

