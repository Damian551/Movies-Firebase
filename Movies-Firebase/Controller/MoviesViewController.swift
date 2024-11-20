//
//  MoviesViewController.swift
//  Movies-Firebase
//
//  Created by Gurpreet Kaur on 2024-11-19.
//

import FirebaseFirestore
import Kingfisher
import UIKit

class MoviesViewController: UIViewController {
    @IBOutlet var tableView: UITableView!

    let db = Firestore.firestore()
    var movies: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self

        // Hide the back button
        navigationItem.hidesBackButton = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMovies()
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */

    func fetchMovies() {
        db.collection("movies").getDocuments { quertSnapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                self.movies = []
                for document in quertSnapshot!.documents {
                    let data = document.data()
                    let title = data["title"] as? String ?? ""
                    let thumbnail = data["thumbnail"] as? String ?? ""
                    let studio = data["studio"] as? String ?? ""
                    let rating = data["rating"] as? Double ?? 0.0
                    let userId = data["userId"] as? String ?? ""
                    let movie = Movie(title: title, thumbnail: thumbnail, studio: studio, rating: rating, userId: userId)
                    self.movies.append(movie)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}

extension MoviesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieCell else {
            return UITableViewCell()
        }
        let movie = movies[indexPath.row]
        cell.titleLabel.text = movie.title
        cell.ratingLabel.text = String(movie.rating)
        cell.studioLabel.text = movie.studio

        // image
        if let url = URL(string: movie.thumbnail) {
            let placeholderImage = UIImage(systemName: "film") // default image
            cell.thumbnailImageView.kf.setImage(with: url,
                                                placeholder: placeholderImage,
                                                options: [.transition(.fade(0.2)), .cacheOriginalImage])
        } else {
            cell.thumbnailImageView.image = UIImage(systemName: "film") // default image
        }

        return cell
    }
}
