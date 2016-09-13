import UIKit
import CoreData

class TransactionViewController: UIViewController, LBZSpinnerDelegate, NSFetchedResultsControllerDelegate  {
    
    /** Atributos **/
    @IBOutlet var transactionAccount:LBZSpinner!
    @IBOutlet weak var transactionType: UISegmentedControl!
    @IBOutlet weak var transactionDescription: UITextField!
    @IBOutlet weak var transactionAmount: UITextField!
    @IBOutlet weak var transactionCategory: UITextField!
    @IBOutlet weak var transactionDate: UIDatePicker!
    
    var accounts = []
    var accountsDescriptions: [String] = []
    var managedContext: NSManagedObjectContext!
    var transaction:Transaction!
    var transactionTypeSelected: Int!
    var fetchResultController:NSFetchedResultsController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /** Load Accounts **/
        loadAccounts()
        
        /** Spinner **/
        transactionAccount.updateList(accountsDescriptions)
        transactionAccount.delegate = self
        
        /** Persistencia **/
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            managedContext = appDelegate.managedObjectContext
        }
    }
    
    func spinnerChoose(spinner:LBZSpinner, index:Int, value:String) {
        NSLog("\(value)")
    }
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func save(sender: AnyObject) {
        if (transactionDescription.text == "" || transactionAmount.text == "" || transactionCategory.text == "") {
            let alertController = UIAlertController(title: "Atenção", message: "Favor preencher todos os campos.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        
        
//        saveTransaction()
    }
    
    func saveTransaction(accont: String, descr: String, amount: Double, category: String, date: NSDate) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loadAccounts() {
        /** Parametros Carregar contas **/
        let fetchRequest = NSFetchRequest(entityName: "Account")
        let sortDescriptor = NSSortDescriptor(key: "descr", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        /** Carregar contas **/
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                accounts = fetchResultController.fetchedObjects as! [Account]
                
                for account in accounts {
                    accountsDescriptions.append(String(account.valueForKey("descr")!))
                }
                
            } catch let error as NSError {
                NSLog("Could not fetch \(error), \(error.userInfo)")
            }
        }
    }
    
    func convertLocalizedStringToDouble (decimalAsString: String, thousandSeparator: Bool) -> Double {
        
        let formatter = NSNumberFormatter()
        
        formatter.usesGroupingSeparator = thousandSeparator
        formatter.locale = NSLocale.currentLocale()
        
        var decimalAsDouble = formatter.numberFromString(decimalAsString)?.doubleValue
        
        // The below should never happen! Only happens, if string equals "1,00034.00", so wrong placement of thousand separator
        if decimalAsDouble == nil { decimalAsDouble = 0 } // returning an "Err-Code of 0"
        
        if let decimalAsDoubleUnwrapped = formatter.numberFromString(decimalAsString) {
            decimalAsDouble = decimalAsDoubleUnwrapped.doubleValue
        }
        return decimalAsDouble!
    }

}