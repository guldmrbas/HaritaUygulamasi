//
//  ListViewController.swift
//  HaritalarUygualmasi
//
//  Created by Gülsüm Demirbaş on 26.03.2024.
//


// this is a test commnet from Muharrem Candan
import UIKit
import CoreData

var isimDizisi = [String]()
var idDizisi = [UUID]()
var secilmYerIsmi = ""
var seilenYerId : UUID?

class ListViewController: UIViewController , UITableViewDelegate , UITableViewDataSource  {
  
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(artiButonuTiklandi))
        
        veriAl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(veriAl), name: NSNotification.Name("yeniYerOlusturuldu"), object: nil)
    }
    @objc func artiButonuTiklandi(){
        secilmYerIsmi = ""
       performSegue(withIdentifier: "toMapsVC", sender: nil)
   }
    
    @objc func veriAl(){
        
        let appDelagete = UIApplication.shared.delegate as! AppDelegate
        let context = appDelagete.persistentContainer.viewContext
        
        // NSFetchReques : Core Data framework'ünün bir parçasıdır ve bu sınıf, veri tabanından veri almak için kullanılır.
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Yer")
        request.returnsObjectsAsFaults = false
        
        do {
            
            
            let sonuclar = try context.fetch(request)
            
            if  sonuclar.count > 0{
                
                isimDizisi.removeAll(keepingCapacity: false)
                idDizisi.removeAll(keepingCapacity: false)
                
                for sonuc in sonuclar as! [NSManagedObject]{
                    if let isim = sonuc.value(forKey: "isim") as? String{
                        isimDizisi.append(isim)
                        
                    }
                    if let id = sonuc.value(forKey: "id") as? UUID{
                        idDizisi.append(id)
                    }
                }
                tableView.reloadData()
                
            }
                
                
            }catch{
                print("Hata")
            }
        }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isimDizisi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = isimDizisi[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        secilmYerIsmi = isimDizisi[indexPath.row]
        seilenYerId = idDizisi[indexPath.row]
        performSegue(withIdentifier: "toMapsVC" , sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMapsVC" {
            let destinationVC = segue.destination as! MapsViewController
            destinationVC.secilenIsim = secilmYerIsmi
            destinationVC.secilenId = seilenYerId
        }
    }
        
    }
    
     
    
    
    

    


