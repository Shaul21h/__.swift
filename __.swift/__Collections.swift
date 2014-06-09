//
//  __Collections.swift
//  __.swift
//
//  Created by Hirose Tatsuya on 2014/06/07.
//  Copyright (c) 2014 tatsuya hirose. All rights reserved.
//

import Foundation

extension __ {
    
    /**
    * Collection Functions (Arrays or Dictionaries)
    */
    
    class func each<T>(list: T[], _ iterator: T -> Any)  {
        list.map { iterator($0) }
    }
    
    // alias for each
    class func forEach<T>(list: T[], _ iterator: T -> Any) {
        self.each(list, iterator)
    }
    
    class func map<T, U>(list: T[], _ iterator: T -> U) -> U[] {
        return list.map { iterator($0) }
    }
    
    class func map<K, V, T>(dict: Dictionary<K, V>, _ iterator: (K, V) -> T) -> T[] {
        var result = T[]()
        for (key, value) in dict {
            result += iterator(key, value)
        }
        return result
    }
    
    // alias for map
    class func collect<T, U>(list: T[], _ iterator: T -> U) -> U[] {
        return self.map(list, iterator)
    }
    
    class func reduce<T, U>(list: T[], _ memo: U, _ iterator: (first:U, second:T) -> U) -> U {
        
        var result = memo
        
        self.each(list) {
            result = iterator(first: result, second: $0)
        }
        
        return result
    }
    
    // alias for reduce
    class func inject<T, U>(list: T[], _ memo: U, _ iterator: (first:U, second:T) -> U) -> U {
        return self.reduce(list, memo, iterator)
    }
    
    // alias for reduce
    class func foldl<T, U>(list: T[], _ memo: U, _ iterator: (first:U, second:T) -> U) -> U {
        return self.reduce(list, memo, iterator)
    }
    
    class func find<T>(list: T[], _ filter: T -> Bool) -> T? {
        for item in list {
            if filter(item) {
                return item
            }
        }
        return nil
    }
    
    // alias for find
    class func detect<T>(list: T[], _ filter: T -> Bool) -> T? {
        return self.find(list, filter)
    }
    
    
    class func filter<T>(list: T[], _ filter: T -> Bool) -> T[] {
        var result = T[]()
        for item in list {
            if filter(item) {
                result += item
            }
        }
        return result
    }
    
    // alias for filter
    class func select<T>(list: T[], _ filter: T -> Bool) -> T[] {
        return self.filter(list, filter)
    }
    
    // Whether dict has subDictionary
    class func hasSubDictionary<K, V: Equatable>(dict:Dictionary<K,V>, subDictionary: Dictionary<K,V>) -> Bool {
        let eqList: Bool[] = __.map(subDictionary) { key, value in
            if let v = dict[key] {
                return v == value
            } else {
                return false
            }
        }
        return __.every(eqList)
    }
    
    class func `where`<K,V: Equatable>(list: Array<Dictionary<K,V>>, _ properties: Dictionary<K,V>) -> Array<Dictionary<K,V>> {
        var result = Array<Dictionary<K,V>>()
        for dict in list {
            if __.hasSubDictionary(dict, subDictionary: properties) {
                result += dict
            }
        }
        return result
    }
    
    class func findWhere<K,V: Equatable>(list: Array<Dictionary<K,V>>, _ properties: Dictionary<K,V>) -> Dictionary<K,V>? {
        for dict in list {
            if __.hasSubDictionary(dict, subDictionary: properties) {
                return dict
            }
        }
        return nil
    }
    
    class func reject<T>(list: T[], _ filter: T -> Bool) -> T[] {
        
        // I tried to compose ! and filter directly
        // but I have no idea do it exactly
        
        func notFilter(item: T) -> Bool {
            return !filter(item)
        }
        
        return self.filter(list, notFilter)
    }
    
    /*
    Maybe every and some can be written by already existing function.
    But I think it is faster to use short-circuit evaluation by for-in loop
    */
    
    class func every<L: LogicValue>(list: L[]) -> Bool {
        for item in list {
            if !item {
                return false
            }
        }
        return true
    }
    
    // alias for every
    class func all<L: LogicValue>(list: L[]) -> Bool {
        return self.every(list)
    }
    
    class func some<L: LogicValue>(list: L[]) -> Bool {
        for item in list {
            if item {
                return true
            }
        }
        return false
    }
    
    // alias for any
    class func any<L: LogicValue>(list: L[]) -> Bool {
        return self.some(list)
    }
    
    // Simple linear search
    class func contains<E: Equatable>(list: E[], value: E) -> Bool {
        for item in list {
            if item == value {
                return true
            }
        }
        return false
    }
    
    // alias for contains
    class func include<E: Equatable>(list: E[], value: E) -> Bool {
        return self.contains(list, value: value);
    }
    
    class func pluck<K, V>(list: Array<Dictionary<K, V>>, key: K) -> V[] {
        var result = V[]()
        for item in list {
            if let value = item[key] {
                result += value
            }
        }
        return result
    }
    
    // I want to write below 4 function as "comparator: < " instead of "comparator: { $0 < $1 }"
    class func max<C: Comparable>(list: C[]) -> C! {
        return self.tournament(list, comparator: { $0 < $1 })
    }
    
    class func max<C: Comparable>(list: C...) -> C! {
        return self.tournament(list, comparator: { $0 < $1 })
    }
    
    class func min<C: Comparable>(list: C[]) -> C! {
        return self.tournament(list, comparator: { $0 > $1 } )
    }

    class func min<C: Comparable>(list: C...) -> C! {
        return self.tournament(list, comparator: { $0 > $1 } )
    }
    
    // This function is used in max and min function
    // Since max and min function pass the test, we decide tournament function is work correctly
    class func tournament<C: Comparable>(list: C[], comparator: (C, C) -> Bool) -> C! {
        if list.isEmpty { return nil }
        var candidate = list[0]
        for item in list {
            if comparator(candidate,item) {
                candidate = item
            }
        }
        return candidate
    }
    
    // quick sort
    class func sortBy<T, C: Comparable>(list: T[], _ iterator: T -> C) -> T[] {
        if list.isEmpty { return [] }
        
        var smaller = T[]()
        var bigger = T[]()
        
        let first = list[0]
        let length = list.count
        
        for i in 1..length {
            if iterator(first) < iterator(list[i]) {
                bigger += list[i]
            } else {
                smaller += list[i]
            }
        }
        
        var result = sortBy(smaller, iterator)
        result += first
        result += sortBy(bigger, iterator)
        
        return result
    }
    
    class func groupBy<K, V>(list: V[], _ iterator: V -> K) -> Dictionary<K, V[]> {
        var result = Dictionary<K, V[]>()
        
        for item in list {
            let key = iterator(item)
            if let array = result[key] {
                result[key] = array + [item]
            } else {
                result[key] = [item]
            }
        }
        
        return result
    }
    
    class func indexBy<K, V>(list: Array< Dictionary<K, V> >, _ key: K) -> Dictionary<V, Dictionary<K,V> > {
        var result = Dictionary<V, Dictionary<K,V> >()
        for item in list {
            result[item[key]!] = item
        }
        return result
    }
    
    class func countBy<T, U>(list: T[], _ iterator: T -> U) -> Dictionary<U, Int> {
        var result = Dictionary<U, Int>()
        for item in list {
            if let count = result[iterator(item)] {
                result[iterator(item)] = count + 1
            } else {
                result[iterator(item)] = 1
            }
        }
        return result
    }
    
    class func shuffle<T>(list: T[]) -> T[] {
        let length = list.count
        var random = Int[]()
        while random.count < length {
            let index = __.random(length-1)
            if !self.contains(random, value: index) {
                random += index
            }
        }
        return self.map(random) { list[$0] }
    }
    
    class func sample<T>(list: T[]) -> T {
        let index = __.random(list.count-1)
        return list[index]
    }
    
    class func sample<T>(list: T[], _ n:Int) -> T[] {
        var result = T[]()
        let random = self.shuffle(Array(0..list.count))
        for i in 0..n {
            result += list[random[i]]
        }
        return result
    }
    
    class func size<T>(list: T[]) -> Int {
        return list.count
    }
    
    class func size<K, V>(dict: Dictionary<K, V>) -> Int {
        return Array(dict.keys).count
    }
    
}
