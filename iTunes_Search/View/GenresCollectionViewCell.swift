//
//  FavoriteSongsCollectionViewCell.swift
//  iTunes_Search
//
//  Created by Georgi Malkhasyan on 4/4/20.
//  Copyright © 2020 Malkhasyan. All rights reserved.
//

import UIKit

class GenresCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var genreImageView: UIImageView!
    @IBOutlet weak var genreNameLabel: UILabel!
    @IBOutlet weak var genreNameHolderView: UIView!
    
    
    
    func confiigurationGenreCell(_ albums: GenreModel) {
        
        self.genreNameLabel.text = albums.genreTitle
        self.genreImageView.image = UIImage(named: albums.genreImage!)
        
        genreNameHolderView.layer.cornerRadius = 10
        
        
        self.genreImageView.layer.cornerRadius = 8
        self.genreNameLabel.layer.shadowColor = UIColor.lightGray.cgColor
        self.genreNameLabel.layer.shadowRadius = 5
        self.genreNameLabel?.layer.shadowOpacity = 1
        self.genreNameLabel?.layer.shadowOffset = .zero
        
        
    }
    
    
    
}
