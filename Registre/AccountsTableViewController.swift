import UIKit
import CoreData

class AccountsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var managedContext: NSManagedObjectContext!
    var fetchResultController:NSFetchedResultsController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Registre"
        
        /** Parametros Carregar contas **/
        let fetchRequest = NSFetchRequest(entityName: "Account")
        let sortDescriptor = NSSortDescriptor(key: "type", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        /** Carregar contas **/
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: "type", cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
            } catch let error as NSError {
                NSLog("Could not fetch \(error), \(error.userInfo)")
            }
        }

    }
    
    func typeToString(type: Int) -> String {
        switch type {
        case 0:
            return "Dinheiro"
        case 1:
            return "Bancária"
        default:
            return "Investimentos"
        }
    }

    func typeToIcon(type: Int) -> String {
        switch type {
        case 0:
            return "cash_icon"
        case 1:
            return "credit_icon"
        default:
            return "investiment_icon"
        }
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchResultController.sections!.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultController.sections![section].numberOfObjects
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! AccountsTableViewCell
        
        let account = fetchResultController.objectAtIndexPath(indexPath) as! Account
        
        cell.thumbnailImageView.image = UIImage(named: typeToIcon(Int(account.type!)))
        cell.descriptionLabel.text = account.descr
        cell.amountLabel.text = "R$ " + (account.actualAmount != 0 ? String(account.actualAmount) : "0,00")
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return typeToString(Int(fetchResultController.sections![section].name)!)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            // tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)            
        }/** else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }   **/
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editAccount" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destinationViewController as! AccountViewController
                destinationController.accountTextField.text = "Cú"
                destinationController.accountTypeSegmentedControl.selectedSegmentIndex = 2
                destinationController.initialAmountTextField.text = "0,00"
            }
        }
    }

}