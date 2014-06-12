__.swift
========
__.swift aims to be an utility belt for a new programming language by Apple Inc., [Swift](https://developer.apple.com/swift/). And we decided  __.swift to be a clone of [Underscore.js](http://underscorejs.org/), which is an utility belt for JavaScript.

__.swift is a type-safe library because it uses type inference and generics. Therefore, you can write a program without most of the downcasting such as "as" or "as?".

##Example

    __.map([11,22,33]) { x in x * x }
    // [121, 484, 1089]

    __.reduce(["H", "e", "l", "l", "o", " ", "S", "w", "i", "f", "t", " ", "!", "!"], "", + )
    // Hello Swift !!

    func isPrime(n: Int) -> Bool {
      if n < 2 { return false }
      let max = Int(sqrt(Double(n)))
      for i in 2...max {
        if n % i == 0 { return false }
      }
      return true
    }
    __.find([1,33,173,46], isPrime)
    // 173

    __.filter(Array(2..100) , isPrime)
    // [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97]

    let data = [
      ["plan": "walking", "time": "8 a.m."],
      ["plan": "work",    "time": "10 a.m."],
      ["plan": "lunch",   "time": "12 a.m."]
    ]
    __.pluck(data, "plan")
    // [walking, work, lunch]

##Progress
Progression table is available at [wiki](https://github.com/lotz84/__.swift/wiki).

##Altanatives
###[Dollar.swift](https://github.com/ankurp/Dollar.swift)
Awesome functional tool-belt for Swift Language. This is user-friendly with lots of `AnyObject`.

###[Swiftz](https://github.com/maxpow4h/swiftz)
Swiftz is a library for functional programming with purely functional data structures and functions.

##Contributing
Feel free to send a PR or create a new [issue](https://github.com/lotz84/__.swift/issues).

##License
MIT
