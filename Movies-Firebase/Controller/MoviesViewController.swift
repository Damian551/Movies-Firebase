//
//  MoviesViewController.swift
//  Movies-Firebase
//
//  Created by Gurpreet Kaur on 2024-11-19.
//

import Kingfisher
import UIKit

class MoviesViewController: UIViewController {
    @IBOutlet var tableView: UITableView!

    var movies: [Movie] = [
        Movie(title: "Inception", thumbnail: "https://m.media-amazon.com/images/M/MV5BMjAxMzY3NjcxNF5BMl5BanBnXkFtZTcwNTI5OTM0Mw@@._V1_.jpg", studio: "Warner Bros", rating: 9.0, userId: "2ubvKSLumpaEkpodh30JUMdjKZM2"),
        Movie(title: "Matrix", thumbnail: "https://www.rogerebert.com/wp-content/uploads/2024/03/The-Matrix.jpg", studio: "Matrix Studios", rating: 9.9, userId: "2ubvKSLumpaEkpodh30JUMdjKZM2"),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self

        // Hide the back button
        navigationItem.hidesBackButton = true
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
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
