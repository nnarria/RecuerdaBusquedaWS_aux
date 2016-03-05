//
//  DetailViewController.swift
//  RecuerdaBusquedaWS
//
//  Created by Nicolás Narria on 2/28/16.
//  Copyright © 2016 Nicolás Narria. All rights reserved.
//

import UIKit
import SystemConfiguration

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var portada: UIImageView!
    
    @IBOutlet weak var tituloLibro: UITextView!
    @IBOutlet weak var titAutores: UILabel!
    @IBOutlet weak var listaAutores: UITextView!


    var libro: DataLibro!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        print ("hola:\(libro.titulo)")
        
        self.tituloLibro.text? = ""+libro.titulo
        self.portada.image = libro.portada
        
        self.titAutores.text = String(libro.autores.count)  + " Autor(es)"
        
        var aux: String = ""
        var i: Int = 1
        for nombreAutor in libro.autores {
            aux += String(i) + " - " + nombreAutor + "\n"
            i++
        }
        self.listaAutores.text = aux
        
    }
    
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

