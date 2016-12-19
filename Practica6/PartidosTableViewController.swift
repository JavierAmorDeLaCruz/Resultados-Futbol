//
//  PartidosTableViewController.swift
//  Practica6
//
//  Created by Carlos  on 19/12/16.
//  Copyright © 2016 Javier  Amor De La Cruz. All rights reserved.
//

import UIKit

class PartidosTableViewController: UITableViewController {

    var partidos: [[String:AnyObject]] = []
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
        if let url = URL(string: partidosURL) {
            var partidos: [[String: AnyObject]] = self.partidos
            if let data = try? Data(contentsOf: url) {
                let dataJson = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                partidos = dataJson!!["match"]! as! [[String: AnyObject]]            }
            self.partidos = partidos
            self.tableView.reloadData()
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
        var imagenStr = partido["local_shield"] as! String
        var imagenURL = URL(string: imagenStr)
        var dataImg = try? Data(contentsOf: imagenURL!)
        
        cell.localImg?.image = UIImage(data: dataImg!)
        
        imagenStr = partido["visitor_shield"] as! String
        imagenURL = URL(string: imagenStr)
        dataImg = try? Data(contentsOf: imagenURL!)
        
        cell.visitorImg?.image = UIImage(data: dataImg!)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let fechaActual = dateFormatter.string(from: Date())
        
        cell.localStr?.text = local
        cell.visitorStr?.text = visitor
        cell.resultado?.text = resultado == "x-x" ? "-" : resultado
        cell.fecha?.text = dia! >= fechaActual ? fecha : "FINALIZADO"
        
        return cell
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
