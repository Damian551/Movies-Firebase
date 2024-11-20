//
//  AddMovieViewController.swift
//  Movies-Firebase
//
//  Created by Gurpreet Kaur on 2024-11-19.
//

import FirebaseAuth
import FirebaseFirestore
import UIKit

class AddMovieViewController: UIViewController {
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var studioTextField: UITextField!
    @IBOutlet var thumbnailTextField: UITextField!
    @IBOutlet var ratingTextField: UITextField!

    let db = Firestore.firestore()
    let auth = Auth.auth()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func saveButtonPressed(_ sender: UIButton) {
        // get current user id
        let userId = auth.currentUser?.uid

        guard let title = titleTextField.text, !title.isEmpty,
              let studio = studioTextField.text, !studio.isEmpty,
              let thumbnail = thumbnailTextField.text, !thumbnail.isEmpty,
              let ratingText = ratingTextField.text, !ratingText.isEmpty,
              let rating = Double(ratingText)
        else {
            print("Missing fields")
            return
        }

        db.collection("movies").addDocument(data: [
            "title": title,
            "thumbnail": thumbnail,
            "studio": studio,
            "rating": rating,
            "userId": userId!,
        ]) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added with ID: \(title)")

                // Navigate back
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
