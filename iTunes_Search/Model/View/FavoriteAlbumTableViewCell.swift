//
//  FavoriteAlbumTableViewCell.swift
//  iTunes_Search
//
//  Created by Georgi Malkhasyan on 3/31/20.
//  Copyright © 2020 Malkhasyan. All rights reserved.
//

import UIKit

class FavoriteAlbumTableViewCell: UITableViewCell {

    @IBOutlet weak var songImageView: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var singerNameLabel: UILabel!
    var genre = String()
    var trackViewUrl = String()
    var artworkURL = String()
    var title = String()
    var artist = String()
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    
    func confiigurationCell(albums: AlbumModel) {
        if albums.artworkURL != "" {
              self.songImageView.image = UIImage(data: NSData(contentsOf: URL(string:albums.artworkURL!)!)! as Data)

        }else{
              self.songImageView.image = UIImage(named: "")
        }
        
        
       DispatchQueue.main.async {
        self.songNameLabel.text = albums.title
            self.singerNameLabel.text = albums.artist
            self.genre = albums.genre!
            self.artworkURL = albums.artworkURL!
            self.title = albums.title!
            self.artist = albums.artist!
            self.trackViewUrl = albums.trackViewUrl!
            
            self.songNameLabel.numberOfLines = 0
            self.songNameLabel.font = UIFont(name: "Verdana", size: 12.0)
            self.songNameLabel.adjustsFontSizeToFitWidth = true
            self.songNameLabel.minimumScaleFactor = 0.5
            
        self.songImageView.layer.borderWidth = 1
        self.songImageView.layer.masksToBounds = false
        self.songImageView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.songImageView.layer.cornerRadius = self.songImageView.frame.height/2 
        self.songImageView.clipsToBounds = true
        }
    }
}
