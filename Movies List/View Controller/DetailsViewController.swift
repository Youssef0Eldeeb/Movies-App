//
//  ViewController.swift
//  Movies List
//
//  Created by Youssef Eldeeb on 14/08/2021.
//

import UIKit
import Cosmos
import SDWebImage
import youtube_ios_player_helper_swift
import CoreData

class ViewController: UIViewController {

    var appDelegate:AppDelegate!
    var managedObjectContext : NSManagedObjectContext!
    
    var obj : Result!
    var videoResultArray : [VideoResult] = []
    var reviewResultArray : [ReviewResult] = []
    
    let userDefault = UserDefaults.standard
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var moviePosterImage: UIImageView!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var videoCollectionView: UICollectionView!
    @IBOutlet weak var reviewTextview: UITextView!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    
    @IBAction func favoriteBtn(_ sender: Any) {
        favoriteBtn.setImage(UIImage.init(systemName: "star.fill"), for: .normal)
        userDefault.setValue(true, forKey: "highLightStar \(obj.originalTitle)" )
        saveData(MovieObj: obj)
    }
   
    @IBAction func reviewBtn(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(identifier: "vcc")as? ReviewTableViewController{
            vc.reviewArray = reviewResultArray
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Check if the star is highlight or no
        let highLightCheck = userDefault.bool(forKey: "highLightStar \(obj.originalTitle)")
        if highLightCheck {
            favoriteBtn.setImage(UIImage.init(systemName: "star.fill"), for: .normal)
        }else{
            favoriteBtn.setImage(UIImage.init(systemName: "star"), for: .normal)
        }
        
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        favoriteBtn.tintColor = #colorLiteral(red: 0.90296489, green: 0.7730246186, blue: 0.3503800631, alpha: 1)
        
        // Display Component
        movieTitleLabel.text = "  \(obj.originalTitle)"
        
        let quaryPosterPath = obj.posterPath
        let url = "https://image.tmdb.org/t/p/w185\(quaryPosterPath)"
        moviePosterImage.sd_setImage(with: URL(string: "\(url)"), placeholderImage: UIImage(systemName: "exclamationmark.triangle"))
        moviePosterImage.layer.cornerRadius = 5
        moviePosterImage.layer.borderWidth = 1.5
        moviePosterImage.layer.borderColor = UIColor.yellow.cgColor
        
        releaseDate.text = obj.releaseDate
        
        let ratingValue = (obj.voteAverage)/2
        ratingView.rating = ratingValue
        
        overviewLabel.text = obj.overview
         
        }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        //fetch videos from Api
        ApiManager().fectchVideos(key: obj.id) { fetchedArray, error in
            if let unwrapedFetchedArray = fetchedArray{
                self.videoResultArray = unwrapedFetchedArray
                self.videoCollectionView.reloadData()
            }
            if let unwrapedError = error{
                print(unwrapedError)
            }
        }
        
        //fetch review from Api
        ApiManager().fectchReview(key: obj.id) { fetchedArray, error in
            if let unwrapedFetchedArray = fetchedArray{
                self.reviewResultArray = unwrapedFetchedArray
            }
            if !(self.reviewResultArray .isEmpty){
            self.reviewTextview.text = self.reviewResultArray[0].content
            }
            if let unwrapedError = error{
                print(unwrapedError)
            }
        }
        
       setupUi()
    }
    
}





// Video Collection View Display

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return videoResultArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videoCell", for: indexPath) as! MovieCollectionViewCell
        
        cell.playerView.load(videoId: videoResultArray[indexPath.row].key)
        
        return cell
    }
    
    
    // Video Collection View Design
    func setupUi(){

        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)), subitem: item ,count: 1)

        let section = NSCollectionLayoutSection(group: group)
        
        section.orthogonalScrollingBehavior = .paging

        let layout = UICollectionViewCompositionalLayout(section: section)

        videoCollectionView.collectionViewLayout = layout


    }
    
    func saveData(MovieObj: Result){
        
        let entity = NSEntityDescription.entity(forEntityName: "FevoriteLocal", in: managedObjectContext)!
        let movie = NSManagedObject(entity: entity, insertInto: managedObjectContext)
        
        movie.setValue(MovieObj.originalTitle, forKey: "originalTitle")
        movie.setValue(MovieObj.posterPath, forKey: "posterPath")
        
        do {
             try managedObjectContext.save()
            print("data saved")
        }
        
        catch let error as NSError {
            print(error.localizedDescription)
        }
    }
 
    
}
