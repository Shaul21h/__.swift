//
//  __.swift
//  __.swift
//
//  Created by Hirose Tatsuya on 2014/06/03.
//  Copyright (c) 2014 tatsuya hirose. All rights reserved.
//

import Foundation

class __ {

    class func each<ItemType>(list: ItemType[], iterator: ItemType -> Any)  {
        list.map { iterator($0) }
    }
    
    class func map <ItemType, resultType>(list: ItemType[], iterator: ItemType -> resultType) -> resultType[] {
        return list.map { iterator($0) }
    }
    
    class func reduce <ItemType, ResultType>(list: ItemType[], memo: ResultType, iterator: (first:ResultType, second:ItemType) -> ResultType) -> ResultType {
        
        var result = memo
        
        self.each(list) {
            result = iterator(first: result, second: $0)
        }
        
        return result
    }
    
    class func find <ItemType>(list: ItemType[], filter: ItemType -> Bool) -> ItemType? {
        for item in list {
            if filter(item) {
                return item
            }
        }
        return nil
    }
    
    class func filter <ItemType>(list: ItemType[], filter: ItemType -> Bool) -> ItemType[] {
        var result = ItemType[]()
        for item in list {
            if filter(item) {
                result += item
            }
        }
        return result
    }

    class func reject<ItemType>(list: ItemType[], filter: ItemType -> Bool) -> ItemType[] {
        
        // I tried to compose ! and filter directly
        // but I have no idea do it exactly

        func notFilter(item: ItemType) -> Bool {
            return !filter(item)
        }
        
        return self.filter(list, notFilter)
    }
    
    /*
        Maybe every and some can be written by already existing function.
        But I think it is faster to use short-circuit evaluation by for-in loop
    */
    
    class func every(list: Bool[]) -> Bool {
        for item in list {
            if !item {
                return false
            }
        }
        return true
    }
    
    class func some(list: Bool[]) -> Bool {
        for item in list {
            if item {
                return true
            }
        }
        return false
    }
    
    // Simple linear search
    class func contains<ItemType: Equatable>(list: ItemType[], value: ItemType) -> Bool {
        for item in list {
            if item == value {
                return true
            }
        }
        return false
    }
    
    class func pluck<KeyType: Equatable, ValueType>(list: Array<Dictionary<KeyType, ValueType>>, key: KeyType) -> ValueType[] {
        var result = ValueType[]()
        for item in list {
            if let value = item[key] {
                result += value
            }
        }
        return result
    }
    
    class func max<ItemType: Comparable>(list: ItemType[]) -> ItemType! {
        if list.isEmpty { return nil }
        var max = list[0]
        for item in list {
            if max < item {
                max = item
            }
        }
        return max
    }
    
    class func min<ItemType: Comparable>(list: ItemType[]) -> ItemType! {
        if list.isEmpty { return nil }
        var min = list[0]
        for item in list {
            if min > item {
                min = item
            }
        }
        return min
    }
    
    // quick sort
    class func sortBy<ItemType, CompareType: Comparable>(list: ItemType[], iterator: ItemType -> CompareType) -> ItemType[] {
        if list.isEmpty { return [] }
        
        var smaller = ItemType[]()
        var bigger = ItemType[]()
        
        let first = list[0]
        let length = list.count
        
        for i in 1..length {
            if iterator(first) < iterator(list[i]) {
                bigger += list[i]
            } else {
                smaller += list[i]
            }
        }
        
        var result = sortBy(smaller, iterator: iterator)
        result += first
        result += sortBy(bigger, iterator: iterator)
        
        return result
    }
    
    class func groupBy<ItemType, EquitableType: Equatable>(list: ItemType[], iterator: ItemType -> EquitableType) -> Dictionary<EquitableType, ItemType[]> {
        var result = Dictionary<EquitableType, ItemType[]>()
        
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
    
    class func indexBy<KeyType, ValueType>(list: Array<Dictionary<KeyType, ValueType>>, key: KeyType) -> Dictionary<ValueType,(Dictionary<KeyType,ValueType>)> {
        var result = Dictionary<ValueType, (Dictionary<KeyType,ValueType>)>()
        for item in list {
            result[item[key]!] = item
        }
        return result
    }
    
    class func countBy<ItemType, NameType>(list: ItemType[], iterator: ItemType -> NameType) -> Dictionary<NameType, Int> {
        var result = Dictionary<NameType, Int>()
        for item in list {
            if let count = result[iterator(item)] {
                result[iterator(item)] = count + 1
            } else {
                result[iterator(item)] = 1
            }
        }
        return result
    }
    
    class func shuffle<ItemType>(list: ItemType[]) -> ItemType[] {
        let length = list.count
        var random = Int[]()
        while random.count < length {
            let index: Int = Int(arc4random() % UInt32(length))
            if !self.contains(random, value: index) {
                random += index
            }
        }
        return self.map(random, iterator: {index in list[index]})
    }

}
