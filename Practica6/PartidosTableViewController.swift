//
//  PartidosTableViewController.swift
//  Practica6
//
//  Created by Carlos  on 19/12/16.
//  Copyright © 2016 Javier  Amor De La Cruz. All rights reserved.
//

import UIKit

class PartidosTableViewController: UITableViewController {

    var partidos: [[String:Any]] = []
    var nLiga: String!
    var liga: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Partidos del día \(liga!)"
        getPartidos()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getPartidos() {
        let partidosURL = "http://apiclient.resultados-futbol.com/scripts/api/api.php?key=8f696b3cbaf3af38cd3ab6fa2bc7f3a1&tz=Europe/Madrid&format=json&req=matchs&league=\(nLiga!)&order=twin&twolegged=1"
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let queue = DispatchQueue(label: "Download Queue")
        queue.async {
            let url = URL(string: partidosURL)!
            do {
                var partidos: [[String: AnyObject]]!
                defer {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                let data = try Data(contentsOf: url)
                let dataJson = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                partidos = dataJson!["match"]! as! [[String: AnyObject]]
                
                DispatchQueue.main.async {
                    self.partidos = partidos
                    self.tableView.reloadData()
                }
            } catch let err {
                DispatchQueue.main.async {
                    self.title = "Desactualizado"
                    print("Error descargando = \(err.localizedDescription)")
                }
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return partidos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Partido", for: indexPath) as! PartidosTableViewCell
        let partido = partidos[indexPath.row]
        let local = partido["local_abbr"] as? String
        let visitor = partido["visitor_abbr"] as? String
        let resultado = partido["result"] as? String
        let dia = partido["date"] as? String
        let hora = partido["hour"] as? String
        let min = partido["minute"] as? String
        let fecha = "\(dia!) - \(hora!):\(min!)"
        cell.localImg?.image = #imageLiteral(resourceName: "escudo")
        cell.visitorImg?.image = #imageLiteral(resourceName: "escudo")
        
        let queue = DispatchQueue(label: "img")
        queue.async {
            let imagenStrLocal = partido["local_shield"] as! String
            let imagenURLLocal = URL(string: imagenStrLocal)
            let dataImgLocal = try? Data(contentsOf: imagenURLLocal!)
            
            let imagenStrVisitante = partido["visitor_shield"] as! String
            let imagenURLVisitante = URL(string: imagenStrVisitante)
            let dataImgVisitante = try? Data(contentsOf: imagenURLVisitante!)
            
            DispatchQueue.main.async {
                cell.localImg?.image = UIImage(data: dataImgLocal!)
                cell.visitorImg?.image = UIImage(data: dataImgVisitante!)
            }
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let fechaActual = dateFormatter.string(from: Date())
        
        cell.localStr?.text = local
        cell.visitorStr?.text = visitor
        cell.resultado?.text = resultado == "x-x" ? "-" : resultado
        cell.fecha?.text = dia! >= fechaActual ? fecha : "FINALIZADO"
        
        return cell
    }
}
