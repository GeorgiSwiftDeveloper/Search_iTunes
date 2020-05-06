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
    
    
    func confiigurationCell(_ albums: GenreModel) {
   
        self.genreNameLabel.text = albums.genreTitle
        self.genreImageView.image = UIImage(named: albums.genreImage)
        genreImageView.layer.borderWidth = 3
        genreImageView.layer.masksToBounds = false
        genreImageView.layer.borderColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        genreImageView.layer.shadowOpacity = 3
        genreImageView.layer.shadowPath = UIBezierPath(rect: genreImageView.bounds).cgPath
        genreImageView.layer.shadowRadius = 5
        genreImageView.layer.shadowOffset = .zero
        genreImageView.layer.cornerRadius = 7.0
        genreImageView.clipsToBounds = true
        self.genreImageView.layer.cornerRadius = self.genreImageView.frame.height/2
       
      }
    

    
}
