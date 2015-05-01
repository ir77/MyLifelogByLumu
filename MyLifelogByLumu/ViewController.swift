//
//  ViewController.swift
//  MyLifelogByLumu
//
//  Created by ucuc on 4/24/15.
//  Copyright (c) 2015 ucuc. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, LumuManagerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var lm = LumuManager.sharedManager()
        lm.delegate = self
        lm.startLumuManager()
    }

    @IBAction func insertButton(sender: AnyObject) {
        self.insert()
    }
    
    @IBAction func searchButton(sender: AnyObject) {
        self.search()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - parse
    
    // MARK: - CoreData
    // AppDelegateクラスのインスタンスを取得
    func insert() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        // AppDelegateクラスからNSManagedObjectContextを取得
        // ゲッターはプロジェクト作成時に自動生成されている
        if let managedObjectContext = appDelegate.managedObjectContext {
            // NSEntityDescriptionから新しいエンティティモデルのインスタンスを取得
            // 第一引数はモデルクラスの名前、第二引数はNSManagedObjectContext
            let managedObject: AnyObject = NSEntityDescription.insertNewObjectForEntityForName("Illuminance", inManagedObjectContext: managedObjectContext)
            // エンティティモデルにデータをセット
            let model = managedObject as! Illuminance
            model.illuminance = 100
            model.timeStamp = NSDate()
            
            // AppDelegateクラスに自動生成された saveContext で保存完了    appDelegate.saveContext()
        }
    }
    
    func search() {
        // AppDelegateクラスのインスタンスを取得
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        // AppDelegateクラスからNSManagedObjectContextを取得
        // ゲッターはプロジェクト作成時に自動生成されている
        if let managedObjectContext = appDelegate.managedObjectContext {
            // EntityDescriptionのインスタンスを生成
            let entityDiscription = NSEntityDescription.entityForName("Illuminance", inManagedObjectContext: managedObjectContext);
            // NSFetchRequest SQLのSelect文のようなイメージ
            let fetchRequest = NSFetchRequest();
            fetchRequest.entity = entityDiscription;
            // NSPredicate SQLのWhere句のようなイメージ
            // someDataBプロパティが100のレコードを指定している
            let predicate = NSPredicate(format: "%K = %d", "illuminance", 100)
            fetchRequest.predicate = predicate
            
            var error: NSError? = nil;
            // フェッチリクエストの実行
            if var results = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) {
                for managedObject in results {
                    let model = managedObject as! Illuminance;
                    println("String: \(model.illuminance), Number: \(model.timeStamp)");
                }
            }
        }
    }
    
    // MARK: - lumu
    func lumuManagerDidStartLumu() {
        NSLog("Start");
    }
    
    func lumuManagerDidRecognizeLumu() {
        NSLog("Recognized");
    }
    
    func lumuManagerDidNotRecognizeLumu() {
        NSLog("Not recognized");
    }
    
    func lumuManagerDidNotGetRecordPermission() {
        NSLog("No record permission");
    }

    func lumuManagerDidReceiveData(value: CGFloat) {
        NSLog("lumu Manager Did ReceiveData %f", value);
    }

    func lumuManagerDidStopLumu() {
        NSLog("lumu Manager Did Stop Lumu");
    }
}

