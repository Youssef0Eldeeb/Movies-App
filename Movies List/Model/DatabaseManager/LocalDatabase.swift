//
//  LocalDatabase.swift
//  Movies List
//
//  Created by Youssef Eldeeb on 17/08/2021.
//

import Foundation
import CoreData

//Unused
class LocalDatabse {
    
    var appDelegate:AppDelegate!
    var managedObjectContext : NSManagedObjectContext!
    
    
    var allMovies :[Result] = []
    
    
    
    
    func saveData(MovieObj: Result){
        
        let entity = NSEntityDescription.entity(forEntityName: "MovieLocal", in: managedObjectContext)!
        
        let movie = NSManagedObject(entity: entity, insertInto: managedObjectContext)
        
        movie.setValue(MovieObj.originalTitle, forKey: "originalTitle")
        movie.setValue(MovieObj.releaseDate, forKey: "releaseDate")
        movie.setValue(MovieObj.voteAverage, forKey: "voteAverage")
        movie.setValue(MovieObj.posterPath, forKey: "posterPath")
        movie.setValue(MovieObj.overview, forKey: "overview")
        
        do {
             try managedObjectContext.save()
            print("data saved")
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
    
    
    func displayData() -> [Result]{
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MovieLocal")
        
        do {
            let movies = try managedObjectContext.fetch(fetchRequest)
            
            for mov in movies {
           
               let originalTitle  = mov.value(forKey: "originalTitle") as! String
               let posterPath =  mov.value(forKey: "posterPath") as! String
               let releaseDate = mov.value(forKey: "releaseDate") as! String
               let voteAverage = mov.value(forKey: "voteAverage") as! Double
               let overview = mov.value(forKey: "overview") as! String

                
               let movObj = Result(id: 0, originalTitle: originalTitle, overview: overview, popularity: 0, posterPath: posterPath, releaseDate: releaseDate, voteAverage: voteAverage)
               allMovies.append(movObj)
           }
            
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        return allMovies
    }
}


