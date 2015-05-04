//
//  TableView.swift
//  GitApp
//
//  Created by Fernando on 4/28/15.
//  Copyright (c) 2015 Fernando. All rights reserved.
//

import UIKit
import CoreData

class TableView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let managedObjectContext =
    (UIApplication.sharedApplication().delegate
        as! AppDelegate).managedObjectContext
    var newReposFromJSON = NSMutableArray()
    
    @IBOutlet weak var table: UITableView!
    
    var reposit = NSMutableArray()
    var reposit2 = NSArray()
    var reposit3 = NSArray()
    
    
    var interReposit = NSArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        var nome:NSString = defaults.stringForKey("nome")! as NSString!
        table.delegate = self
        table.dataSource = self
        
        
        
        
        
        if(hasConnectivity()){
            
            println("acceso a internet")
            
            addUser(nome as String)
            reposit3 = Manager.sharedInstance.getAllUserRepos(nome)
            reposit2 = Manager.sharedInstance.getAllUserRepos("mackmobile")
            
            for repo1 in reposit3{
                for repo2 in reposit2{
                    if((repo1 as! NSString) as NSString == (repo2 as! NSString) as NSString){
                        
                        reposit.addObject(repo1)
                    }
                }
            }
            
            var reposFromBD = getReposBD(nome as String)
            
            for a in reposFromBD {
                if let repo: AnyObject = a.valueForKey("repoName"){
                    println(repo)
                }
            }
            
            for reposJson in reposit{
                var existInBd = Bool()
                existInBd = false
                
                for reposBD in reposFromBD{
                    if let repo: AnyObject = reposBD.valueForKey("repoName"){
                        
                        if((repo as! NSString) as NSString == (reposJson as! NSString) as NSString){
                            existInBd = true
                        }
                    }
                }
                
                if(existInBd == false){
                    println("O repos \(reposJson) não existia no banco")
                    newReposFromJSON.addObject(reposJson)
                    
                    
                }
            }
            
            addRepoBD(nome as String, repos: newReposFromJSON)
            
            
        }else{
            
            println("sem acesso a internet ")
            var reposBD = getReposBD(nome as String)
            
            for repo in reposBD{
                
                if let repoName: AnyObject = repo.valueForKey("repoName"){
                    println("\(repoName) nome do repo")
                    
                    reposit.addObject(repoName)
                }
            }
            
        }
        
    }
    
    func getReposBD(username: String) -> NSSet {
        
        var arrayOfRepos = NSMutableArray()
        var error: NSError? = nil
        
        var fReq = NSFetchRequest(entityName: "User")
        
        
        fReq.predicate = NSPredicate(format:"username ==%@", username)
        
        var results = managedObjectContext!.executeFetchRequest(fReq, error:&error)
        
        
        if let result: AnyObject = results{
            
            var UserResult = result[0] as! User
            
            
            if let user: AnyObject = result.valueForKey("username") {
                
                println(user)
                return UserResult.repos
                
                
            }
            
            
        }
        
        return NSSet()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func addRepoBD(username: String, repos: NSMutableArray) {
        
        var error: NSError? = nil
        
        var fReq = NSFetchRequest(entityName: "User")
        
        
        fReq.predicate = NSPredicate(format:"username ==%@", username)
        
        var result = managedObjectContext!.executeFetchRequest(fReq, error:&error)
        
        
        
        if(result?.count > 0){
            
            for resultItem in result! {
                var UserResult = resultItem as! User
                
                if(username == UserResult.username){
                    
                    var newii000 = repos
                    
                    for ni in repos{
                        var newRepo: Repo = NSEntityDescription.insertNewObjectForEntityForName("Repo", inManagedObjectContext: managedObjectContext!) as! Repo
                        
                        newRepo.repoName = ni as! String
                        newRepo.user = UserResult
                        
                        var error: NSError?
                        
                        
                        managedObjectContext!.save(&error)
                    }
                    
                }
            }
            
        }else{
            
            var user: User = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: managedObjectContext!) as! User
            
            user.username = username
            
            
            var newii000 =  repos
            
            for ni in repos{
                var newRepo: Repo = NSEntityDescription.insertNewObjectForEntityForName("Repo", inManagedObjectContext: managedObjectContext!) as! Repo
                
                newRepo.repoName = ni as! String
                newRepo.user = user
                
            }
            
            var error: NSError?
            
            
            managedObjectContext!.save(&error)
            
        }
        
    }
    
    
    func hasConnectivity() -> Bool {
        
        var Status:Bool = false
        let url = NSURL(string: "http://google.com/")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "HEAD"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
        var response: NSURLResponse?
        
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: nil) as NSData?
        
        if let httpResponse = response as? NSHTTPURLResponse {
            if httpResponse.statusCode == 200 {
                Status = true
            }
        }
        
        return Status
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return reposit.count
    }
    
    
    
    func addUser(username: String) {
        
        
        
        var error: NSError? = nil
        
        var fReq = NSFetchRequest(entityName: "User")
        
        
        fReq.predicate = NSPredicate(format:"username ==%@", username)
        
        var result = managedObjectContext!.executeFetchRequest(fReq, error:&error)
        
        
        if ((result?.count == 0) || (result?.count == nil)){
            
            
            let entityDescription =
            NSEntityDescription.entityForName("User",
                inManagedObjectContext: managedObjectContext!)
            
            let newUser = User(entity: entityDescription!,
                insertIntoManagedObjectContext: managedObjectContext)
            
            
            newUser.username = username
            
            var error: NSError?
            
            
            managedObjectContext?.save(&error)
            
            if let err = error {
                println("erro")
            } else {
                println("Usuário  \(username) salvo no coredata")
            }
        }
        else{
            println("usuario \(username) existe")
        }
        
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
    
        
        cell.textLabel!.text = reposit.objectAtIndex((indexPath.row)) as? String
        
        
        return cell
    }
    
    override func viewDidAppear(animated: Bool) {
        table.reloadData()
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if (segue.identifier == "descri"){
            
            if let cel = sender as? UITableViewCell{
                let indexPath = table.indexPathForCell(cel)?.row
                
                if let destination = segue.destinationViewController as? DescView {
                    
                                      destination.activateNotificationCenter()
                    
                    let notification: NSNotificationCenter = NSNotificationCenter.defaultCenter()
                    
                    var mensagem : NSDictionary = NSDictionary(object:  (self.reposit.objectAtIndex(indexPath!) as? String)!, forKey: "Mensagem")
                    notification.postNotificationName("novoNome", object: self, userInfo: mensagem as [NSObject : AnyObject])
                }
            }
        }
    }
}
