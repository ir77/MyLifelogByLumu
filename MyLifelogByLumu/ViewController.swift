//
//  ViewController.swift
//  MyLifelogByLumu
//
//  Created by ucuc on 4/24/15.
//  Copyright (c) 2015 ucuc. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, LumuManagerDelegate, MyParseDelegate {
    var tmpDataCounter : Int = 0
    var dataCounter: Int = 0
    var parseObject = MyParse()
    @IBOutlet weak var illLabel: UILabel!
    @IBOutlet weak var successLabel: UILabel!
    @IBOutlet weak var lumuStatus: UILabel!
    @IBOutlet weak var dataCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var lm = LumuManager.sharedManager()
        lm.delegate = self
        lm.startLumuManager()
        tmpDataCounter = 0
        
        parseObject.delegate = self
    }

    @IBAction func searchButton(sender: AnyObject) {
        if var data = self.getData() {
            parseObject.saveBrightnessDataInParse(data)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Parse
    func saveBackgroundSuccess() -> Void {
        successLabel.text = getNowDate()
        self.deleteData()
    }
    
    func saveBackgroundFail() -> Void {
        successLabel.text = "Send Failed"
    }
    
    
    // MARK: - CoreData
    func insertData(data: NSNumber) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        // AppDelegateクラスからNSManagedObjectContextを取得
        // ゲッターはプロジェクト作成時に自動生成されている
        if let managedObjectContext = appDelegate.managedObjectContext {
            // NSEntityDescriptionから新しいエンティティモデルのインスタンスを取得
            // 第一引数はモデルクラスの名前、第二引数はNSManagedObjectContext
            let managedObject: AnyObject = NSEntityDescription.insertNewObjectForEntityForName("Illuminance", inManagedObjectContext: managedObjectContext)
            // エンティティモデルにデータをセット
            let model = managedObject as! Illuminance
            model.illuminance = data
            model.timeStamp = getNowDate()
            model.createdAt = NSDate()
            dataCount.text = "\(dataCount.text!.toInt()! + 1)"
        }
    }
    
    func getNowDate () -> String {
        let now = NSDate() // 現在日時の取得
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP") // ロケールの設定
        dateFormatter.timeStyle = .MediumStyle
        dateFormatter.dateStyle = .MediumStyle
        return dateFormatter.stringFromDate(now)
    }
    
    func getData() -> [Dictionary<String, String>]?{
        var illuminanceDict : [Dictionary<String, String>]? = []

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
            // let predicate = NSPredicate(format: "%K = %d", "illuminance", 100)
            // fetchRequest.predicate = predicate
            
            var error: NSError? = nil;
            // フェッチリクエストの実行
            if var results = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) {
                for managedObject in results {
                    let model = managedObject as! Illuminance;
                    println("illuminance: \(model.illuminance), TimeStamp: \(model.timeStamp)");
                    let tmpDict: Dictionary<String, String> = ["illuminance": "\(model.illuminance)", "timeStamp":"\(model.timeStamp)"]
                    illuminanceDict!.append(tmpDict)
                }
            }
        }
        
        return illuminanceDict
    }
    
    func deleteData() {
        /* Get ManagedObjectContext from AppDelegate */
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            let entityDiscription = NSEntityDescription.entityForName("Illuminance", inManagedObjectContext: managedObjectContext);
            let fetchRequest = NSFetchRequest();
            fetchRequest.entity = entityDiscription;
            
            var error: NSError? = nil;
            // フェッチリクエストの実行
            if var results = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) {
                for managedObject in results {
                    let model = managedObject as! Illuminance;
                    /* Delete managedObject from managed context */
                    managedObjectContext.deleteObject(model)
                }
            }
            
            if !managedObjectContext.save(&error) {
                println("Could not update \(error), \(error!.userInfo)")
                successLabel.text = "Delete Failed"
            }
            println("deleted")
        }
    }
    
    func countData() -> Int {
        /* Get ManagedObjectContext from AppDelegate */
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            let entityDiscription = NSEntityDescription.entityForName("Illuminance", inManagedObjectContext: managedObjectContext);
            let fetchRequest = NSFetchRequest();
            fetchRequest.entity = entityDiscription;
            
            var error: NSError? = nil;
            if var results = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) {
                return results.count
            }
        }
        return -1
    }

    
    // MARK: - lumu
    func lumuManagerDidStartLumu() {
        NSLog("Start");
        lumuStatus.text = "Start"
        dataCount.text = "\(countData())"
    }
    
    func lumuManagerDidRecognizeLumu() {
        NSLog("Recognized");
        lumuStatus.text = "OK"
    }
    
    func lumuManagerDidNotRecognizeLumu() {
        NSLog("Not recognized");
        lumuStatus.text = "NG"
    }
    
    func lumuManagerDidNotGetRecordPermission() {
        NSLog("No record permission");
    }

    func lumuManagerDidReceiveData(value: CGFloat) {
        illLabel.text = String(format: "%.01f", Float(value))
        tmpDataCounter++
        
        if tmpDataCounter > 19 {
            tmpDataCounter = 0
            self.insertData(value)
        }
    }

    func lumuManagerDidStopLumu() {
        NSLog("lumu Manager Did Stop Lumu");
        lumuStatus.text = "Stop"
    }
}

