//
//  Other.swift
//  Algorithm-Swift
//
//  Created by songgeb on 2020/5/18.
//  Copyright © 2020 Songgeb. All rights reserved.
//


class Other {
    /// ip字符串转为Int
    /// ip的每一部分都可以用32位的二进制数表示，因为ip最大不超过255
    /// 基本思路时，拆分ip的每一部分出来，转为Int类型，左移相应的位数
    /// 每一部分的二进制做或运算
    func ipToInt(_ ipStr: String) -> Int? {
        let nums = ipStr.split(separator: ".").compactMap({ Int.init($0) })
        if nums.count == 0 { return nil }
        var result: Int = 0
        for (index, num) in nums.enumerated() {
            result |= num << ((3 - index) * 8)
        }
        return result
    }
    
    /// 给一个整数，解析成ip
    /// 和ipToInt相反
    /// 通过&，分出整型中每一部分ip地址
    ///
    /// - Parameter num: <#num description#>
    /// - Returns: <#return value description#>
    func intToIPStr(_ num: Int) -> String? {
        var ipStr: [String] = []
        for index in 0...3 {
            let offset = (3 - index) * 8
            let ipSegment = (num & (255 << offset)) >> offset
            ipStr.append("\(ipSegment)")
        }
        if ipStr.count == 0 { return nil }
        return ipStr.joined(separator: ".")
    }
    // leetcode-443
    func compress(_ chars: inout [Character]) -> Int {
        if chars.count == 1 { return 1 }
        // 一个cur下标表示当前字符
        // 一个counter，计数用
        // 一个pre下标，记录上一个字符
        // 还一个i，表示替换位置
        // 开始cur = i = 1，pre = 0
//        var pre, cur, i, counter: Int
//        pre = 0
//        cur = 1
//        i = 0
//        counter = 1
//
//        while cur <= chars.count {
//            if cur < chars.count, chars[cur] == chars[pre] {
//                counter += 1
//            } else {
//                chars[i] = chars[pre]
//                if counter > 1 {
//                    // 替
//                    i += 1
//                    let counterStr = "\(counter)"
//                    for j in counterStr {
//                        chars[i] = j
//                        i += 1
//                    }
//                } else {
//                    i += 1
//                }
//                counter = 1
//            }
//            cur += 1
//            pre += 1
//        }
//        return i
        
        //更优雅的实现（主要是针对上面代码比较繁琐的情况进行优化，参考了其他人Swift的实现）
        // 通过for循环遍历每个字符，循环中，仅当当前元素和下个元素不同时才做处理
        // 具体处理是：替换元素，
        // 1. 先替换字符元素，需要一个write变量，标记要替换的位置
        // 2. 再替换数字，需要一个变量start，来记录当前压缩字符段的开始位置，通过i - start + 1来求得重复字符个数len，当个数大于1，才替换数字，否则仅第1不的元素替换就够了
        // 对于i走到头的情况要特殊考虑，要做的工作也是上面的1和2
        
        var write = 0
        var start = 0
        for i in chars.indices {
            if i == chars.count - 1 || chars[i] != chars[i+1] {
                chars[write] = chars[i]
                write += 1
                let len = i - start + 1
                if len > 1 {
                    for c in String(len) {
                        chars[write] = c
                        write += 1
                    }
                }
                start = i + 1
            }
        }
        return write
    }
}
