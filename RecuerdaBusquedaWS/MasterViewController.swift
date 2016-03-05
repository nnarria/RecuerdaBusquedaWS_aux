//
//  MasterViewController.swift
//  RecuerdaBusquedaWS
//
//  Created by Nicolás Narria on 2/28/16.
//  Copyright © 2016 Nicolás Narria. All rights reserved.
//

import UIKit
import CoreData


struct DataLibro {
    var id: Int
    var titulo: String
    var isbn: String
    var portada:UIImage?
    var autores: [String]
    
    init (id: Int, titulo: String, isbn: String, autores: [String], portada: UIImage?) {
        self.id = id
        self.titulo = titulo
        self.isbn = isbn
        self.autores = autores
        self.portada = portada
    }
}

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    
    var libros:[DataLibro] = [DataLibro]()
    
    
    var libroAAgregar:DataLibro? = nil
    


    //modif x
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
        
        //print ("Volvi: " + (self.libroAAgregar?.isbn)!)
    
        if (self.libroAAgregar?.isbn != "") {
            agregarNuevoTitulo()
            
            print ("titulo agregado")
        }
        
        
    }
 
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(sender: AnyObject) {
        /*
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let miVistaDos = storyBoard.instantiateViewControllerWithIdentifier("SearchViewController") as! SearchViewController
        

        self.presentViewController(miVistaDos, animated:true, completion:nil)
        */
        
  

        
        self.performSegueWithIdentifier("showSearch", sender: self)

        
        
        
        
        
        /*
        let context = self.fetchedResultsController.managedObjectContext
        let entity = self.fetchedResultsController.fetchRequest.entity!
        let newManagedObject = NSEntityDescription.insertNewObjectForEntityForName(entity.name!, inManagedObjectContext: context)
             
        // If appropriate, configure the new managed object.
        // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
        newManagedObject.setValue(NSDate(), forKey: "timeStamp")
             
        // Save the context.
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //print("Unresolved error \(error), \(error.userInfo)")
            abort()
        }
        */
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
            //let object = self.fetchedResultsController.objectAtIndexPath(indexPath)
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                
                controller.libro = self.libros[indexPath.row]
                
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
            
            
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let context = self.fetchedResultsController.managedObjectContext
            context.deleteObject(self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject)
                
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                //print("Unresolved error \(error), \(error.userInfo)")
                abort()
            }
        }
    }

    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let object = self.fetchedResultsController.objectAtIndexPath(indexPath)
        //let peticion = object.managedObjectModel.fetchRequestTemplateForName("petBooks")
        
        let titulo = object.valueForKey("titulo") as! String
        let isbn = object.valueForKey("isbn") as! String
        var portada:UIImage = UIImage()
        if (object.valueForKey("portada") != nil) {
            portada = UIImage (data: object.valueForKey("portada") as! NSData)!
        }
        
        let autoresEntidad = object.valueForKey("tiene") as! Set<NSObject>
        var autores2:[String] = [String]()
                
        for autor in autoresEntidad {
            autores2.append((autor.valueForKey("nombre") as! String))
        }
        
        let dl = DataLibro(id: self.libros.count, titulo: titulo, isbn: isbn, autores: autores2, portada: portada)
        
        //libros.insert(dl, atIndex: 0)
        libros.append(dl)


        //cell.s
        //cell.textLabel!.text = object.valueForKey("timeStamp")!.description
        //cell.setValue(dl, forKey: dl.id)
        
        cell.textLabel!.text = titulo //object.valueForKey("timeStamp")!.description
    }
    
    
    

    // MARK: - Fetched results controller

    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest()
        
        let bookEntidad = NSEntityDescription.entityForName("Book", inManagedObjectContext: self.managedObjectContext!)
        fetchRequest.entity = bookEntidad
        fetchRequest.fetchBatchSize = 20
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //print("Unresolved error \(error), \(error.userInfo)")
            //abort()
        }

        
        
        
        
        
        
        
        
        /*
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName("Event", inManagedObjectContext: self.managedObjectContext!)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             //print("Unresolved error \(error), \(error.userInfo)")
             //abort()
        }
        */
        
        return _fetchedResultsController!
    }    
    var _fetchedResultsController: NSFetchedResultsController? = nil

    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
        
    }

    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
            case .Insert:
                self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            case .Delete:
                self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            default:
                return
        }
    }

    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
            case .Insert:
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            case .Delete:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            case .Update:
                self.configureCell(tableView.cellForRowAtIndexPath(indexPath!)!, atIndexPath: indexPath!)
            case .Move:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }

    /*
     // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
     
     func controllerDidChangeContent(controller: NSFetchedResultsController) {
         // In the simplest, most efficient, case, reload the table view.
         self.tableView.reloadData()
     }
     */
    
    
    func crearAutoresEntidad () -> Set<NSObject> {
        var entidades = Set<NSObject>()
        
        for author in (self.libroAAgregar?.autores)! {
            let authorEntidad = NSEntityDescription.insertNewObjectForEntityForName("Author", inManagedObjectContext: self.managedObjectContext!)
            authorEntidad.setValue(author, forKey: "nombre")
            
            entidades.insert(authorEntidad)
            
        }
        
        
        return entidades
    }
    
    
    func agregarNuevoTitulo () {
        
        //print ("ingreso: " + (self.libroAAgregar?.titulo)! + " :: "( +self.libroAAgregar?.isbn))
        
        
        if (self.libroAAgregar != nil) {
            let isbn_ = self.libroAAgregar?.isbn
        
        
            let bookEntidad = NSEntityDescription.entityForName("Book", inManagedObjectContext: self.managedObjectContext!)
            let peticion = bookEntidad?.managedObjectModel.fetchRequestFromTemplateWithName("petBook", substitutionVariables: ["isbn" : isbn_!])
        
            do {
                let bookEntidadAux = try self.managedObjectContext?.executeFetchRequest(peticion!)
            
                if (bookEntidadAux?.count > 0) {
                    return
                }
            }
            catch {
            }
        
        
        
            /* agregar el nuevo libro */
            let nuevoLibro = NSEntityDescription.insertNewObjectForEntityForName("Book", inManagedObjectContext: self.managedObjectContext!)
        
        
        
        
            nuevoLibro.setValue(libroAAgregar?.titulo, forKey: "titulo")
            nuevoLibro.setValue(libroAAgregar?.isbn, forKey: "isbn")
            
            if (libroAAgregar?.portada != nil) {
                nuevoLibro.setValue(UIImagePNGRepresentation((libroAAgregar?.portada)!), forKey: "portada")
            }
            
        
            nuevoLibro.setValue(crearAutoresEntidad(), forKey: "tiene")
        
        
            self.libros.append(self.libroAAgregar!)
        
            do {
                try self.managedObjectContext?.save()
            }
            catch {
            
            }
        }
        
        
        /*
        
        let context = self.fetchedResultsController.managedObjectContext
        let entity = self.fetchedResultsController.fetchRequest.entity!
        let newManagedObject = NSEntityDescription.insertNewObjectForEntityForName(entity.name!, inManagedObjectContext: context)
            
        // If appropriate, configure the new managed object.
        // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
        //newManagedObject.setValue(NSDate(), forKey: "timeStamp")
        
        newManagedObject.setValue(tituloAAgregar, forKey: "timeStamp")
        newManagedObject.setValue(isbnAAgregar, forKey: "isbn")
        
            
        // Save the context.
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //print("Unresolved error \(error), \(error.userInfo)")
            abort()
        }

        */
        
    }
    

}

