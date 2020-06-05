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
    
    /// leetcode-1297.子串的最大出现次数
    /// 给你一个字符串 s ，请你返回满足以下条件且出现次数最大的 任意 子串的出现次数：
    /// 子串中不同字母的数目必须小于等于 maxLetters 。
    /// 子串的长度必须大于等于 minSize 且小于等于 maxSize 。
    ///
    /// - 输入：s = "aababcaab", maxLetters = 2, minSize = 3, maxSize = 4
    /// - 输出：2
    /// - 解释：子串 "aab" 在原字符串中出现了 2 次。
    /// 它满足所有的要求：2 个不同的字母，长度为 3 （在 minSize 和 maxSize 范围内）。
    /// - Parameters:
    ///   - s:
    ///   - maxLetters:
    ///   - minSize:
    ///   - maxSize:
    /// - Returns:
    func maxFreq(_ s: String, _ maxLetters: Int, _ minSize: Int, _ maxSize: Int) -> Int {
        // 思路1: 暴力搜索
        // 1. 先找出所有满足条件的模式串 patterns
        // 2. 然后在原字符串每一个字符进行匹配并计数
        
        // 找模式串
        // 从minSize到maxSize一个循环，每个循环内部有一个从第一个字符到最后一个字符的循环
        // 内层还有个while循环，while循环的条件是只要没有到字符串结束
        // 具体工作是读取size的字符，先检测不同字符数是否满足条件，若不满足则继续，若满足则放入patterns中
        
        // 在原字符串每个字符进行匹配并计数
        
        var patterns: Set<Substring> = []
        for size in minSize...maxSize {
            for index in s.indices {
                // 记录不同字符数
                var set: Set<Character> = []
                if let end = s.index(index, offsetBy: size - 1, limitedBy: s.index(before: s.endIndex)) {
                    let substr = s[index...end]
                    for c in substr {
                        set.insert(c)
                    }
                    
                    if set.count <= maxLetters {
                        patterns.insert(substr)
                    }
                }
            }
        }
        
        var patternCounts: [Substring: Int] = [:]
        for pattern in patterns {
            for start in s.indices {
                if let end = s.index(start, offsetBy: pattern.count - 1, limitedBy: s.index(before: s.endIndex)) {
                    if pattern == s[start...end] {
                        if let _ = patternCounts[pattern] {
                            patternCounts[pattern] = patternCounts[pattern]! + 1
                        } else {
                            patternCounts[pattern] = 1
                        }
                    }
                }
            }
        }
        guard let xx = patternCounts.max(by: { (a, b) -> Bool in
            return a.value < b.value
        }) else {
            return 0
        }
        return xx.value
    }
    
    func maxFreq1(_ s: String, _ maxLetters: Int, _ minSize: Int, _ maxSize: Int) -> Int {
        // maxSize其实是多余的条件，只用care minSize
        // 基于上面的代码我们进一步优化，因为只需要直到最后的次数，所以我们在获取模式串的过程中已经可以计数了
        // 所以最终优化的思路是，获取满足maxLetters和minSize的模式串，同时计数
        // 翻译成代码
        // 对每一个字符来说，寻找minSize大小的模式串
        // for 每一个字符的index
        var maxCount = 0
        var patterns: [Substring: Int] = [:]
        for start in s.indices {
            var set: Set<Character> = []
            if let end = s.index(start, offsetBy: minSize - 1, limitedBy: s.index(before: s.endIndex)) {
                let subStr = s[start...end]
                
                for c in subStr {
                    set.insert(c)
                }
                
                if set.count <= maxLetters {
                    if let value = patterns[subStr] {
                        patterns[subStr] = value + 1
                        maxCount = max(value + 1, maxCount)
                    } else {
                        patterns[subStr] = 1
                        maxCount = max(maxCount, 1)
                    }
                }
            }
        }
        print(patterns)
        return maxCount
    }
    /// 当然此问题还可以使用位操作来解答---直接看Bit.swift文件吧
    func maxFreq2(_ s: String, _ maxLetters: Int, _ minSize: Int, _ maxSize: Int) -> Int {
        return 0
    }
}

extension String {
    subscript(i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}

