import Foundation
import CoreData

enum ItemHandleType {
    case insert, delete
}

final class CategoryDataProvider: NSObject, CategoryDataProviderProtocol {
    
    private let context: NSManagedObjectContext
    
    private let categoryRepository: TrackerCategoryRepository
    
    private let trackersPackRepository: TrackersPackRepository
    
    private var selectedIndexPath: IndexPath?
    
    private var itemHandleType: ItemHandleType = .insert
    
    private var delegate: CategoryDataProviderDelegate?
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id_", ascending: false)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    
    init(
        context: NSManagedObjectContext,
        categoryRepository: TrackerCategoryRepository,
        trackersPackRepository: TrackersPackRepository
    ) {
        self.context = context
        self.categoryRepository = categoryRepository
        self.trackersPackRepository = trackersPackRepository
    }
    
    func setDelegate(_ delegate: CategoryDataProviderDelegate) {
        self.delegate = delegate
    }
    
    func numberOfItems() -> Int {
        let numberOfItems = fetchedResultsController.sections?[0].numberOfObjects ?? 0
        return numberOfItems
    }
    
    func object(at indexPath: IndexPath) -> TrackerCategory? {
        let categoryCoreData = fetchedResultsController.object(at: indexPath)
        let trackerCategory = CoreDataMarshalling.map(categoryCoreData)
        return trackerCategory
    }
    
    func addCategory(title: String) -> TrackerCategory {
         return categoryRepository.createCategory(title: title)
    }
    
    func removeCategory(at indexPath: IndexPath) -> Bool {
        let categoryCoreData = fetchedResultsController.object(at: indexPath)
        guard let categoryID = categoryCoreData.id_ else { return false }
        
        if let pack = trackersPackRepository.getPackByCategoryID(categoryID) {
            if !pack.trackerIDList.isEmpty { return false }
        }
        categoryRepository.removeCategory(id: categoryID)
        trackersPackRepository.removePack(for: categoryID)
        return true
    }
}
//MARK: - NSFetchedResultsControllerDelegate
extension CategoryDataProvider: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let selectedIndexPath else { return }
        
        var indexPathForReconfigure: IndexPath?
        var reconfiguredCellType: SettingsMenuCellType = .regular

        let itemsCount = numberOfItems()

        switch itemHandleType {
        case .insert:
            if selectedIndexPath.item == 0 {
                indexPathForReconfigure = IndexPath(item: 1, section: selectedIndexPath.section)
                if itemsCount == 2 { reconfiguredCellType = .last }
            }
            if selectedIndexPath.item == itemsCount - 1 {
                indexPathForReconfigure = IndexPath(item: itemsCount - 2, section: selectedIndexPath.section)
                if itemsCount == 2 { reconfiguredCellType = .first }
            }
            if itemsCount == 1 {
                indexPathForReconfigure = nil
            }
        
        case .delete:
            if selectedIndexPath.item == 0 {
                indexPathForReconfigure = selectedIndexPath
                reconfiguredCellType = .first
            }
            if selectedIndexPath.item == itemsCount {
                indexPathForReconfigure = IndexPath(item: itemsCount - 1, section: selectedIndexPath.section)
                reconfiguredCellType = .last
            }
            if itemsCount == 1 {
                reconfiguredCellType = .single
            }
            if itemsCount == 0 {
                indexPathForReconfigure = nil
            }
        }
        
        delegate?.update(
            handleType: itemHandleType,
            indexPath: selectedIndexPath,
            indexPathForReconfigure: indexPathForReconfigure,
            reconfiguredCellType: reconfiguredCellType
        )
        self.selectedIndexPath = nil
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?
    ) {
        switch type {
        case .delete:
            itemHandleType = .delete
            if let indexPath { selectedIndexPath = indexPath }
        case .insert:
            itemHandleType = .insert
            if let newIndexPath { selectedIndexPath = newIndexPath }
        default:
            break
        }
    }
}
