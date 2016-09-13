import UIKit
import CoreData

class AccountViewController: UIViewController, UITextFieldDelegate, NSFetchedResultsControllerDelegate {

    /** Atributos **/
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var accountTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var initialAmountTextField: UITextField!
    
    /** Variáveis **/
    var account:Account!
    var accounts:[Account] = []
    var fetchResultController:NSFetchedResultsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Adicionar Conta"
        
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
                
            } catch {
                print(error)
            }
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func save(sender: AnyObject) {
        
        NSLog("Clicou em salvar")
        NSLog("Descrição \(accountTextField.text!) Tipo \(accountTypeSegmentedControl.selectedSegmentIndex) Inicial \(initialAmountTextField.text!)")
        
        /** Validar campos **/
        if (accountTextField.text == "") {
            let alertController = UIAlertController(title: "Atenção", message: "Favor preencha a descrição da conta", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        
        for accountSaved in accounts where accountSaved.descr == accountTextField.text {
            let alertController = UIAlertController(title: "Atenção", message: "Conta já cadastrada.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        
        saveAccount(accountTextField.text!, type: Int(accountTypeSegmentedControl.selectedSegmentIndex), amount: (initialAmountTextField.text! != "" ? initialAmountTextField.text! : "0,00"))
        
        dismissViewControllerAnimated(true, completion: nil)
    }

    func saveAccount(descr: String, type: Int, amount: String) {
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            account = NSEntityDescription.insertNewObjectForEntityForName("Account", inManagedObjectContext: managedObjectContext) as! Account
            account.descr = descr
            account.type = type
            account.actualAmount = convertLocalizedStringToDouble(amount, thousandSeparator: true)
            account.initialAmount = convertLocalizedStringToDouble(amount, thousandSeparator: true)

            NSLog("Account \(account)")
            
            do {
                try managedObjectContext.save()
            } catch {
                NSLog("\(error)")
                return
            }
        }
    }
    
    func convertLocalizedStringToDouble (decimalAsString: String, thousandSeparator: Bool) -> Double {
        
        let formatter = NSNumberFormatter()
        
        formatter.usesGroupingSeparator = thousandSeparator
        formatter.locale = NSLocale.currentLocale()
        
        var decimalAsDouble = formatter.numberFromString(decimalAsString)?.doubleValue
        
        // The below should never happen! Only happens, if string equals "1,00034.00", so wrong placement of thousand separator
        if decimalAsDouble == nil { decimalAsDouble = 0} // returning an "Err-Code of 0"
        
        if let decimalAsDoubleUnwrapped = formatter.numberFromString(decimalAsString) {
            decimalAsDouble = decimalAsDoubleUnwrapped.doubleValue
        }
        
        return decimalAsDouble!
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == accountTextField {
            initialAmountTextField.becomeFirstResponder()
        } else {
            initialAmountTextField.resignFirstResponder()
        }
        
        return true
    }

}