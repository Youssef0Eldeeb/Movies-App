//
//  FavoriteTableViewController.swift
//  Movies List
//
//  Created by Youssef Eldeeb on 18/08/2021.
//

import UIKit
import SDWebImage
import CoreData

class FavoriteTableViewController: UITableViewController {

    var appDelegate:AppDelegate!
    var managedObjectContext : NSManagedObjectContext!
    
    var fevotieArray : [Result] = []
    var coreDataArray : [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
    }
    override func viewWillAppear(_ animated: Bool) {
        fevotieArray = []
        displayData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fevotieArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = fevotieArray[indexPath.row].originalTitle
        
        let quaryPosterPath = fevotieArray[indexPath.row].posterPath
        let url = "https://image.tmdb.org/t/p/w185\(quaryPosterPath)"
        
        cell.imageView?.sd_setImage(with: URL(string: "\(url)"), placeholderImage: UIImage(systemName: "exclamationmark.triangle"))
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let userDefault = UserDefaults.standard
            let deletedMovieTitle = fevotieArray[indexPath.row].originalTitle
            userDefault.setValue(false, forKey: "highLightStar \(deletedMovieTitle)" )
            
            fevotieArray.remove(at: indexPath.row)
            managedObjectContext.delete(coreDataArray[indexPath.row])
            
            do{
                try managedObjectContext.save()
            }catch let error as NSError {
                print(error.localizedDescription)
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
//            tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    func displayData(){
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FevoriteLocal")
        
        do {
            coreDataArray = try managedObjectContext.fetch(fetchRequest)
            for mov in coreDataArray {
           
               let originalTitle  = mov.value(forKey: "originalTitle") as! String
               let posterPath =  mov.value(forKey: "posterPath") as! String
               
                let movObj = Result(id: 0, originalTitle: originalTitle, overview: "", popularity: 0, posterPath: posterPath, releaseDate: "", voteAverage: 0.0)
               fevotieArray.append(movObj)
           }
            tableView.reloadData()
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
}
