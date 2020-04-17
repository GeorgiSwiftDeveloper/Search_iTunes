//
//  GenreListViewController.swift
//  iTunes_Search
//
//  Created by Georgi Malkhasyan on 4/16/20.
//  Copyright © 2020 Malkhasyan. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
//let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
class GenreListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var topGenreLabelText: UILabel!
    
    @IBOutlet weak var genreTableView: UITableView!
    var genreTitle: GenreModel?
    var videoArray = [Video]()
    var getYouTubeData  = YouTubeVideoConnection()
    var arrrayInt = Int()
    var checkifDataIsEmpty = true
    var isEmpty: Bool {
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "YouTubeDataModel")
            let count  = try context?.count(for: request)
            return count == 0
        } catch {
            return true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        topGenreLabelText.text  = "Top \(genreTitle!.genreTitle) Song's"
        genreTableView.delegate = self
        genreTableView.dataSource = self
        
        if isEmpty{
            self.getYouTubeData.getFeedVideos(genreType: self.genreTitle!.genreTitle) { (loadVideolist, error) in
                if error != nil {
                    print(error?.localizedDescription)
                }else{
                    DispatchQueue.main.async{
                        self.videoArray = loadVideolist!
                        for songIndex in 0..<self.videoArray.count{
                            let title =   self.videoArray[songIndex].videoTitle
                            let description =  self.videoArray[songIndex].videoDescription
                            let image =  self.videoArray[songIndex].videoImageUrl
                            let playlistId = self.videoArray[songIndex].videoPlaylistId
                            let videoId =  self.videoArray[songIndex].videoId
                            
                            self.saveItems(title: title, description: description, image: image, videoId: videoId, playlistId: playlistId)
                            
                        }
                        self.genreTableView.reloadData()
                    }
                }
            }
        }else{
            self.fetchFromCoreData { (videoList, error) in
                if error != nil {
                    print(error?.localizedDescription)
                }else{
                    if videoList != nil {
                        self.videoArray.append(videoList!)
                        self.genreTableView.reloadData()
                    }else{
                        //                    self.checkifDataIsEmpty = false
                    }
                }
            }
            
        }
    }
    
    func saveItems(title:String,description:String,image:String,videoId:String,playlistId:String) {
        let entity = NSEntityDescription.entity(forEntityName: "YouTubeDataModel", in: context!)
        let newEntity = NSManagedObject(entity: entity!, insertInto: context)
        //        checkifDataIsEmpty = true
        newEntity.setValue(title, forKey: "title")
        newEntity.setValue(image, forKey: "image")
        newEntity.setValue(videoId, forKey: "videoId")
        newEntity.setValue(description, forKey: "songDescription")
        newEntity.setValue(playlistId, forKey: "playlistId")
        do {
            try context?.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func fetchFromCoreData(loadVideoList: @escaping(_ returnVideoList: Video?, _ returnError: Error? ) -> ()){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "YouTubeDataModel")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context?.fetch(request)
            for data in result as! [NSManagedObject] {
                let title = data.value(forKey: "title") as! String
                let image = data.value(forKey: "image") as! String
                let videoId = data.value(forKey: "videoId") as! String
                let songDescription = data.value(forKey: "songDescription") as! String
                let playlistId = data.value(forKey: "playlistId") as! String
                let fetchedVideoList = Video(videoId: videoId, videoTitle: title, videoDescription: songDescription, videoPlaylistId: playlistId, videoImageUrl: image)
                loadVideoList(fetchedVideoList,nil)
            }
            
        } catch {
            loadVideoList(nil,error)
            print("Failed")
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "genreCell", for: indexPath) as? GenreVideoTableViewCell {
            cell.configureGenreCell(videoArray[indexPath.row])
            //        arrrayInt = indexPath.row
            //        print(arrrayInt)
            return cell
        }else {
            return GenreVideoTableViewCell()
        }
    }
    
    
}