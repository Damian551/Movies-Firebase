//
//  MoviesViewController.swift
//  Movies-Firebase
//
//  Created by Gurpreet Kaur on 2024-11-19.
//

import FirebaseAuth
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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMovies()
    }

    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }

    func fetchMovies() {
        db.collection("movies").getDocuments { quertSnapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                self.movies = []
                for document in quertSnapshot!.documents {
                    let data = document.data()
                    let id = document.documentID
                    let title = data["title"] as? String ?? ""
                    let thumbnail = data["thumbnail"] as? String ?? ""
                    let studio = data["studio"] as? String ?? ""
                    let rating = data["rating"] as? Double ?? 0.0
                    let userId = data["userId"] as? String ?? ""
                    let movie = Movie(id: id, title: title, thumbnail: thumbnail, studio: studio, rating: rating, userId: userId)
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = movies[indexPath.row]
        performSegue(withIdentifier: "GoToUpdateMovie", sender: selectedMovie)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToUpdateMovie" {
            if let updateVC = segue.destination as? UpdateMovieViewController,
               let selectedMovie = sender as? Movie {
                updateVC.movie = selectedMovie
            }
        }
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
