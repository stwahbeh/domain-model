//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//


//Need to be able to convert from one money type to any other money type if else tree doesn't really work then

public struct Money {
    

    public var amount : Int
    public var currency : String
    
    
    init(amount: Int, currency: String) {
        self.amount = amount
        self.currency = currency
    }
    

  
  public func convert(_ to: String) -> Money {
    var newMoney = Money(amount: amount, currency: currency)
    
    //convert to USD
    if (newMoney.currency != "USD"){
        if (newMoney.currency == "GBP"){
            newMoney.amount = newMoney.amount * 2
        } else if (newMoney.currency == "EUR"){
            newMoney.amount = (newMoney.amount * 2 / 3);
        } else if (newMoney.currency == "CAN"){
            newMoney.amount = (newMoney.amount * 4 / 5);
        } else {
            print("not valid currency")
        }
    }
    
    //convert to final currency
    if (to == "USD") {
        
    } else if (to == "GBP") {
        newMoney.amount = newMoney.amount / 2
    } else if (to == "EUR"){
        newMoney.amount = (newMoney.amount * 3 / 2);
    } else if (to == "CAN"){
        newMoney.amount = (newMoney.amount * 5 / 4);
    } else {
        print("not valid currency")
    }
    newMoney.currency = to
    print(newMoney)
    return newMoney
  }

  
  public func add(_ to: Money) -> Money {
    var total = Money(amount: amount, currency: currency)
    total = total.convert(to.currency)
    total.amount = total.amount + to.amount
    return total
  }
  public func subtract(_ from: Money) -> Money {
    var total = Money(amount: amount, currency: currency)
    total = from.convert(currency)
    total.amount = total.amount - from.amount
    return total
  }
}

//////////////////////////////////
// Job

open class Job {
    fileprivate var title : String
    fileprivate var type : JobType
    
  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
  }
  
  public init(title : String, type : JobType) {
        self.title = title
        self.type = type
  }
  
  open func calculateIncome(_ hours: Int) -> Int {

    switch type {
    case .Salary (let salary):
        return salary
    case .Hourly (let hourly):
        return Int(Double(hourly)) * hours
    }
  }
  
  open func raise(_ amt : Double) {
  
    switch type {
    case let .Salary (salary):
        self.type = Job.JobType.Salary(Int(Double(salary)) + Int(amt))
    case let .Hourly(hourly):
        self.type = Job.JobType.Hourly(hourly + amt)
    }
  }
}

////////////////////////////////////
// Person
//
open class Person {
    open var firstName : String = ""
    open var lastName : String = ""
    open var age : Int = 0
    

        
  fileprivate var _job : Job? = nil
  open var job : Job? {
    get {
        if (_job == nil) {
            return nil
        } else {
            return _job!
        }
    }
    set(newvalue) {
        if (age > 15){
         _job = newvalue
        } else {
        print("too young to have a job")
        }
    }
  }
  
  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get {
        if _spouse == nil {
            return nil
        } else {
            return _spouse!
        }
    }
    set(value) {
        if value != nil {
            if (age > 18){
                _spouse = value
            }else {
                _spouse = nil
                
        }
        }
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  
  open func toString() -> String {
    if (_job == nil && spouse == nil){
        return ("[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(_job?.title) spouse:\(spouse)]")
    } else if (_job != nil && spouse == nil){
        return ("[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(_job!.title) spouse:\(spouse)]")
    } else if (_job == nil && spouse != nil){
        return ("[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(job?.title) spouse:\(spouse!.firstName + " " + spouse!.lastName)]")
    } else {
        return ("[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(job!.title) spouse:\(spouse!.firstName + " " + spouse!.lastName)]")
    }
}
}

////////////////////////////////////
// Family
//
open class Family {
    fileprivate var members : [Person] = []
    fileprivate var eligible : Bool
  
  public init(spouse1: Person, spouse2: Person) {
    members.append(spouse1)
    members.append(spouse2)
    spouse1.spouse = spouse2
    spouse2.spouse = spouse1
    if (spouse1.age < 21 && spouse2.age < 21){
        eligible = true
    } else {
        eligible = false
    }
    
  }
  
  open func haveChild(_ child: Person) -> Bool {
    members.append(child)
    return true
  }
    
  open func householdIncome() -> Int {
    var totalIncome = 0;
    for person in members{
        if (person._job != nil){
            switch person._job!.type {
                case .Salary (let salary):
                    totalIncome += salary
                case .Hourly(_):
                    totalIncome += (person.job?.calculateIncome(2000))!
        }
    }
    
    }
    return totalIncome
}
}






