//
//  MoviesViewController.swift
//  Flix-Part1
//
//  Created by Athena Enosara on 2/3/20.
//  Copyright © 2020 codepath. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var movies = [[String:Any]]() //creation of an array of dictionaries of type String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
//        print("Hello.") // deleted on walkthrough video
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                self.movies = dataDictionary["results"] as! [[String: Any]]
                
                self.tableView.reloadData()
                
//                print(dataDictionary) // deleted on walkthrough video
                
                // TODO: Get the array of movies
                
                // TODO: Store the movies in a property to use elsewhere
                
                // TODO: Reload your table view data
                
                
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
        
//        cell.textLabel!.text = title // don't need this one anymore // deleted on walkthrough video
        cell.titleLabel.text = title //need this one instead of the above
        cell.synopsisLabel.text = synopsis
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string : baseUrl + posterPath)
        
        cell.posterView.downloaded(from: posterUrl!)//using a school computer, so I couldn't download CocoaPods or AlamofireImage. My TA helped me go around it by creating the UIImageViewExtension.swift file and the code within it so that I can download the images using this line
        
        return cell
    }
    
    // NAVIGATION
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){ //sender is the cell that was tapped on
        // Get the new view controller using segue.destination
        
        
        //Pass the selected object to the new view controller
        
        print("Loading up the details screen here.")
        
        //Find the selected movie
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let movie = movies[indexPath.row]
        
        // Pass the selected movie to the details view controller
        let detailsViewController = segue.destination as! MovieDetailsViewController
        detailsViewController.movie = movie
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
