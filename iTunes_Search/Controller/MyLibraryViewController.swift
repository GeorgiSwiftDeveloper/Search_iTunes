//
//  MyLibraryViewController.swift
//  iTunes_Search
//
//  Created by Georgi Malkhasyan on 4/24/20.
//  Copyright © 2020 Malkhasyan. All rights reserved.
//

import UIKit
import CoreData
import WebKit
import  YoutubePlayer_in_WKWebView



class MyLibraryViewController: UIViewController, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating, WKNavigationDelegate, WKYTPlayerViewDelegate,CheckIfMusicRecordDeletedDelegate  {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var myLibraryTableView: UITableView!
    @IBOutlet weak var noTracksFoundView: UIView!
    @IBOutlet weak var genreCollectionView: UICollectionView!
    
    
    var selectedGenreIndexRow = Int()
    
    var myLibraryListArray = [Video]()
    var webView = WKYTPlayerView()
    var selectTopHitsRow = Bool()
    var selectLibraryRow = Bool()
    
    
    var youTubeVideoID = String()
    var youTubeVideoTitle = String()
    var checkTableViewName: String = ""
    var sectionButton = UIButton()
    var videoSelected = Bool()
    var viewAllButton = UIButton()
    var videoPlayerClass = VideoPlayer()
    var checkIfRecentPlaylistIsEmpty = Bool()
    var selectedGenreRowTitleHolder = String()
    
    
    var searchLibrary = [Video]()
    var searching: Bool = false
    var searchConnectionManager = SearchConnection()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        self.view.accessibilityIdentifier = "MyLibrary"
    
        checkIfNoTracksFound()
        setupSearchNavBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        videoPlayerStatus()
        fetchVideoData(firstTime: false)
        checkIfNoTracksFound()
    }
    
    
    func videoPlayerStatus(){
        
        let pause = UserDefaults.standard.object(forKey: "pause") as? Bool
        switch pause {
        case true:
            updatePlayerView()
        case false:
            updatePlayerView()
        default:
            break
        }
    }
    
    func  updatePlayerView() {
        DispatchQueue.main.async {
            VideoPlayer.callVideoPlayer.cardViewController.removeFromParent()
            VideoPlayer.callVideoPlayer.superViewController = self
            self.view.addSubview(VideoPlayer.callVideoPlayer.cardViewController.view)
        }
        VideoPlayer.callVideoPlayer.webView.getPlayerState({ [weak self] (playerState, error) in
            if let error = error {
                print("Error getting player state:" + error.localizedDescription)
            } else  {
                
                self?.updatePlayerState(playerState)
            }
        })
    }
    
    func checkIfNoTracksFound () {
        if self.myLibraryListArray.count == 0  {
            self.noTracksFoundView.isHidden = false
        }else{
            self.noTracksFoundView.isHidden = true
        }
    }
    
    
    func fetchVideoData(firstTime: Bool) {
        if firstTime {
            fetchVideoWithEntityName(myLibraryEntityName)
        }else{
            CoreDataVideoClass.coreDataVideoInstance.getCoreDataEntityCount(entityName: myLibraryEntityName, currentDataCount: myLibraryListArray.count) { (result) in
                if result == false {
                    self.myLibraryListArray = []
                    self.fetchVideoWithEntityName(myLibraryEntityName)
                }
            }
        }
    }
    
    
    func fetchVideoWithEntityName(_ entityName: String){
        
        
        CoreDataVideoClass.coreDataVideoInstance.fetchVideoWithEntityName(coreDataEntityName: entityName, searchBarText: "", playlistName: "") { [weak self](result) in
            
            guard let self = self else{ return}
            switch entityName {
            case myLibraryEntityName:
                switch result {
                case .success(let videoList):
                    self.myLibraryListArray.append(contentsOf: videoList)
                    let libraryCount = self.myLibraryListArray.count <= 5 ? true : false
                    
                    self.viewAllButton.isHidden = libraryCount
                    
                    DispatchQueue.main.async {
                        self.myLibraryTableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            default:
                break
                
            }
        }
    }
    
    
    
    
    
    func updatePlayerState(_ playerState: WKYTPlayerState){
        switch playerState {
        case .ended:
            self.showVideoPlayerPause()
        case .paused:
            self.showVideoPlayerPause()
        case .playing:
            self.showVideoPlayer()
        default:
            break
        }
    }
    
    func showVideoPlayer(){
        VideoPlayer.callVideoPlayer.webView.playVideo()
    }
    func showVideoPlayerPause(){
        VideoPlayer.callVideoPlayer.webView.pauseVideo()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super .viewDidDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    
    
    
    func musicRecordDeletedDelegate(_ alertTitleName: String) {
        if alertTitleName == "My Library" {
            myLibraryListArray = []
            self.myLibraryTableView.reloadData()
        }
    }
    
    
    func setupSearchNavBar() {
        SearchController.sharedSearchControllerInstace.searchController(searchController, superViewController: self, navigationItem: self.navigationItem, searchPlaceholder: SearchPlaceholder.librarySearch)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        print("kk")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchLibrary = myLibraryListArray.filter({$0.videoTitle!.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        myLibraryTableView.reloadData()
        
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
        searching = false
        searchBar.text = ""
        myLibraryTableView.reloadData()
    }
    
}

extension MyLibraryViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let titleName =  "My Library"
        return titleName
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchLibrary.count
        }else{
            return myLibraryListArray.count
            
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  libraryMusicCell = (tableView.dequeueReusableCell(withIdentifier: myLibraryTableViewCellIdentifier, for: indexPath) as? MainLibrariMusciTableViewCell)!
        
        if searching {
            libraryMusicCell.configureMyLibraryCell(searchLibrary[indexPath.row])
        }else{
            libraryMusicCell.configureMyLibraryCell(myLibraryListArray[indexPath.row])
        }
        
        return libraryMusicCell
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        view.tintColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Verdana-Bold", size: 18)!
        header.textLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        let myLibraryCount: Bool = myLibraryListArray.count >= 3 ? true : false
        if  myLibraryCount == true{
            viewAllButton.frame = CGRect(x: UIScreen.main.bounds.width - 100, y: 10, width: 100, height: 40)
            viewAllButton.tag = section
            viewAllButton.setTitle("View all", for: .normal)
            viewAllButton.titleLabel?.font =  UIFont(name: "Verdana-Bold", size: 9)
            viewAllButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            header.addSubview(viewAllButton)
            sectionButton = viewAllButton
            viewAllButton.addTarget(self, action: #selector(destinationMyLibraryVC), for: .touchUpInside)
        }
    }
    
    @objc func destinationMyLibraryVC(){
        self.performSegue(withIdentifier: destinationToMyLibraryIdentifier, sender: SelectedTableView.libraryTableView.rawValue)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if  let selectedViewController = segue.destination as? SelectedSectionViewController {
            switch sender as? String {
            case SelectedTableView.libraryTableView.rawValue:
                selectedViewController.navigationItem.title = "My Library"
                selectedViewController.checkTableViewName = sender as! String
                selectedViewController.musicRecordDeletedDelegate = self
            case SelectedTableView.genreCollectionView.rawValue:
                selectedViewController.navigationItem.title = selectedGenreRowTitleHolder
                selectedViewController.checkTableViewName = sender as! String
                selectedViewController.selectedGenreTitle  = selectedGenreRowTitleHolder
            default:
                break
            }
            
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let selectedCell = self.myLibraryTableView.cellForRow(at: indexPath) as! MainLibrariMusciTableViewCell
        
        getSelectedLibraryVideo(indexPath)
        
        VideoPlayer.callVideoPlayer.videoPalyerClass(genreVideoID: selectedCell.videoID, videoImageName: selectedCell.imageViewUrl, superView: self, selectedVideoTitle: selectedCell.musicTitleLabel.text!)
        
        CoreDataVideoClass.coreDataVideoInstance.saveVideoWithEntityName(videoTitle: selectedCell.musicTitleLabel.text!, videoImage: selectedCell.imageViewUrl, videoId: selectedCell.videoID, playlistName: "", coreDataEntityName: recentPlayedEntityName)
        
        
    }
    
    
    
    func getSelectedLibraryVideo(_ indexPath: IndexPath){
        VideoPlayer.callVideoPlayer.cardViewController.view = nil
        selectTopHitsRow = true
        VideoPlayer.callVideoPlayer.webView.pauseVideo()
        videoSelected = true
        VideoPlayer.callVideoPlayer.superViewController = self
        
        DispatchQueue.main.async {
            self.myLibraryTableView.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == MainLibrariMusciTableViewCell.EditingStyle.delete{
            removeSelectedVideoRow(atIndexPath: indexPath)
            myLibraryListArray.remove(at: indexPath.row)
            checkIfNoTracksFound()
            let libraryCount: Bool = (self.myLibraryListArray.count) <= 4 ? true : false
            sectionButton.isHidden = libraryCount
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
    }
    
    func removeSelectedVideoRow(atIndexPath indexPath: IndexPath) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: myLibraryEntityName)
        let result = try? context?.fetch(request)
        let resultData = result as! [NSManagedObject]
        context?.delete(resultData[indexPath.row])
        do{
            try context?.save()
        }catch {
            print("Could not remove video from Database \(error.localizedDescription)")
        }
    }
}


extension MyLibraryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  GenreModelService.instance.getGenreArray().count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: genreCellIdentifier, for: indexPath) as? GenresCollectionViewCell {
            cell.confiigurationGenreCell(GenreModelService.instance.getGenreArray()[indexPath.row])
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.layer.borderWidth = 0.5
            cell.layer.cornerRadius = 6
            cell.layer.backgroundColor = UIColor.white.cgColor
            
            return cell
        }else {
            return GenresCollectionViewCell()
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedGenreRowTitle = GenreModelService.instance.getGenreArray()[indexPath.row]
        selectedGenreIndexRow = indexPath.row
        selectedGenreRowTitleHolder = selectedGenreRowTitle.genreTitle!
        self.performSegue(withIdentifier: destinationToMyLibraryIdentifier, sender: SelectedTableView.genreCollectionView.rawValue)
    }
}
