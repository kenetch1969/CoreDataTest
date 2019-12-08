//
//  ViewController.swift
//  CoreDataTest
//
//  Created by Krzysztof Kempiński on 22.11.2017.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    @IBAction func insertAction(_ sender: UIButton) {
        insertUser()
    }
    
    @IBAction func fetchUserAction(_ sender: UIButton) {
        fetchAll()
    }
    
    @IBAction func fetchBMWAction(_ sender: UIButton) {
        fetchBMW()
    }
    
    
    @IBAction func fetchEmmanuel(_ sender: UIButton) {
        fetchEmmanuel()
    }
    
    func insertUser() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let rand = Int.random(in: 0..<5)
        let name = [["name":"john", "email":"a@a.com", "date":"1990/10/08", "children": 1],
                    ["name":"jacobo", "email":"b@a.com", "date":"1994/10/08", "children": 2],
                    ["name":"armando", "email":"c@a.com", "date":"1992/10/08", "children": 4],
                    ["name":"emmanuel", "email":"d@a.com", "date":"1993/10/08", "children": 3],
                    ["name":"roberto", "email":"e@a.com", "date":"1995/10/08", "children": 2]
                   ]
        let model = [["model": "Audi TT", "year": 2010],
                    ["model": "BMW X6", "year": 2012],
                    ["model": "VOLKWAGEN","year": 2014],
                    ["model": "JETTA","year": 2015],
                    ["model": "CAMARO", "year": 2016]]
        
        let user = User(context: managedContext)
        
        user.name = name[rand]["name"] as? String
        user.email = name[rand]["email"] as? String
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        if let fecha = name[rand]["date"] as? String, let date = formatter.date(from: fecha) {
           user.date_of_birth = date as NSDate
        }
        if let children = name[rand]["children"] as? Int {
            user.number_of_children = Int16(children)
        } else {
          user.number_of_children = 0
        }
        
        let rand1 = Int.random(in: 0..<5)
        let car1 = Car(context: managedContext)
        car1.model = model[rand1]["model"] as? String
        if let year = model[rand1]["year"] as? Int {
           car1.year = Int16(year)
        } else {
          car1.year = 0
        }
        car1.user = user
        
        let rand2 = Int.random(in: 0..<5)
        let car2 = Car(context: managedContext)
        car2.model = model[rand2]["model"] as? String
        if let year = model[rand2]["year"] as? Int {
           car2.year = Int16(year)
        } else {
           car2.year = 0
        }
        car2.user = user
        
        let setCar = NSSet()
        setCar.addingObjects(from: [car1,car2])
        
        user.addToCars(setCar)
        
        do {
            try managedContext.save()
        } catch {
            print("Error : \(error.localizedDescription)")
        }
    }
    
    func fetchAll () {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchUser: NSFetchRequest<User> = User.fetchRequest()
        
        do {
            let users = try managedContext.fetch(fetchUser)
            for user in users {
                print("name: \(user.name ?? "") email: \(user.email ?? "") date: \(String(describing: user.date_of_birth)) children: \(user.number_of_children) ")
            }
        } catch {
            print("Error : \(error.localizedDescription)")
        }
        
    }
    
    func fetchBMW () {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchUser: NSFetchRequest<User> = User.fetchRequest()
        fetchUser.predicate = NSPredicate(format: "ANY cars.model = %@", "BMW X6" )
        
        //let johnCars = john.cars?.allObjects as! [Car]
        do {
            let users = try managedContext.fetch(fetchUser)
            for user in users {
                print("name: \(user.name ?? "") email: \(user.email ?? "") date: \(String(describing: user.date_of_birth)) children: \(user.number_of_children) ")
                
                for car in user.cars?.allObjects as! [Car] {
                    print ("     Model: \(car.model ?? "") year: \(car.year)")
                }
            }
            
        } catch {
            print("Error : \(error.localizedDescription)")
        }
    }
    
    func fetchEmmanuel () {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchCar: NSFetchRequest<Car> = Car.fetchRequest()
        fetchCar.predicate = NSPredicate(format: "ANY user.name = %@", "emmanuel")
        
        //let johnCars = john.cars?.allObjects as! [Car]
        do {
            let cars = try managedContext.fetch(fetchCar)
            for car in cars {
                print ("Model: \(car.model ?? "") year: \(car.year) name: \(car.user?.name ?? "")")
            }
            
        } catch {
            print("Error : \(error.localizedDescription)")
        }
    }
    
    
    
    func anterior () {
             guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
              let managedContext = appDelegate.persistentContainer.viewContext
              
              let userEntity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
              let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
              
              user.setValue("John1", forKeyPath: "name")
              user.setValue("john@test.com", forKey: "email")
              let formatter = DateFormatter()
              formatter.dateFormat = "yyyy/MM/dd"
              let date = formatter.date(from: "1990/10/08")
              user.setValue(date, forKey: "date_of_birth")
              user.setValue(0, forKey: "number_of_children")
              
              let carEntity = NSEntityDescription.entity(forEntityName: "Car", in: managedContext)!

              let car1 = NSManagedObject(entity: carEntity, insertInto: managedContext)
              car1.setValue("Audi TT", forKey: "model")
              car1.setValue(2010, forKey: "year")
              car1.setValue(user, forKey: "user")
              
              let car2 = NSManagedObject(entity: carEntity, insertInto: managedContext)
              car2.setValue("BMW X6", forKey: "model")
              car2.setValue(2014, forKey: "year")
              car2.setValue(user, forKey: "user")
              
              let cars = user.mutableSetValue(forKey: "cars")
              cars.add(car1)
              cars.add(car2)
              
              do {
                  try managedContext.save()
              } catch let error as NSError {
                  print("Could not save. \(error), \(error.userInfo)")
              }
              
              let carFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Car")
              let carsResults = try! managedContext.fetch(carFetch)
              print((carsResults.last as! Car).user)
              
              do {
                  let count = try managedContext.count(for: carFetch)
                  print(count)
              } catch let error as NSError {
                  print("Error: \(error.localizedDescription)")
              }
              
              let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
              
              userFetch.fetchLimit = 1
              userFetch.predicate = NSPredicate(format: "name = %@", "John1")
              userFetch.sortDescriptors = [NSSortDescriptor.init(key: "email", ascending: false)]
              
              let users = try! managedContext.fetch(userFetch)
              
              let john: User = users.first as! User
              
              print("Email: \(john.email!)")
              let johnCars = john.cars?.allObjects as! [Car]
              print("has \(johnCars.count)")
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

