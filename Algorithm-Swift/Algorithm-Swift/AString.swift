//
//  AString.swift
//  Algorithm-Swift
//
//  Created by songgeb on 2020/5/25.
//  Copyright © 2020 Songgeb. All rights reserved.
//

class AString {
    /// str是模式串
    func getNexts(_ str: String) -> [Int] {
        var nexts: [Int] = [Int].init(repeating: -1, count: str.count)
        var k = -1
        for i in 1..<str.count {
            while k != -1, str[k+1] != str[i] {
                k = nexts[k]
            }
            
            if str[k+1] == str[i] {
                k += 1
            }
            
            nexts[i] = k
        }
        return nexts
    }
}

extension String {
    subscript(i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}

