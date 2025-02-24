import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        for i in 0..<10 {
            let newPokemon = PokemonEntity(context: viewContext)
            newPokemon.id = Int64(i + 1)
            newPokemon.name = "Pokemon \(i + 1)"
            newPokemon.image = URL(string : "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(i + 1).png")
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "PokemonDataModel")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            print("Loading persistent stores...")
            if let error = error as NSError? {
                print("❌ Failed to load persistent stores: \(error), \(error.userInfo)")
                // Au lieu de fatalError, loggez l'erreur pour le débogage
                print("Store description: \(storeDescription)")
            } else {
                print("✅ Successfully loaded persistent stores")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}

extension TypeEntity {
    static func createOrFetch(name: String, in context: NSManagedObjectContext) -> TypeEntity? {
        let fetchRequest: NSFetchRequest<TypeEntity> = TypeEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        fetchRequest.fetchLimit = 1

        // Vérifie si le type existe déjà dans Core Data
        if let existingType = try? context.fetch(fetchRequest).first {
            return existingType
        }

        // Si le type n'existe pas, on en crée un nouveau
        let newType = TypeEntity(context: context)
        newType.name = name
        return newType
    }
}
