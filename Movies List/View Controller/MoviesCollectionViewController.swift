//
//  MoviesCollectionViewController.swift
//  Movies List
//
//  Created by Youssef Eldeeb on 14/08/2021.
//

import UIKit
import SDWebImage
import CoreData


class MoviesCollectionViewController: UICollectionViewController , UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var sortBtn: UIBarButtonItem!
    
    var appDelegate:AppDelegate!
    var managedObjectContext : NSManagedObjectContext!
    var resultArray: [Result] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        // Check on Internet Connection
        if !(NetworkManager.shared.isConnected()) {
            displayData() 
        }
        
        //Design of Collection View Component
        //setupUi()
        
        //Create Menu of Sort Button
        let sortMenu = UIMenu(title: "", children: [
            UIAction(title: "Highst Rate", handler: { _ in
                self.activityIndicator.startAnimating()
                let sortedArray = self.resultArray.sorted { first, second in
                    return first.voteAverage > second.voteAverage
                }
                self.resultArray = sortedArray
                self.collectionView.reloadData()
                self.activityIndicator.stopAnimating()
            }),
            UIAction(title: "Popularity", handler: { _ in
                self.activityIndicator.startAnimating()
                let sortedArray = self.resultArray.sorted { first, second in
                    return first.popularity > second.popularity
                }
                self.resultArray = sortedArray
                self.collectionView.reloadData()
                self.activityIndicator.stopAnimating()
            })
        ])
        
        self.sortBtn.menu = sortMenu
        
    }
 
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        //Fetch Data from Api
        ApiManager().fetchData { fetchedArray, error in
            
            self.activityIndicator.stopAnimating()
            
            if let unwrapedFetchedArray = fetchedArray{
                self.resultArray = unwrapedFetchedArray
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
//                for result in self.resultArray{
//                    self.saveData(MovieObj: result)
//                }
            }
            if let unwrapedError = error{
                print(unwrapedError)
            }
    }
 }
    
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return resultArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MovieCollectionViewCell
        
        // design of image border
        cell.posterPathImage.layer.cornerRadius = 5
        cell.posterPathImage.layer.borderWidth = 1.5
        cell.posterPathImage.layer.borderColor = UIColor.yellow.cgColor

        let quaryPosterPath = resultArray[indexPath.row].posterPath
        let url = "https://image.tmdb.org/t/p/w185\(quaryPosterPath)"
        cell.posterPathImage.sd_setImage(with: URL(string: "\(url)"), placeholderImage: UIImage(systemName: "exclamationmark.triangle"))

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 182.5, height: 280)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let vc = storyboard?.instantiateViewController(identifier: "VC")as? ViewController{
            vc.obj = resultArray[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    
    func setupUi(){

        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))

        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.34)), subitem: item ,count: 2)

        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)

        collectionView.collectionViewLayout = layout
    }
    
    
    
//save and display data by CoreData
    
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

    func displayData(){
        
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
               resultArray.append(movObj)
           }
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
}
