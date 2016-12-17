//
//  ThirdViewController.swift
//  Practica6
//
//  Created by Javier  Amor De La Cruz on 17/12/16.
//  Copyright © 2016 Javier  Amor De La Cruz. All rights reserved.
//

import UIKit

class ThirdViewController: UITableViewController {
    
    var prueba = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Liga"
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Clasificación"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Equipo", for: indexPath)
        
        cell.imageView?.image = prueba%2 == 0 ? #imageLiteral(resourceName: "first") : #imageLiteral(resourceName: "second")
        cell.textLabel?.text = "Nombre equipo"
        cell.detailTextLabel?.text = "Puntuación y datos"
        
        prueba += 1
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numeroEquiposLiga = 20
        
        return numeroEquiposLiga
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Plantilla" {
            if let pvc = segue.destination as? FourthViewController {
                // IndexPath de la celda seleccionada
                if let ip = tableView.indexPathForSelectedRow {
                    //pvc.respuesta = "\(ip.section * ip.row)"
                }
            }
        }
    }
    

}
