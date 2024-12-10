import Foundation
import UIKit
import FirebaseAuth
import Firebase

class AuthService {
    func signIn(user: UserData, completion: @escaping (Result<Bool, Error>) -> Void){
        Auth.auth().signIn(withEmail: user.email, password: user.password) { result, err in
            guard err == nil else {
                print(err!)
                completion(.failure(err!))
                return
            }
            guard let user = result?.user else {
                completion(.failure(SignError.invalidUser))
                return
            }
            if !user.isEmailVerified {
                completion(.failure(SignError.notVerified))
                return
            }
            completion(.success(true))
        }
    }
    
    func resetPassword(email: String, completion: @escaping (Result<Bool, Error>) -> Void) {
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let error = error {
                    print(error)
                    completion(.failure(error))
                } else {
                    completion(.success(true))
                }
            }
        }
    
    func createNewUser(user: UserData, completion: @escaping (Result<Bool, Error>) -> Void){
        Auth.auth().createUser(withEmail: user.email, password: user.password) { result, err in
            guard err == nil else {
                print(err!)
                completion(.failure(err!))
                return
            }
            result?.user.sendEmailVerification()
            completion(.success(true))
        }
    }
    
    func signOut() {
        do{
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }
    
}

enum SignError: Error {
    case invalidUser
    case notVerified
}
