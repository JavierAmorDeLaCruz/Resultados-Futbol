//
//  ClasificacionTableViewController.swift
//  Practica6
//
//  Created by Carlos  on 19/12/16.
//  Copyright © 2016 Javier  Amor De La Cruz. All rights reserved.
//

import UIKit

class ClasificacionTableViewController: UITableViewController {
    
    var equipos: [[String:AnyObject]] = []
    var liga: String!
    var nLiga: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = liga!
        
        getClasificacion()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getClasificacion() {
        let ligaURL = "http://apiclient.resultados-futbol.com/scripts/api/api.php?key=8f696b3cbaf3af38cd3ab6fa2bc7f3a1&tz=Europe/Madrid&format=json&req=tables&league=\(nLiga!)&group=all"
        
        if let url = URL(string: ligaURL) {
            // let queue = DispatchQueue(label: "Download Queu")
            //queue.async {
            var equipos: [[String: AnyObject]] = self.equipos
            /*DispatchQueue.main.async {
             UIApplication.shared.isNetworkActivityIndicatorVisible = true
             }*/
            if let data = try? Data(contentsOf: url) {
                let dataJson = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                equipos = dataJson!!["table"]! as! [[String: AnyObject]]
            }
            //DispatchQueue.main.async {
            //  UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.equipos = equipos
            self.tableView.reloadData()
            //  }
            //}
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Clasificación"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Equipo", for: indexPath)
        let equipo = equipos[indexPath.row]
        let nombre = equipo["team"] as? String
        let puntos = equipo["points"]
        let partidosGanados = equipo["wins"]
        let partidosEmpatados = equipo["draws"]
        let partidosPerdidos = equipo["losses"]
        let imagenStr = equipo["shield"] as! String
        let imagenURL = URL(string: imagenStr)
        let dataImg = try? Data(contentsOf: imagenURL!)
        
        cell.textLabel?.text = nombre
        cell.detailTextLabel?.text = "Posición: \(indexPath.row + 1) (\(puntos!) puntos) - V: \(partidosGanados!);E: \(partidosEmpatados!);D: \(partidosPerdidos!)"
        cell.imageView?.image = UIImage(data: dataImg!)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return equipos.count
    }
    
}
