//
//  IP.swift
//  Algorithm-Swift
//
//  Created by songgeb on 2022/2/15.
//  Copyright © 2022 Songgeb. All rights reserved.
//
// 纯练习熟练度的算法题，不涉及具体的规律和技巧

import Foundation

// MARK: - IPV6
func isValidIPV6Address(_ queryIP: String) -> Bool {
    if queryIP.isEmpty {
        return false
    }
    // 分号分割为几部分，最多不超过8
    // 双冒号不能超过两个
    // 每部分长度在0-4，每个字符是十六进制的数（有大小写）
    let segments = queryIP.split(separator: ":", maxSplits: Int.max, omittingEmptySubsequences: false)
    if (segments.count != 8) {
        return false
    }
    
    for segment in segments {
        if !isValidIPV6Segment(String(segment)) {
            return false
        }
    }
    return true
}

func isValidIPV6Segment(_ segment: String) -> Bool {
    if (segment.isEmpty) { return true }
    if (segment.count > 4) { return false }
    // 有效：2001:0db8:85a3::8A2E:0370:7334
    // 无效：02001:0db8:85a3:0000:0000:8a2e:0370:7334
    // 字母大小写要一致
    var index = segment.startIndex
    while index < segment.endIndex {
        let c = segment[index]
        if (!c.isNumber && (c < "a" || c > "f") && (c < "A" || c > "F")) {
            return false
        }
        index = segment.index(after: index)
    }
    return true
}

// MARK: - IPV4
func isValidIPv4Address(_ queryIP: String) -> Bool {
    // 有效: '12.1.2.3', ' 12. 1. 2.3 '
    // 无效: 'a.1.2.3', '1 2.1.2.3', '', '1.2.3.', '265. 1. 2. 3', "   .1.2.43"
    // 判空
    if (queryIP.isEmpty) {
        return false
    }
    // 是否有4部分
    let segments = queryIP.split(separator: ".")
    if (segments.count != 4) {
        return false
    }
    
    // 判断每一部分是否为大于等于0，小于256的数字
    for segment in segments {
        if !isValidIPSegment(String(segment)) {
            return false
        }
    }
    return true
}

// 判断每一部分是否为大于等于0，小于256的数字
func isValidIPSegment(_ str: String) -> Bool {
    //跳过前面的空格
    var index = str.startIndex
    while index < str.endIndex {
        if str[index] != " " {
            break
        }
        index = str.index(after: index)
    }
    if index == str.endIndex {
        return false
    }
    // 有效：192.0.0.1, 192.0 .0.1
    // 无效：192.01.0.1
    let nextIndex = str.index(after: index)
    if str[index] == "0" && (nextIndex < str.endIndex && str[nextIndex] != " ") {
        return false
    }
    //判断每个字符是否为数字，是数字则计算值
    var numValue = 0
    while index < str.endIndex {
        let c = str[index]
        if c.isNumber, let cNumValue = c.wholeNumberValue {
            numValue = numValue * 10 + cNumValue
            if (numValue > 255) {
                return false
            }
        } else {
            return false
        }
        index = str.index(after: index)
    }
    
    // 处理后置空格
    while index < str.endIndex {
        if (str[index] != " ") {
            return false
        }
    }
    return true
}

func defangIPaddr(_ address: String) -> String {
    // 遍历每个字符，遇到句号，就添加[.]
    var result = ""
    for c in address {
        if (c == ".") {
            result.append("[.]")
        } else {
            result.append(c)
        }
    }
    return result
}

// MARK: - two sum
func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
    // 从第i个开始（i从0开始），计算target - i 是否在i+1-end中
    // 如果存在则返回[i, j]
    // 时间复杂度为O(n^2)
    for (i, v1) in nums.enumerated() {
        let v2 = target - v1
        for j in (i+1..<nums.count) {
            if (nums[j] == v2) {
                return [i, j]
            }
        }
    }
    return []
}

func twoSum1(_ nums: [Int], _ target: Int) -> [Int] {
    // 从第i个开始（i从0开始），计算target - i 是否在i+1-end中
    // 如果存在则返回[i, j]
    // 时间复杂度为O(n^2)
    for (i, v1) in nums.enumerated() {
        let v2 = target - v1
        for j in (i+1..<nums.count) {
            if (nums[j] == v2) {
                return [i, j]
            }
        }
    }
    return []
}

// MARK: - reverse string
func reverseString(_ s: inout [Character]) {
    // 创建两个指针，一个(startIndex)从起始位置开始，往后移动，另一个在要交换的位置，从后往前移动
    // 直到startIndex >= endIndex
    // 空字符情况
    if (s.isEmpty || s.count == 1) { return }
    var starIndex = 0
    var endIndex = s.count - 1
    while starIndex < endIndex {
        s.swapAt(starIndex, endIndex)
        starIndex += 1
        endIndex -= 1
    }
}
// 输入： s = "God Ding"
// 输出："doG gniD"
func reverseWords(_ s: String) -> String {
    // 原地反转
    // 从前往后遍历，遇到空格，则遍历结束了一个单词，对该单词进行反转
    // 直到结束
    // 一前一后两个index，preIndex表示单词的开始，lastIndex表示单词的结束
    // lastIndex遇到空格或者遇到最后时，表示单词结束了。然后反转单词
    // 反转完单词后，lastIndex++，preIndex=lastIndex
    var chars = Array(s)
    var lastIndex = 0
    var preIndex = 0
    let count = s.count
    while lastIndex < count {
        while lastIndex < count && chars[lastIndex] != " " {
            lastIndex += 1
        }
        
        // 原地反转单词
        var s = preIndex
        var e = lastIndex - 1
        while s < e {
            chars.swapAt(s, e)
            s += 1
            e -= 1
        }
        
        lastIndex += 1
        preIndex = lastIndex
    }
    return String(chars)
}

/// 验证回文串
/// 只考虑字母和数字，不考虑大小写
func isPalindrome(_ s: String) -> Bool {
    // 定义一个内部方法，判断要判断的字符是否符合条件
    // 前后两个指针，check两个字符是否符合条件，如果都符合条件，则比较字符是否相等（统一转成小写）
    // 相等则两个指针继续向中间靠拢，知道两个指针相遇
    
    func isLetter(_ c: Character) -> Bool {
        return ("a" <= c && c <= "z") || ("A" <= c && c <= "Z")
    }
    func isValidCharacter(_ c: Character) -> Bool {
        if (c.isNumber) {
            return true
        }
        return isLetter(c)
    }
    let chars = Array(s)
    var pre = 0
    var last = chars.count - 1
    while pre < last {
        var preChar = chars[pre]
        var lastChar = chars[last]
        let isPreValid = isValidCharacter(preChar)
        let isLastValid = isValidCharacter(lastChar)
        if (isPreValid && isLastValid) {
            if (isLetter(preChar)) {
                preChar = Character(preChar.lowercased())
                lastChar = Character(lastChar.lowercased())
            }
            if (preChar == lastChar) {
                pre += 1
                last -= 1
            } else {
                return false
            }
        } else if (isPreValid) {
            last -= 1
        } else if (isLastValid) {
            pre += 1
        } else {
            pre += 1
            last -= 1
        }
    }
    return true
}

/// 是否为回文数
func isPalindrome(_ x: Int) -> Bool {
    // 比上面的更容易些
    // 转成字符串比较简单
    let chars = Array("\(x)")
    var pre = 0
    var last = chars.count - 1
    while pre < last {
        if (chars[pre] != chars[last]) {
            return false
        }
        pre += 1
        last -= 1
    }
    return true
}

func lengthOfLastWord(_ s: String) -> Int {
    // 从后往前遍历
    // 先过滤掉空格，然后找出最后一个单词的长度
    if (s.isEmpty) {
        return 0
    }
    var lastWordLength = 0
    let chars = Array(s)
    var index = chars.count - 1
    while index >= 0 && chars[index] == " " {
        index -= 1
    }
    if (index < 0) {
        return 0
    }
    while index >= 0 && chars[index] != " " {
        lastWordLength += 1
        index -= 1
    }
    return lastWordLength
}

// https://leetcode-cn.com/problems/zuo-xuan-zhuan-zi-fu-chuan-lcof/
// 左旋转字符串
func reverseLeftWords(_ s: String, _ n: Int) -> String {
    let charCount = s.count
    if (n < 0 || n > charCount) { return s }
    // 可以通过计算，知道每个字符串最终的位置
    // 所以可以申请一个字符数组，然后填内容就好了
    // 异常输入
    var chars: [Character] = Array(repeating: " ", count: charCount)
    for (index, char) in s.enumerated() {
        let targetIndex = (index - n) < 0 ? (index - n) + charCount : (index - n)
        chars[targetIndex] = char
    }
    return String(chars)
}

// https://leetcode-cn.com/problems/remove-duplicates-from-sorted-array/
// 升序数组，原地删除重复元素，返回新数组长度
// 不能使用额外空间
func removeDuplicates(_ nums: inout [Int]) -> Int {
    // [3,3,3,3,4,4,4,5,5,5]
    // 有一个指针，表示最终结果集中最后一个元素的index
    // 遍历每个元素，如果当前元素和已经插入的元素的最后一个相等，则继续；否则插入
    if (nums.isEmpty) { return 0 }
    var endIndex = 0
    for value in nums {
        if (nums[endIndex] != value) {
            nums[endIndex + 1] = value
            endIndex += 1
        }
    }
    return endIndex + 1
}
