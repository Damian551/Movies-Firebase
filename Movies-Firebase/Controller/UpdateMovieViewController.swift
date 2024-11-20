//
//  UpdateMovieViewController.swift
//  Movies-Firebase
//
//  Created by Gurpreet Kaur on 2024-11-19.
//

import FirebaseFirestore
import UIKit

class UpdateMovieViewController: UIViewController {
    // MARK: - Outlets

    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var studioTextField: UITextField!
    @IBOutlet var thumbnailTextField: UITextField!
    @IBOutlet var ratingTextField: UITextField!

    // movie to be updated
    var movie: Movie?

    // Firestore ref
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        populateFields()
    }

    func populateFields() {
        if let movie = movie {
            titleTextField.text = movie.title
            studioTextField.text = movie.studio
            thumbnailTextField.text = movie.thumbnail
            ratingTextField.text = String(movie.rating)
        }
    }

    @IBAction func updateButtonPressed(_ sender: UIButton) {
        // validate input
        guard let title = titleTextField.text, !title.isEmpty,
              let studio = studioTextField.text, !studio.isEmpty,
              let thumbnail = thumbnailTextField.text, !thumbnail.isEmpty,
              let ratingText = ratingTextField.text, !ratingText.isEmpty,
              let rating = Double(ratingText),
              let movie = movie else {
            print("Missing fields")
            return
        }

        // Create updated data dict
        let updatedData: [String: Any] = [
            "title": title,
            "thumbnail": thumbnail,
            "studio": studio,
            "rating": rating,
        ]

        // Update document in Firestore
        db.collection("movies").document(movie.id).updateData(updatedData) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document updated with ID: \(movie.id)")
                // Navigate back
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
