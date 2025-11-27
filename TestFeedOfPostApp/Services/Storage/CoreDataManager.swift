//
//  CoreDataManager.swift
//  TestFeedOfPostApp
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}

    private let modelName = "PostsModel"

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func savePosts(_ posts: [Post]) {
        let context = persistentContainer.viewContext

            // Используем performAndWait для синхронного выполнения
        context.performAndWait {
            for post in posts {
                let fetchRequest: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %d", post.id)

                do {
                    let existingPosts = try context.fetch(fetchRequest)
                    let postEntity: PostEntity

                    if let existingPost = existingPosts.first {
                        postEntity = existingPost
                    } else {
                        postEntity = PostEntity(context: context)
                    }

                    let avatarURL = "https://i.pravatar.cc/150?img=\(post.userId)"

                    postEntity.userId = Int32(post.userId)
                    postEntity.id = Int32(post.id)
                    postEntity.title = post.title ?? ""
                    postEntity.body = post.body ?? ""
                    postEntity.avatarURL = avatarURL

                } catch {
                    print("Failed to fetch or create PostEntity: \(error)")
                    continue
                }
            }

            self.saveContext()
        }
    }

    func fetchPosts() -> [PostEntity] {
        let context = persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<PostEntity>(entityName: "PostEntity")
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch posts: \(error)")
            return []
        }
    }

    func deleteAllPosts() {
        let context = persistentContainer.viewContext

            // Используем performAndWait для синхронного выполнения
        context.performAndWait {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = PostEntity.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

            do {
                try context.execute(deleteRequest)
                saveContext()
            } catch {
                print("Failed to delete posts: \(error)")
            }
        }
    }
}
