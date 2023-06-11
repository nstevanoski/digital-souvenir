import UIKit
import CoreData

class DatabaseManager {

    private var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    func addUser(_ user: User) {
        let userEntity = UserEntity(context: context)
        addUpdateUser(userEntity: userEntity, user: user)
    }

    func updateUser(user: User, userEntity: UserEntity) {
        addUpdateUser(userEntity: userEntity, user: user)
    }

    private func addUpdateUser(userEntity: UserEntity, user: User) {
        userEntity.userEmail = user.userEmail
        userEntity.username = user.username
        userEntity.signUpDate = user.signUpDate
        saveContext()
    }

    func fetchUsers() -> [UserEntity] {
        var users: [UserEntity] = []

        do {
            users = try context.fetch(UserEntity.fetchRequest())
        }catch {
            print("Fetch user error", error)
        }

        return users
    }

    func saveContext() {
        do {
            try context.save() // MIMP
        }catch {
            print("User saving error:", error)
        }
    }
}
