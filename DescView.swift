//
//  DescView.swift
//  GitApp
//
//  Created by Wellington Pardim Ferreira on 4/29/15.
//  Copyright (c) 2015 Fernando. All rights reserved.
//



//problema no userdefaults
import UIKit
import CoreData




class DescView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    
    let managedObjectContext =
    (UIApplication.sharedApplication().delegate
        as! AppDelegate).managedObjectContext
    var newLabelsColorsFromJSON = NSMutableArray()
    var colorArray = NSMutableArray()
    @IBOutlet weak var RepoName: UILabel!
    @IBOutlet weak var table: UITableView!
    var nomeRepo = String()
    var labels = NSMutableArray()
    var numberPull:NSString! = NSString()
    var newLabelsFromJSON = NSMutableArray()
    var labl = NSArray()
    
    override func viewDidLoad() {
        
        
        
        super.viewDidLoad()
        labels.removeAllObjects()
        newLabelsFromJSON.removeAllObjects()
        
        RepoName.text = nomeRepo
        var repo = nomeRepo
        
        table.delegate = self
        table.dataSource = self
        
        
        
        if(hasConnectivity()){
            let defaults = NSUserDefaults.standardUserDefaults()
            var nome1:NSString = defaults.stringForKey("nome")!
            
            numberPull = Manager.sharedInstance.checkPullNumber(nomeRepo, username:nome1) as NSString!
            
            labl = Manager.sharedInstance.checkLabelsbyRepo(numberPull, repo: nomeRepo)!
            
            
            
            
            
            var labelsFromBD = getLabelsBD(repo)
            
            
            
            
            for labelsJson in labl{
                var existInBd = Bool()
                existInBd = false
                
                for labelsBD in labelsFromBD{
                    if let label: AnyObject = labelsBD.valueForKey("name"){
                        
                        
                        if((label as! NSString) as NSString == (labelsJson["name"] as! NSString) as NSString){
                            existInBd = true
                        }
                        
                    }
                }
                
                if(existInBd == false){
                    var labelName = labelsJson["name"] as! String
                    newLabelsFromJSON.addObject(labelName)
                    var labelColor = labelsJson["color"] as! String
                    newLabelsColorsFromJSON.addObject(labelColor)
                    callLocalNotification()
                }
                
            }
          
            
            addLabelBD(nomeRepo, labelsArray: newLabelsFromJSON, labelsColor:newLabelsColorsFromJSON )
            
            for labName in labl{
                var name = labName["name"] as! String
                labels.addObject(name)
                var labelColor: AnyObject = labName.valueForKey("color")!
                colorArray.addObject(labelColor)

            }
            
            
            
        }else{
            var labelsBD = getLabelsBD(nomeRepo)
            
            
         
            for lb in labelsBD{
                
                if let labelName: AnyObject = lb.valueForKey("name"){
                    println(labelName)
                }
                
                
                
            }
            
            for label in labelsBD{
                
                if let labelName: AnyObject = label.valueForKey("name"){
                    labels.addObject(labelName)
                    var labelColor: AnyObject = label.valueForKey("color")!
                    colorArray.addObject(labelColor)
                }
            }
            
        }
        
        
        table.reloadData()
        
        
    }
    
    func callLocalNotification(){
        var localNotification = UILocalNotification()
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 0)
        localNotification.alertBody = "Você tem atualizações no repositorio \(nomeRepo)."
        localNotification.timeZone = NSTimeZone.defaultTimeZone()
        localNotification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
        
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)

        
    }
    
    override func viewDidDisappear(animated: Bool) {
        labels.removeAllObjects()
        newLabelsFromJSON.removeAllObjects()
        table.reloadData()
        
    }
    
    override func viewWillAppear(animated: Bool) {
  
        
    }
    
    
    func activateNotificationCenter(){
        let notification : NSNotificationCenter = NSNotificationCenter.defaultCenter()
        notification.addObserver(self, selector: "retrievingData:", name: "novoNome", object: nil)
        
    }
    
    
    
    func retrievingData (mensagem:NSNotification){
        let info: Dictionary<String, String!> = mensagem.userInfo as! Dictionary<String, String!>
        
        let repo_name = info["Mensagem"];
        
        nomeRepo = repo_name!
    }
    
    
    override func viewDidAppear(animated: Bool) {
      
        table.reloadData()
    }
    
    func getLabelsBD(repo: String) -> NSSet {

        var error: NSError? = nil
        
        var fReq: NSFetchRequest = NSFetchRequest(entityName: "Repo")
        
        fReq.predicate = NSPredicate(format:"repoName ==%@", repo )
        
        var results = managedObjectContext!.executeFetchRequest(fReq, error:&error)
        
        let res:AnyObject = results?.first! as! NSObject
        
        if let result = results{
            
            for var index = 0; index < result.count; ++index {
                
                
                var repoResult = result[index] as! Repo
                let defaults = NSUserDefaults.standardUserDefaults()
                var nome2:NSString = defaults.stringForKey("nome")! as NSString!
            
                
                if(repoResult.user.username == nome2){
                    println("nome das labels")
                    println(repoResult.labels.count)
                    for yy in repoResult.labels{
                        println(yy.name)
                    }
                    
                    return  repoResult.labels
                }   
                
            }
            
        }
        
        return NSSet()
    }
    
    
    
    func addLabelBD(repo: String, labelsArray: NSMutableArray, labelsColor: NSMutableArray) {
        
        var error: NSError? = nil
        
        var fReq = NSFetchRequest(entityName: "Repo")
        
        
        fReq.predicate = NSPredicate(format:"repoName ==%@", repo)
        
        var result = managedObjectContext!.executeFetchRequest(fReq, error:&error)
        
        
        
        if(result?.count > 0){
            
            //            for resultItem in result! {
            for var index = 0; index < result?.count; ++index {
                
                var RepoResult = result?[index] as! Repo
                
                
                let defaults = NSUserDefaults.standardUserDefaults()
                var nome1:NSString = defaults.stringForKey("nome")!
                
                
                if((repo == RepoResult.repoName) && (RepoResult.user.username == nome1 )){
                    
                    
                    
                    for var index = 0; index < labelsArray.count; ++index {
                        var newLabel: Labels = NSEntityDescription.insertNewObjectForEntityForName("Labels", inManagedObjectContext: managedObjectContext!) as! Labels
                        
                        newLabel.color = labelsColor[index] as! String
                        newLabel.name = labelsArray[index] as! String
                        newLabel.repo  = RepoResult
                    }
                    
            
                    
                    
                    
                }
                
            }
            managedObjectContext!.save(&error)
            
        }else{
            
            var newRepo: Repo = NSEntityDescription.insertNewObjectForEntityForName("Repo", inManagedObjectContext: managedObjectContext!) as! Repo
            
            newRepo.repoName = repo
            
            
            
            
          
            
            
            for var index = 0; index < labelsArray.count; ++index {
                var newLabel: Labels = NSEntityDescription.insertNewObjectForEntityForName("Labels", inManagedObjectContext: managedObjectContext!) as! Labels
                
                newLabel.color = labelsColor[index] as! String
                newLabel.name = labelsArray[index] as! String
                newLabel.repo  = newRepo
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
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        println(labels.count)
        return labels.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("celula", forIndexPath: indexPath) as! UITableViewCell
        
        var texto = labels[indexPath.row]
        var cor = colorArray[indexPath.row] as! String
                var corHex:UIColor = hexStringToUIColor(cor)
                cell.backgroundColor = corHex
        cell.textLabel!.text = texto as? String
        
        cell.textLabel!.text = texto as? String
        
        return cell
    }
    
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(advance(cString.startIndex, 1))
        }
        
        if (count(cString) != 6) {
            return UIColor.grayColor()
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
