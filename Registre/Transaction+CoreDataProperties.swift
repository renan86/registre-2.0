import Foundation
import CoreData

extension Transaction {

    @NSManaged var amount: NSNumber?
    @NSManaged var category: String?
    @NSManaged var date: NSDate?
    @NSManaged var descr: String?
    @NSManaged var account: Account?

}