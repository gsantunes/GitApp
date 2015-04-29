//
//  ViewController.swift
//  TestandoAPI
//
//  Created by Wellington Pardim Ferreira on 4/27/15.
//  Copyright (c) 2015 Wellington Pardim Ferreira. All rights reserved.
//

import UIKit

public class Manager {
    
    static let sharedInstance:Manager = Manager()
  
 //   var username = NSString(string:"wellpardim")
    var userRepos = Array<NSString>()
    
    private init(){}
    
    
    func getAllUserRepos(userName:NSString){
        
        var allRepos = NSURL(string: "https://api.github.com/users/\(userName)/repos") //<-- puxando da web
        
//          var allRepos = NSURL(string: "file:///Users/pardim/Desktop/repos.html") // <-- usando arquivo local
      
        println(allRepos)
        var data = NSData(contentsOfURL: allRepos!)
        
        
        let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil)
        
        if let repos: AnyObject = json{
            for items in repos as! NSArray{
                let nome: AnyObject  = items  //iterando todos os repos do usuario
                let nome2 = nome["name"] as! NSString

                self.checkARepo(nome2, user: userName)  //chamando a função para checar o dono do repo

            }
        }
     
        for mackRepos in userRepos{ //mostrando todos os repos do mackmobile, uma vez que encontramos todos eles
            println("Repositorios do mackmobile")
            println(mackRepos)
            println()
        }
        
        
}

    
    func checkARepo(repo:NSString, user:NSString)  {
    

        print(user)
    
//      var repos = NSURL(string: "file:///Users/pardim/Desktop/Contador.html") //<--usando arquivo local
        var repos = NSURL(string: "https://api.github.com/repos/\(user)/\(repo)")
    
        println(repos!)
        var data = NSData(contentsOfURL: repos!)
        let json2: AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil)
        // se ocorrer um crash na linha acima, pode ser que as requisicões acabaram
    
    if let repoo: AnyObject = json2{
        
        var dic = repoo as! NSDictionary
        var dic2 = dic["parent"] as! NSDictionary
        var dic3 = dic2["owner"] as! NSDictionary
//        println(dic3["login"])
        
        if((dic3["login"]!) as! String == "mackmobile"){ //caso o owner seja o mackmobile, adiconamos elea a nossa array de repos do mackmobile
            userRepos.append(repo)
            checkPullNumber(repo, username:user)
        }
        
        
    }
}
    
    func checkPullNumber(repoName:NSString, username:NSString) {
        //var repos = NSURL(string: "file:///Users/pardim/Desktop/pulls.html") //<--usando arquivo local
        var repos = NSURL(string: "https://api.github.com/repos/mackmobile/\(repoName)/pulls?state=all")
        
        println(repos!)
        var data = NSData(contentsOfURL: repos!)
        let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil)
        // se ocorrer um crash na linha acima, pode ser que as requisicões acabaram
        
            if let repos: AnyObject = json{
                for repo in repos as! NSArray{
                    var dic = repo["user"] as! NSDictionary
                    var dic2 = dic["login"] as! NSString
                    println("-----")
                    println(dic2)
                    if(username == dic2){  //acessando todos os pull requests do repo pra procurar para encontra o pull request do usuario
                        println(repo["number"]) // caso o nome do dono do pull request coincida com o nome do nosso usuário
                        var pullNumber = repo["number"] //pegamos o numero do pull request dele
                       var pullNumber2 =  String (stringInterpolationSegment: pullNumber)
                        checkLabelsbyRepo(pullNumber2, repo: repoName) //ema vez pegado o numero, podemos chamar o metodo para fazer a procura das labels
                    }
             
                }
            }
        
        //esse trecho de código eh uma repetição do codigo acima, com exceção de acessamos a segunda página, já que a API lista 30 repos por vez
        
        var repos2 = NSURL(string: "https://api.github.com/repos/mackmobile/\(repoName)/pulls?state=all&page=2")
     
    
        var data2 = NSData(contentsOfURL: repos2!)
        let json2: AnyObject? = NSJSONSerialization.JSONObjectWithData(data2!, options: NSJSONReadingOptions.AllowFragments, error: nil)
        // se ocorrer um crash na linha acima, pode ser que as requisicões acabaram
        
        if let repos: AnyObject = json2{
            for repo in repos as! NSArray{
                var dic = repo["user"] as! NSDictionary
                var dic2 = dic["login"] as! NSString
                
                if(username == dic2){
                    var pullNumber = repo["number"] as! NSString
                    checkLabelsbyRepo(pullNumber, repo: repoName)

                }
             
            }
        }

    }
        
    
    func checkLabelsbyRepo(number:NSString?, repo:NSString){
    
    //    var repos = NSURL(string: "file:///Users/pardim/Desktop/label.html") //<--usando arquivo local
        if (number != nil) {
        var numero = number!
        var repos = NSURL(string: "https://api.github.com/repos/mackmobile/\(repo)/issues/\(numero)")
        println(repos)
        var data = NSData(contentsOfURL: repos!)
        let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil)
        // se ocorrer um crash na linha acima, pode ser que as requisicões acabaram
        
        if let rep: AnyObject = json{
            
            var dic = rep as! NSDictionary
            var dic2 = dic["labels"] as! NSArray //pegando a primeira label do pull request para teste
            var dic3 = dic2[0] as! NSDictionary
            println(dic3["name"])
            
        }
            
        }
        
        
        
    }

}

   




