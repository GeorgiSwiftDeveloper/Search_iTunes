//
//  TopHitsListTableViewCell.swift
//  iTunes_Search
//
//  Created by Georgi Malkhasyan on 4/28/20.
//  Copyright © 2020 Malkhasyan. All rights reserved.
//

import UIKit

class SellectedSectionTableViewCell: UITableViewCell {

    @IBOutlet weak var topHitImageView: UIImageView!
    @IBOutlet weak var topHitLabelText: UILabel!
    @IBOutlet weak var addToFavoriteButton: UIButton!
    var videoID = String()
    var videoImageUrl = String()
    
   func configureTopHitsCell(_ video: Video){
            videoID = video.videoId
            videoImageUrl = video.videoImageUrl
           topHitLabelText.text = video.videoTitle
          let imageUrl = URL(string: video.videoImageUrl)
           do{
               let data:NSData = try NSData(contentsOf: imageUrl!)
               topHitImageView.image =  UIImage(data: data as Data)
               
           }catch{
               print("error")
           }
           topHitImageView.layer.borderWidth = 3
           topHitImageView.layer.masksToBounds = false
           topHitImageView.layer.borderColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
           topHitImageView.layer.shadowOpacity = 2
           topHitImageView.layer.shadowPath = UIBezierPath(rect: topHitImageView.bounds).cgPath
           self.topHitImageView.layer.cornerRadius = self.topHitImageView.frame.height/2
           topHitImageView.layer.shadowRadius = 3
           topHitImageView.layer.shadowOffset = .zero
           topHitImageView.clipsToBounds = true
       }
    
    
    func configureMyLibraryCell(_ video: Video){
             
             topHitLabelText.text = video.videoTitle
            let imageUrl = URL(string: video.videoImageUrl)
             do{
                 let data:NSData = try NSData(contentsOf: imageUrl!)
                 topHitImageView.image =  UIImage(data: data as Data)
                 
             }catch{
                 print("error")
             }
             topHitImageView.layer.borderWidth = 3
             topHitImageView.layer.masksToBounds = false
             topHitImageView.layer.borderColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
             topHitImageView.layer.shadowOpacity = 2
             topHitImageView.layer.shadowPath = UIBezierPath(rect: topHitImageView.bounds).cgPath
             self.topHitImageView.layer.cornerRadius = self.topHitImageView.frame.height/2
             topHitImageView.layer.shadowRadius = 3
             topHitImageView.layer.shadowOffset = .zero
             topHitImageView.clipsToBounds = true
         }

}
