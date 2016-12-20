//
//  ThirdViewController.swift
//  Practica6
//
//  Created by Javier  Amor De La Cruz on 17/12/16.
//  Copyright © 2016 Javier  Amor De La Cruz. All rights reserved.
//

import UIKit

class ThirdViewController: UITableViewController {
    
    var ligas: [[String:Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Ligas"
        
        getLigas()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getLigas() {
        let ligasURL = "http://apiclient.resultados-futbol.com/scripts/api/api.php?key=8f696b3cbaf3af38cd3ab6fa2bc7f3a1&tz=Europe/Madrid&format=json&req=leagues&top=1&competitions=1,2,7,8,9,10,16,19"
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let queue = DispatchQueue(label: "Download Queu")
        queue.async {
            let url = URL(string: ligasURL)!
            do {
                var ligas: [[String: AnyObject]]!
                defer {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                let data = try Data(contentsOf: url)
                let dataJson = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                ligas = dataJson!["league"]! as! [[String: AnyObject]]
                DispatchQueue.main.async {
                    self.ligas = ligas
                    self.tableView.reloadData()
                }
            } catch let err {
                DispatchQueue.main.async {
                    self.title = "Desactualizado"
                    print("Error descargando = \(err.localizedDescription)")
                    let alert = UIAlertController(title: "Lo sentimos", message: "No se ha podido conectar con el servidor, comprueba tu conexión.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title:"Reintentar",
                                                  style: .default){
                                                    aa in self.getLigas()
                    })
                    self.present(alert, animated: true, completion: nil)
                    

                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Liga", for: indexPath)
        let equipo = ligas[indexPath.row]
        let nombre = equipo["name"] as? String
        cell.imageView?.image = #imageLiteral(resourceName: "liga")
        
        let queue = DispatchQueue(label: "img")
        queue.async {
            let imagenStr = equipo["logo"] as! String
            let imagenURL = URL(string: imagenStr)
            let dataImg = try? Data(contentsOf: imagenURL!)
            
            DispatchQueue.main.async {
            cell.imageView?.image = UIImage(data: dataImg!)
            }
        }
        
        cell.textLabel?.text = nombre
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ligas.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "clasificacion" {
            if let cvc = segue.destination as? ClasificacionTableViewController {
                // IndexPath de la celda seleccionada
                if let lt = tableView.indexPathForSelectedRow {
                    cvc.liga = ligas[lt.row]["name"] as! String
                    cvc.nLiga = ligas[lt.row]["id"] as! String
                }
            }
        }
        if segue.identifier == "partidos" {
            if let pvc = segue.destination as? PartidosTableViewController {
                // IndexPath de la celda seleccionada
                if let lt = tableView.indexPathForSelectedRow {
                    pvc.liga = ligas[lt.row]["name"] as! String
                    pvc.nLiga = ligas[lt.row]["id"] as! String
                }
            }
        }
    }
}
