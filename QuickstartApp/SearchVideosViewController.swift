//
//  SearchVideosViewController.swift
//  QuickstartApp
//
//  Created by Luqmaan Siddiqui on 7/7/18.
//  Copyright © 2018 Luqmaan Siddiqui. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

struct VideoSearchObjects{
    var videoTitle = String()
    var videoID = String()
    var videoDescription = String()
    var thumbNailURL = String()
}

var currentYPosition = CGFloat()

class SearchVideosViewController: UIViewController,UISearchBarDelegate, UICollectionViewDelegate,UICollectionViewDataSource {
    var transitionCount = 0
    var cellHeight = CGFloat()
     let imageView = UIImageView()
  //  var selectedImage:VideoDetailsCollectionViewCell
    
    let transition = PopAnimator()
    
    @IBOutlet weak var collectionViewVideos: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoSearchObjectsFinal.count
    }
    
   
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! VideoDetailsCollectionViewCell
        cell.videoTitleLabelOutlet.text = videoSearchObjectsFinal[indexPath.row].videoTitle
        let url = URL(string: videoSearchObjectsFinal[indexPath.row].thumbNailURL)
        // this downloads the image asynchronously if it's not cached yet
        cell.thumbNailImage.kf.setImage(with: url)
        print(videoSearchObjectsFinal[indexPath.row].videoID)
       
       
        return cell
    }
    

    
    
    
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    
   let reuseIdentifier = "cell"
    
    //array of VideoSearchObjects
    var videoSearchObjectsFinal = [VideoSearchObjects]()
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        var inputString = searchBarOutlet.text
        if (inputString?.isEmpty)!{
            return
        }
        
        if !(inputString?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            let parsedString = inputString?.replacingOccurrences(of: " ", with: "+")
            YouTubeVideoSearch(searchBarText: parsedString!)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarOutlet.delegate = self

        collectionViewVideos.delegate = self
        collectionViewVideos.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if transitionCount != 0{
            UIView.animate(withDuration: 0.5, animations: {
                self.imageView.center.y = currentYPosition-(self.cellHeight/2)
                
                //print(self.imageView.center.y)
            }, completion:{ finished in
               // self.arr2 = arr
                self.collectionViewVideos.isHidden = false
                self.searchBarOutlet.isHidden = false
                self.collectionViewVideos.reloadData()
                self.imageView.isHidden = true
                return
            })
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print(indexPath.row)
      
        let dest = PlayViewController()
        dest.vidId = videoSearchObjectsFinal[indexPath.row].videoID
        let rect = self.collectionViewVideos.layoutAttributesForItem(at: indexPath)?.frame
        performAnimation(imageurlS: videoSearchObjectsFinal[indexPath.row].videoID, frameOfCell: rect!,ind: indexPath.row)
        dest.transitioningDelegate = self
       
        
       // present(dest, animated: false, completion: nil)
       // performSegue(withIdentifier: "play", sender: self)
    }
    
    
    func performAnimation(imageurlS:String,frameOfCell:CGRect,ind:Int){
        
        imageView.isHidden = false
        imageView.frame = frameOfCell
        print(frameOfCell)
        let url = URL(string: videoSearchObjectsFinal[ind].thumbNailURL)
        imageView.kf.setImage(with: url)
        view.addSubview(imageView)
       // index1 = ind
        view.backgroundColor = UIColor.white
        //arr2 = []
        collectionViewVideos.reloadData()
        //collectionView?.reloadData()
         collectionViewVideos?.isHidden = true
        searchBarOutlet.isHidden = true
        currentYPosition = frameOfCell.maxY
        cellHeight = frameOfCell.height
        //  while (imageView.center.y <= 30){
        UIView.animate(withDuration: 0.25, animations: {
            self.imageView.center.y = UIApplication.shared.keyWindow!.safeAreaInsets.top+(self.cellHeight/2)
            
            //print(self.imageView.center.y)
        }, completion:{ finished in
            let dest = PlayViewController()
            
            dest.vidId = imageurlS
            dest.x = frameOfCell.minX
            dest.y = UIApplication.shared.keyWindow!.safeAreaInsets.top+(self.cellHeight/2)
            dest.height = frameOfCell.height
            dest.width = frameOfCell.width
            self.present(dest, animated: false, completion: nil)
        })
        //  }
        transitionCount += 1
        print("here")
    }
    
    
    
    func YouTubeVideoSearch(searchBarText:String){
         let API_KEY = "AIzaSyDosuwcTJpA40TcIlDnZXMt9AL7MN7SPnQ"
        
        
        let type = "video"
        //htttps url request
        
        let urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(searchBarText)&type=\(type)&key=\(API_KEY)"
        
        let part = "snippet"
        //Network call parameters
        let parameters = ["key":API_KEY, "part":part, "q":searchBarText]
        
        Alamofire.request(urlString, method: .get, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                print("Succesfully Retrieved Data")
            }
            else {
                print("Unsuccessful: \(String(describing: response.error))")
            }
            
            guard let response = response.result.value else {
                return
            }
            let jsonObject: JSON = JSON(response)
            print("JSON: \(jsonObject)")
            
             var videoSearchObjectsArray = [VideoSearchObjects]()
    
    
            for i in 0..<jsonObject["items"].count {
                var videoObjects = VideoSearchObjects()
                //Retrieving videoData from jsonObject
                videoObjects.videoTitle = jsonObject["items"][i]["snippet"]["title"].stringValue
                
                videoObjects.videoID = jsonObject["items"][i]["id"]["videoId"].stringValue
                
                videoObjects.videoDescription = jsonObject["items"][i]["snippet"]["description"].stringValue
                
                videoObjects.thumbNailURL = jsonObject["items"][i]["snippet"]["thumbnails"]["default"]["url"].stringValue
                
                videoSearchObjectsArray.append(videoObjects)
            }
    
            self.videoSearchObjectsFinal = videoSearchObjectsArray
            print(self.videoSearchObjectsFinal.count)
            print(self.videoSearchObjectsFinal[1].videoTitle)
    
            self.collectionViewVideos.reloadData()
    }
    }
}


extension  SearchVideosViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.originFrame = CGRect(x: 0, y: view.frame.height/2, width: view.frame.width , height: 300)
        transition.presenting = true
        
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}
