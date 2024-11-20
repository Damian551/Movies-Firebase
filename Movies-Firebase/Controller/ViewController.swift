//
//  ViewController.swift
//  Movies-Firebase
//
//  Created by Bolaji Abdul on 2024-11-19.
//

import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func SignInGoogleButtonPressed(_ sender: UIButton) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
            if let error {
                print(error)
                return
            }

            guard let user = result?.user, let idToken = user.idToken?.tokenString
            else { return }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { _, _ in
                self.performSegue(withIdentifier: "GoToMovies", sender: self)
            }
        }
    }
}
