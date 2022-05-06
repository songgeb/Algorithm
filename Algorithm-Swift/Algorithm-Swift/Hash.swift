//
//  Hash.swift
//  Algorithm-Swift
//
//  Created by songgeb on 2022/5/5.
//  Copyright © 2022 Songgeb. All rights reserved.
//

import Foundation

class Hash {
    // https://leetcode-cn.com/problems/3sum/
    func threeSum(_ nums: [Int]) -> [[Int]] {
        // 暴力解法，三种for循环，时间复杂度O(n^3)
        // 每层for循环确定一个数
        var result: [[Int]] = []
        let count = nums.count
        if count < 3 { return [] }
        for i in 0..<count {
            for j in i+1..<count {
                for k in j+1..<count {
                    if nums[i] + nums[j] + nums[k] == 0 {
                        let tmpResult = [nums[i], nums[j], nums[k]].sorted()
                        if !result.contains(tmpResult) {
                            result.append(tmpResult)
                        }
                    }
                }
            }
        }
        return result
    }
    
    func threeSum1(_ nums: [Int]) -> [[Int]] {
        // 使用哈希表，将时间复杂度降低到O(n^2)
        // 使用哈希表是一个难点，另一个难点是如何排除重复的情况
        // 重复有两种情况
        // 1. 一个元素不能使用多次，比如原数组是[1,2,3]，结果集中，任何一个元素都不能使用多次
        // 2. 结果集中的三元组不能重复，比如[1,2,3]和[3,2,1]在最终结果集中被认为是相同的
        // 下面说一下该问题的求解思路
        // 将元素值作为key，value=key出现次数存入哈希表中
        // 用i遍历数组，用j遍历数组，将i和j从哈希表中减掉，
        // 判断0-i-j是否在哈希表中，存在则拿到一个结果元祖；排序放入结果集合中
        // 遍历结束后，将i和j加回到哈希表中
        // 最后，其实该问题并不太适合用哈希表来实现，双指针实现更高效一些
        var result: Set<[Int]> = []
        var hashMap: [Int:Int] = [:]
        let count = nums.count
        if count < 3 { return [] }
        
        for v in nums {
            if let tmp = hashMap[v] {
                hashMap[v] = tmp + 1
            } else {
                hashMap[v] = 1
            }
        }
        
        for i in 0...count-3 {
            if let tmpI = hashMap[nums[i]] {
                if tmpI == 1 {
                    hashMap[nums[i]] = nil
                } else {
                    hashMap[nums[i]] = tmpI - 1
                }
            }
            
            for j in i+1...count-2 {
                let t = 0 - nums[i] - nums[j]
                
            }
        }
        return []
    }
    
    // https://leetcode-cn.com/problems/check-permutation-lcci/
    func CheckPermutation(_ s1: String, _ s2: String) -> Bool {
        // 方法1：一个哈希表
        // 先遍历一遍s1，将数据放进去
        // 再遍历一遍s2，将数据取出来
        // 看哈希表最终是否为空
        // 方法1时间复杂度为O(m+n)，空间复杂度为O(m+n)
        // 方法2：给两个s排序，排好序之后挨个字符比较即可
        
        var hashMap: [Character:Int] = [:]
        for c in s1 {
            if let num = hashMap[c] {
                hashMap[c] = num + 1
            } else {
                hashMap[c] = 1
            }
        }
        
        for c in s2 {
            if let num = hashMap[c] {
                if num == 1 {
                    hashMap[c] = nil
                } else {
                    hashMap[c] = num - 1
                }
            } else {
                return false
            }
        }
        return hashMap.isEmpty
    }
    // https://leetcode-cn.com/problems/intersection-of-two-linked-lists/
    func getIntersectionNode(_ headA: ListNode?, _ headB: ListNode?) -> ListNode? {
        // 一个哈希表，现将a的节点放入哈希表
        // 遍历B时，遇到第一个已经存在于哈希表中的节点，则表示两链表有相交
        var hashMap: [ObjectIdentifier: Int8] = [:]
        var p = headA
        while let node = p {
            hashMap[ObjectIdentifier(node)] = 1
            p = p?.next
        }
        
        p = headB
        while let node = p {
            if hashMap[ObjectIdentifier(node)] != nil {
                return node
            }
            p = p?.next
        }
        return nil
    }
    
    // https://leetcode-cn.com/problems/remove-duplicate-node-lcci/
    func removeDuplicateNodes(_ head: ListNode?) -> ListNode? {
        // 一个哈希表，存放node
        // 遍历整个链表，如果当前节点存在于哈希表中，则跳过；如果不在哈希表中，则插入到新链表中，同时将该节点放入哈希表中
        // 还有一种链表的构建方法，不是创建dummyHead通过插入节点实现，而是类似有个指针，一边遍历链表，一遍修改链表的指针
        // 下个方法对方法2进行实现，比较一下两种实现哪个更好
        let dummyHead = ListNode(-1)
        dummyHead.next = head
        var tail: ListNode? = dummyHead
        
        var hashMap: [Int: Int] = [:]
        
        var p = head
        while let node = p {
            if hashMap[node.val] != nil {
                p = p?.next
            } else {
                p = p?.next
                node.next = nil
                tail?.next = node
                tail = tail?.next
                hashMap[node.val] = 1
            }
        }
        return dummyHead.next
    }
    
    func removeDuplicateNodes1(_ head: ListNode?) -> ListNode? {
        // 一个哈希表，存放node
        // 遍历整个链表，如果当前节点存在于哈希表中，则跳过；如果不在哈希表中，则插入到新链表中，同时将该节点放入哈希表中
        // 还有一种链表的构建方法，不是创建dummyHead通过插入节点实现，而是类似有个指针，一边遍历链表，一遍修改链表的指针
        // 我们来实现一下方法2
        // 使用p表示当前节点，用于遍历整个链表；pre表示当前节点的前一个节点
        // 当需要跳过时，则将pre.next = p.next，就完成了跳过
        // 不需要跳过时，则将p存入到哈希表中
        // 本体遍历链表时，可以从第二个节点开始
        if head == nil { return head }
        var pre = head
        var p = pre?.next
        var hashMap: [Int: Int] = [:]
        hashMap[head!.val] = 1
        while let node = p {
            if hashMap[node.val] != nil {
                // 跳过
                p = p?.next
                pre?.next = p
            } else {
                // 放入哈希表中
                hashMap[node.val] = 1
                p = p?.next
                pre = pre?.next
            }
        }
        return head
    }
    
    // https://leetcode-cn.com/problems/shu-zu-zhong-zhong-fu-de-shu-zi-lcof/
    func findRepeatNumber(_ nums: [Int]) -> Int {
        // 寻找任意一个重复的数字
        // 一个哈希表，一边遍历一遍放入哈希表中
        var hashMap: [Int: Bool] = [:]
        for num in nums {
            if hashMap[num] != nil {
                return num
            }
            hashMap[num] = true
        }
        return Int.min
    }
    
    // https://leetcode-cn.com/problems/group-anagrams/
    func groupAnagrams(_ strs: [String]) -> [[String]] {
        // 用一个哈希表存放不同的单词和最终该单词将落到结果集中的下标[String: Int]
        // 遍历整个字符串数组，对于每一个字符串
        // 判断哈希表中是否已经有该单词了，如果有，则找到对应的下标，放入结果集中
        // 如果没有，则将该单词排序后放入哈希表中，下标值注意要有一个全局变量wordIndex来控制。同时该单词要放入结果集中
        // 特殊情况：空字符串数组时，没问题
        // 时间复杂度O(n)
        var result: [[String]] = []
        var wordIndex = 0
        var hashMap: [String: Int] = [:]
        for str in strs {
            let sortedStr = String(str.sorted())
            if let index = hashMap[sortedStr] {
                result[index].append(str)
            } else {
                hashMap[sortedStr] = wordIndex
                result.append([str])
                wordIndex += 1
            }
        }
        return result
    }
    // https://leetcode-cn.com/problems/single-number/
    func singleNumber(_ nums: [Int]) -> Int {
        var hashMap: [Int: Int] = [:]
        for num in nums {
            if hashMap[num] != nil {
                hashMap[num] = nil
            } else {
                hashMap[num] = 1
            }
        }
        if let n = hashMap.keys.first {
            return n
        }
        return Int.max
    }
    // https://leetcode-cn.com/problems/intersection-of-two-arrays/
    func intersection(_ nums1: [Int], _ nums2: [Int]) -> [Int] {
        var hashMap: [Int: Int] = [:]
        var result: Set<Int> = []
        for num in nums1 {
            hashMap[num] = 1
        }
        
        for num in nums2 {
            if hashMap[num] != nil {
                result.insert(num)
            }
        }
        return Array(result)
    }
    
    // https://leetcode-cn.com/problems/relative-sort-array/
    func relativeSortArray(_ arr1: [Int], _ arr2: [Int]) -> [Int] {
        // 将arr1中每个元素按照[num: 次数]的格式放入哈希表中
        // 遍历arr2，产生第一部分结果，同时从哈希表中删除数据
        // 将哈希表中剩余的数据进行排序放入到结果集中，产生第二部分结果
        var result: [Int] = []
        var hashMap: [Int: Int] = [:]
        
        for num in arr1 {
            if let count = hashMap[num] {
                hashMap[num] = count + 1
            } else {
                hashMap[num] = 1
            }
        }
        
        // 第一部分结果
        for num in arr2 {
            if let count = hashMap[num] {
                for _ in 0..<count {
                    result.append(num)
                }
                hashMap[num] = nil
            }
        }
        // 第二部分结果
        let keys = hashMap.keys.sorted()
        for num in keys {
            if let count = hashMap[num] {
                for _ in 0..<count {
                    result.append(num)
                }
            }
        }
        return result
    }
}

class WordsFrequency {
    private var words: [String: Int] = [:]
    init(_ book: [String]) {
        for word in book {
            if let num = words[word] {
                words[word] = num + 1
            } else {
                words[word] = 1
            }
        }
    }
    
    func get(_ word: String) -> Int {
        return words[word] ?? 0
    }
}
/// 自定义hashmap
class MyHashMap {
    class Pair {
        let key: Int
        var value: Int
        var next: Pair?
        init(key: Int, value: Int) {
            self.key = key
            self.value = value
            next = nil
        }
    }
    // 使用拉链法解决哈希冲突
    private static let slotCount = 1000
    private var data = Array<Pair?>(repeating: nil, count: slotCount)
    init() {
    }
    
    func put(_ key: Int, _ value: Int) {
        // 有相同key的进行覆盖，没有相同key的则加入
        let index = hashFunction(key: key)
        let head = data[index]
        if head == nil {
            let pair = Pair(key: key, value: value)
            data[index] = pair
        } else {
            var p = head
            while p != nil {
                if p?.key == key {
                    p?.value = value
                    return
                }
                p = p?.next
            }
            // 哈希表中不存在相同key，加入新节点
            let pair = Pair(key: key, value: value)
            pair.next = head
            data[index] = pair
        }
    }
    
    func get(_ key: Int) -> Int {
        // 获取到hash，遍历链表寻找相同key的节点
        let index = hashFunction(key: key)
        let head = data[index]
        var p = head
        while let node = p {
            if node.key == key {
                return node.value
            }
            p = p?.next
        }
        return -1
    }
    
    func remove(_ key: Int) {
        // 获取到hash，遍历链表删除相同key的节点
        let index = hashFunction(key: key)
        let head = data[index]
        if head?.key == key {
            data[index] = head?.next
        } else {
            var pre = head
            var p = pre?.next
            while let node = p {
                if node.key == key {
                    pre?.next = node.next
                }
                p = p?.next
                pre = pre?.next
            }
        }
    }
    
    private func hashFunction(key: Int) -> Int {
        return key % MyHashMap.slotCount
    }
}
