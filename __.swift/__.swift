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
        list.map {
            item in
            iterator(item)
        }
    }
    
    class func map <ItemType, resultType>(list: ItemType[], iterator: ItemType -> resultType) -> resultType[] {
        return list.map({
                item in
                iterator(item)
            })
    }
    
    class func reduce <ItemType, resultType>(list: ItemType[], iterator: (first:resultType, second:ItemType) -> resultType, memo:resultType) -> resultType{
    
        var result = memo;
        
        self.each(list, {
            item in
            result = iterator(first: result, second: item)
        })
        
        return result;
    }
    
    class func find <ItemType>(list: ItemType[], filter: ItemType -> Bool) -> ItemType? {
        for item in list {
            if filter(item) {
                return item
            }
        }
        return nil;
    }
    
    class func filter <ItemType>(list: ItemType[], filter: ItemType -> Bool) -> ItemType[] {
        var result = ItemType[]()
        for item in list {
            if filter(item) {
                result.append(item)
            }
        }
        return result;
    }

    class func reject<ItemType>(list: ItemType[], filter: ItemType -> Bool) -> ItemType[] {
        var result = ItemType[]()
        for item in list {
            if !filter(item) {
                result.append(item)
            }
        }
        return result;
    }
    
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
    
    class func contains<ItemType: Equatable>(list: ItemType[], value: ItemType) -> Bool {
        var flag: Bool = false;
        for item in list {
            flag = flag || (item == value)
        }
        return flag
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
    
    class func max<ItemType: Comparable>(list: ItemType[]) -> ItemType {
        var max: ItemType?
        for item in list {
            if max {
                if max < item {
                    max = item
                }
            } else {
                max = item
            }
        }
        return max!
    }
    
    class func min<ItemType: Comparable>(list: ItemType[]) -> ItemType {
        var min: ItemType?
        for item in list {
            if min {
                if min > item {
                    min = item
                }
            } else {
                min = item
            }
        }
        return min!
    }
    
    class func sortBy<ItemType, CompareType: Comparable>(list: ItemType[], iterator: ItemType -> CompareType) -> ItemType[] {
        if list.isEmpty { return [] }
        
        var smaller = ItemType[]()
        var bigger = ItemType[]()
        
        let first = list[0]
        let count = list.count
        
        for i in 1..count {
            if iterator(first) < iterator(list[i]) {
                bigger += list[i]
            } else {
                smaller += list[i]
            }
        }
        
        var result = sortBy(smaller, iterator: iterator)
        result += first
        result += sortBy(bigger, iterator: iterator);
        
        return result;
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
    
    class func indexBy<KeyType, ValueType>(list: Array<Dictionary<KeyType, ValueType>>, key: KeyType) -> Dictionary<ValueType, (Dictionary<KeyType,ValueType>)>{
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
            if !contains(random, value: index) {
                random += index
            }
        }
        return map(random, iterator: {index in list[index]})
    }

}
