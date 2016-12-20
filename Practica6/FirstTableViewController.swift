//
//  FirstTableViewController.swift
//  Practica6
//
//  Created by Javier  Amor De La Cruz on 18/12/16.
//  Copyright © 2016 Javier  Amor De La Cruz. All rights reserved.
//

import UIKit

class FirstTableViewController: UITableViewController {
    
    var live_matches: [[String:Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        get_liveMatches()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    func refresh(){
    get_liveMatches()
    refreshControl?.endRefreshing()
    }
    
    func get_liveMatches(){
        let Equipos_URL = "http://apiclient.resultados-futbol.com/scripts/api/api.php?key=8f696b3cbaf3af38cd3ab6fa2bc7f3a1&tz=Europe/Madrid&format=json&req=livescore"
        
        self.navigationItem.title = "Descargando..."
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let queue = DispatchQueue(label: "download queue")
        queue.async{
            let url = URL(string: Equipos_URL)!
            do {
                let jsonData = try Data(contentsOf: url)
                print(jsonData)
                let json = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? NSDictionary
                //print(json)
                if let liveMatches: [[String : AnyObject]] = json!["matches"]! as? [[String: AnyObject]] {
                print(liveMatches)
                //print(json!["teams"])
                //let newEquipos:[[String:AnyObject]]=json!["teams"] as [[String:AnyObject]]
                //print(newEquipos)
                //let newEquipos = json["teams"] as? [[String:Any]]
                //let newEquipos:[[String:Any]] = []
                
                DispatchQueue.main.async {
                    self.live_matches = liveMatches
                    self.tableView.reloadData()
                    self.navigationItem.title = "Partidos en Directo"
                }
                }else {
                    let alert = UIAlertController(title: "Ups...", message: "En este momento no hay partidos en juego", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title:"OK",
                                                  style: .default){
                                                    aa in self.refresh()
                    })
                    self.present(alert, animated: true, completion: nil)

                }
            } catch let err {
                DispatchQueue.main.async {
                    print("Error descargando = \(err.localizedDescription)")
                    self.title = "Desactualizado"
                    let alert = UIAlertController(title: "Lo sentimos", message: "No se ha podido conectar con el servidor, comprueba tu conexión.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title:"Reintentar",
                                                  style: .default){
                                                    aa in self.get_liveMatches()
                    })
                    self.present(alert, animated: true, completion: nil)
                    

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
        return live_matches.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "matchCell", for: indexPath) as! FirstCustomTableViewCell
        
        let dic = live_matches[indexPath.row]
        
        cell.result_label.text = dic["result"] as? String
        cell.local_label.text = dic["local"] as? String
        cell.visitor_label.text = dic["visitor"] as? String
        if let min = dic["live_minute"] as? String {
            if min == "Des" {cell.min_label.text  = "Tiempo de descuento"}
            else if min == "" {cell.min_label.text  = "Minuto desconocido"}
            else {cell.min_label.text = "Minuto \(dic["live_minute"] as! String)" }
        }
        
        
        
        
        let session = URLSession.shared
        // Crear una sesión
        // Mostrar indicador de actividad de red
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        // URL de la imagen
        let imgUrl1 = dic["local_shield"] as! String
        let imgUrl2 = dic["visitor_shield"] as! String
        let url1 = URL(string: imgUrl1)!
        let url2 = URL(string: imgUrl2)!
        let task1 = session.dataTask(with: url1) { (data: Data?,
            response: URLResponse?,
            error: Error? ) in
            if error == nil && (response as! HTTPURLResponse).statusCode == 200 {
                if let img = UIImage(data: data!) {
                    // Construir imagen
                    DispatchQueue.main.async  {
                        cell.home_shield.image = img
                        // Mostrar la imagen
                    }
                } else { print("Error construyendo la imagen") }
            } else { print("Error descargando") }
            // Ocultar indicador de actividad de red
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
        let task2 = session.dataTask(with: url2) { (data: Data?,
            response: URLResponse?,
            error: Error? ) in
            if error == nil && (response as! HTTPURLResponse).statusCode == 200 {
                if let img = UIImage(data: data!) {
                    // Construir imagen
                    DispatchQueue.main.async  {
                        cell.visitor_shield.image = img
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
        task1.resume()
        task2.resume()
        
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
