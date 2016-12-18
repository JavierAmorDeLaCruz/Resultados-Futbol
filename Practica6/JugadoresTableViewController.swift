//
//  JugadoresTableViewController.swift
//  Practica6
//
//  Created by Javier  Amor De La Cruz on 18/12/16.
//  Copyright © 2016 Javier  Amor De La Cruz. All rights reserved.
//

import UIKit

class JugadoresTableViewController: UITableViewController {
    
    var teamID: String = "";
    var players: [[String:Any]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        get_players()
        self.tableView.reloadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    func get_players(){
        let Equipos_URL = "http://apiclient.resultados-futbol.com/scripts/api/api.php?key=8f696b3cbaf3af38cd3ab6fa2bc7f3a1&tz=Europe/Madrid&format=json&req=team&id=\(teamID)"
        
        title = "Descargando..."
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let queue = DispatchQueue(label: "download queue")
        queue.async{
            let url = URL(string: Equipos_URL)!
            do {
                let jsonData = try Data(contentsOf: url)
                print(jsonData)
                let json = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? NSDictionary
                //print(json)
                let InfoTeam: NSDictionary = (json!["team"]! as? NSDictionary)!
                let Roster: [[String:AnyObject]] = InfoTeam["squad"]! as! [[String:AnyObject]]
                print(Roster)
                //print(json!["teams"])
                //let newEquipos:[[String:AnyObject]]=json!["teams"] as [[String:AnyObject]]
                //print(newEquipos)
                //let newEquipos = json["teams"] as? [[String:Any]]
                //let newEquipos:[[String:Any]] = []
                
                DispatchQueue.main.async {
                    self.players = Roster
                    self.tableView.reloadData()
                    self.title = "Plantilla"
                }
            } catch let err {
                DispatchQueue.main.async {
                    print("Error descargando = \(err.localizedDescription)")
                    self.title = "Desactualizado"
                }
            }
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return players.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath)

        let dic = players[indexPath.row]
        
        cell.textLabel?.text = dic["nick"] as? String
        if let dorsal = dic["squadNumber"] as? String? {
           cell.detailTextLabel?.text = "Dorsal: \(dorsal!)"
        } else {
            cell.detailTextLabel?.text = "Dorsal Desconocido"
        }
        
        
        
        let session = URLSession.shared
        // Crear una sesión
        // Mostrar indicador de actividad de red
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        // URL de la imagen
        let imgUrl = dic["image"] as! String
        let url = URL(string: imgUrl)!
        let task = session.dataTask(with: url) { (data: Data?,
            response: URLResponse?,
            error: Error? ) in
            if error == nil && (response as! HTTPURLResponse).statusCode == 200 {
                if let img = UIImage(data: data!) {
                    // Construir imagen
                    DispatchQueue.main.async  {
                        cell.imageView?.image = img
                        // Mostrar la imagen
                    }
                } else { print("Error construyendo la imagen") }
            } else { print("Error descargando") }
            // Ocultar indicador de actividad de red
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
        // Arrancar la tarea
        task.resume()
        
        return cell
    }
    

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
