//
//  MovieCollectionViewCell.swift
//  Movies List
//
//  Created by Youssef Eldeeb on 14/08/2021.
//

import UIKit
import youtube_ios_player_helper_swift

class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var posterPathImage: UIImageView!
    
    @IBOutlet weak var playerView: YTPlayerView!
    
}
