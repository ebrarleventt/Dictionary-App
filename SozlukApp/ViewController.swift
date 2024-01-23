//
//  ViewController.swift
//  SozlukApp
//
//  Created by Ebrar Levent on 23.01.2024.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var kelimeTableView: UITableView!
    
    
    
    var kelimeListesi = [Kelimeler]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        veritabaniKopyala()
        
        kelimeTableView.delegate = self
        kelimeTableView.dataSource = self
        
        searchBar.delegate = self
        
        
        kelimeListesi = KelimelerDao().tumKisileriAl()
        
        
    }
    
    
    //Segue dan gelen index path ile Veri transferi:
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let index = sender as? Int
        
        let gidilecekVC = segue.destination as! KelimeDetayViewController
        gidilecekVC.kelime = kelimeListesi[index!]
        
    }
    
    
    
    
    func veritabaniKopyala(){
        
        //Oncelikle veritabanina erismemiz lazim:
        let bundleYolu = Bundle.main.path(forResource: "sozluk", ofType: ".sqlite")
        
        //Cihazda kopyalayacagim dosyayi belirtmem lazim:
        let hedefYol = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        //Kopyalama icin nesne:
        let fileManager = FileManager.default
        
        //Kopyalanacak yer:
        let kopyalanacakYer = URL(fileURLWithPath: hedefYol).appendingPathComponent("sozluk.sqlite")
        
        if fileManager.fileExists(atPath: kopyalanacakYer.path){
            print("Veritabani zaten var. Kopyalamaya gerek yok.")
        }else{
            
            do{
                
                try fileManager.copyItem(atPath: bundleYolu!, toPath: kopyalanacakYer.path)
                
            }catch{
                print("Hata: \(error)")
            }
            
        }
        
    }
    
    
    
    
}

extension ViewController:UITableViewDelegate, UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kelimeListesi.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let kelime = kelimeListesi[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "kelimeCell", for: indexPath) as! KelimeCellTableViewCell
        
        cell.ingilizceLabel.text = kelime.ingilizce
        cell.turkceLabel.text = kelime.turkce
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self .performSegue(withIdentifier: "kelimeToDetay", sender: indexPath.row)
        
    }
    
    
    
    
}





extension ViewController:UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        print("Arama Sonucu: \(searchText)")
        
        kelimeListesi = KelimelerDao().aramaYap(ingilizce: searchText)
        
        //arayuzu guncelleme:
        kelimeTableView.reloadData()
        
        
    }
    
    
    
}
