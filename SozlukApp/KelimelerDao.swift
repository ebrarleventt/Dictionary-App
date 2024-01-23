//
//  KelimelerDao.swift
//  SozlukApp
//
//  Created by Ebrar Levent on 23.01.2024.
//

import Foundation


//Bu sinifta veritabani uzerinde islemler yapicam. Veri cekme, silme gibi ama hangi tablo uzerinde? -> Kelimeler tablosu uzerinde
class KelimelerDao{
    
    let db:FMDatabase?
    
    //Icerisinde bazi kopyalama islemleriyle elde ettigimiz veriler olacak.
    //viewcontroller da veritabani kopyalamistik. Kopyaladigimiz yerden veritabanini bulucaz.
    
    
    //Veri okumaya hazir bir yapi oluyor:
    init(){
        
        //Dosya yoluna erisim
        let hedefYol = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        //Kopyalanan veritabanina erisim:
        let veritabaniURL = URL(fileURLWithPath: hedefYol).appendingPathComponent("sozluk.sqlite")
        
        db = FMDatabase(path: veritabaniURL.path)
        
        
    }
    
    
    
    //Tum kelimeleri al:
    func tumKisileriAl() -> [Kelimeler] {
        
        var liste = [Kelimeler]()
        
        db?.open()
        
        do{
            
            let rs = try db!.executeQuery("SELECT * FROM kelimeler", values: nil)
            
            while rs.next(){
                let kelime = Kelimeler(
                                       kelime_id: Int(rs.string(forColumn: "kelime_id"))!,
                                       ingilizce: rs.string(forColumn: "ingilizce")!,
                                       turkce: rs.string(forColumn: "turkce")!)
                
                liste.append(kelime)
                
            }
            
        }catch{
            print(error.localizedDescription)
        }
        
        db?.close()
        
        return liste
    }
    
    
    
    
    //Arama:
    func aramaYap(ingilizce:String) -> [Kelimeler] {
        
        var liste = [Kelimeler]()
        
        db?.open()
        
        do{
            
            let rs = try db!.executeQuery("SELECT * FROM kelimeler WHERE ingilizce like '%\(ingilizce)%'", values: nil)
            
            while rs.next(){
            
                let kelime = Kelimeler(
                    kelime_id: Int(rs.string(forColumn: "kelime_id"))!,
                    ingilizce: rs.string(forColumn: "ingilizce")!,
                    turkce: rs.string(forColumn: "turkce")!)
                
                liste.append(kelime)
        }
        }catch{
            print(error.localizedDescription)
        }
        
        db?.close()
        
        return liste
    }
    
    
    
    
}
