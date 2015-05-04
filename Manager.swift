//
//  Manager.swift
//  GitApp
//
//  Created by Guilherme on 29/04/15.
//  Copyright (c) 2015 Fernando. All rights reserved.
//

import UIKit

public class Manager {
    
    static let sharedInstance:Manager = Manager()
    
    var userRepos = Array<NSString>()
    var clientiD = "?client_id=5032e087396055bfb548"
    var secret = "&client_secret=0e4b80b056fc429461d7ca6abab34c29d6e7cc04"
    var clientD2 = "client_id=5032e087396055bfb548"
   
    private init(){}
    
    
    func getAllUserRepos(userName:NSString)-> NSArray{
        
        
        var arrayRepos = Array<NSString>()
        
        var allRepos = NSURL (string: "https://api.github.com/users/\(userName)/repos\(clientiD)\(secret)") //<-- puxando da web
   
       
     
        
    
        var data = NSData(contentsOfURL: allRepos!)
        
        
        let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil)
        
        if let repos: AnyObject = json{
            for items in repos as! NSArray{
                let nome: AnyObject  = items  //iterando todos os repos do usuario
                let nome2 = nome["name"] as! NSString
                arrayRepos.append(nome2)
                
                
                // self.checkARepo(nome2, user: userName)  //chamando a função para checar o dono do repo
                
            }
        }
        
      
        return arrayRepos
        
        
    }
    
    
    
    
    func checkARepo(repo:NSString, user:NSString)  {
        
        
        
        //      var repos = NSURL(string: "file:///Users/pardim/Desktop/Contador.html") //<--usando arquivo local
        var repos = NSURL(string: "https://api.github.com/repos/\(user)/\(repo)\(clientiD)\(secret)")
        
        
        
        var data = NSData(contentsOfURL: repos!)
        let json2: AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil)
        // se ocorrer um crash na linha acima, pode ser que as requisicões acabaram
        
        //        if let repoo: AnyObject = json2{
        //
        //            var dic = repoo as! NSDictionary
        //            var dic2 = dic["parent"] as? NSDictionary
        //            var dic3 = dic2["owner"] as! NSDictionary
        //            //        println(dic3["login"])
        //
        //            if((dic3["login"]!) as! String == "mackmobile"){ //caso o owner seja o mackmobile, adiconamos elea a nossa array de repos do mackmobile
        //                userRepos.append(repo)
        //                //checkPullNumber(repo, username:user)
        //            }
        
        
        //       }
    }
    
    func checkPullNumber(repoName:NSString, username:NSString) ->NSString{
        //var repos = NSURL(string: "file:///Users/pardim/Desktop/pulls.html") //<--usando arquivo local
        var repos = NSURL(string: "https://api.github.com/repos/mackmobile/\(repoName)/pulls?state=page1&&\(clientD2)\(secret)")
        var cont = NSInteger()
        
        var data = NSData(contentsOfURL: repos!)
        let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil)
        // se ocorrer um crash na linha acima, pode ser que as requisicões acabaram
        
        if let repos: AnyObject = json{
            for repo in repos as! NSArray{
                var dic = repo["user"] as! NSDictionary
                var dic2: NSString = dic["login"] as! NSString
                cont++
                if(username == dic2){  //acessando todos os pull requests do repo pra procurar para encontra o pull request do usuario
                    if let test = repo["number"]{ // caso o nome do dono do pull request coincida com o nome do nosso usuário
                        var pullNumber = repo["number"] as! Int //pegamos o numero do pull request dele
                        var pullNumber2 =  String(stringInterpolationSegment: pullNumber)
                        
                        println(pullNumber2)
                        return pullNumber2
                    }
                    //                    checkLabelsbyRepo(pullNumber2, repo: repoName) //ema vez pegado o numero, podemos chamar o metodo para fazer a procura das labels
                }
                
            }
        }
        
        //esse trecho de código eh uma repetição do codigo acima, com exceção de acessamos a segunda página, já que a API lista 30 repos por vez
        if (cont >=  28){
            var repos2 = NSURL(string: "https://api.github.com/repos/mackmobile/\(repoName)/pulls?state=page2&&\(clientD2)\(secret)")
            println(repos2)
            
            var data2 = NSData(contentsOfURL: repos2!)
            let json2: AnyObject? = NSJSONSerialization.JSONObjectWithData(data2!, options: NSJSONReadingOptions.AllowFragments, error: nil)
            // se ocorrer um crash na linha acima, pode ser que as requisicões acabaram
            
            if let repos_: AnyObject = json2{
                for repo_ in repos_ as! NSArray{
                    var dic_ = repo_["user"] as! NSDictionary
                    var dic2_: NSString = dic_["login"] as! NSString
                    println("-----")
                    println(dic2_)
                    if(username == dic2_){  //acessando todos os pull requests do repo pra procurar para encontra o pull request do usuario
                        println(dic2_)
                        if let test_ = repo_["number"]{ // caso o nome do dono do pull request coincida com o nome do nosso usuário
                            var pullNumber = repo_["number"] as! Int //pegamos o numero do pull request dele
                            
                            println(pullNumber)
                            var pullNumber2 =  String(stringInterpolationSegment: pullNumber)
                            return pullNumber2
                        }
                        //                    checkLabelsbyRepo(pullNumber2, repo: repoName) //ema vez pegado o numero, podemos chamar o metodo para fazer a procura das labels
                    }
                    
                }
            }

        }
        
              return ""
    }
    
    
    func checkLabelsbyRepo(number:NSString, repo:NSString)->NSArray?{
        
        //    var repos = NSURL(string: "file:///Users/pardim/Desktop/label.html") //<--usando arquivo local
        
        var  newNumber = number
        var numero = newNumber
        println(numero)
        if (numero != ""){
        //        if (number != nil) {
        
        var repositorio = repo
        if(repositorio != "Contador"){
            var repos = NSURL(string: "https://api.github.com/repos/mackmobile/\(repositorio)/issues/\(number)\(clientiD)\(secret)")
            println(repos)
            var data = NSData(contentsOfURL: repos!)
            let json: AnyObject! = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil)!
            // se ocorrer um crash na linha acima, pode ser que as requisicões acabaram
            
            if let rep: AnyObject = json{
                
                var dic = rep as! NSDictionary
                if (dic["labels"] != nil ){
                    var dic2 = dic["labels"] as! NSArray //pegando a primeira label do pull request para teste
                    //var dic3 = dic2[0] as! NSDictionary
                    //println(dic3["name"])
                    return dic2
                }
            }
            //            }
            }
        }
        
        return NSArray()
        
    }
    
}

