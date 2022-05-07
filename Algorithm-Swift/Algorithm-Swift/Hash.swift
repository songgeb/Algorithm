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
        var result: [Int] = []
        for num in nums1 {
            hashMap[num] = 1
        }
        
        for num in nums2 {
            if hashMap[num] != nil {
                result.append(num)
                hashMap[num] = nil
            }
        }
        return result
    }
    // https://leetcode-cn.com/problems/intersection-of-multiple-arrays/
    func intersection1(_ nums: [[Int]]) -> [Int] {
        // K个数组寻找数组的交集
        // 两个数组找完交集后，继续跟下一个数组找交集，直到找到最终的交集
        // 最后对交集进行排序
        //
        // 两个数组找交集的思路是
        // 将数组1中元素放入哈希表中，遍历数组2，如果遇到哈希表中存在的，说明是重复数据，则放入到结果集中
        
        if nums.isEmpty { return [] }
        func intersection(_ nums1: [Int], _ nums2: [Int]) -> [Int] {
            var hashMap: [Int: Int] = [:]
            var result: [Int] = []
            for num in nums1 {
                hashMap[num] = 1
            }
            
            for num in nums2 {
                if hashMap[num] != nil {
                    result.append(num)
                    hashMap[num] = nil
                }
            }
            return result
        }
        
        var result: [Int] = nums[0]
        for i in 1..<nums.count {
            // 从第2个数组开始
            result = intersection(result, nums[i])
        }
        
        return result.sorted()
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
    
    // https://leetcode-cn.com/problems/sum-swap-lcci/
    func findSwapValues(_ array1: [Int], _ array2: [Int]) -> [Int] {
            // 暴力解法是，两层循环遍历两个数组，时间复杂度为O(m*n)
            // 假设array1的和为x，array2的和为y，假设y-x=m
            // 根据题意有另一个推导公式：x - a b b = y - b + a，其中a就是从array1中取出的一个值，b是array2中的一个值
            // 两个公式进行化简为：a - b = m / 2
            // 那么该问题就变成了两数之和/之差类似的问题了
            // 借助哈希表，将array2中的元素放入哈希表中，遍历array1中的元素，看哈希表中是否有a - m/2的值存在，有就返回
            // 该思路算法时间复杂度降为O(m+n)
            var sum1 = 0
            var sum2 = 0
            for num in array1 {
                sum1 += num
            }
            for num in array2 {
                sum2 += num
            }
            let m = sum1 - sum2
            if abs(m) % 2 != 0 { return [] }
            let halfM = m / 2
            var hashMap: [Int: Int] = [:]
            for num in array2 {
                hashMap[num] = 1
            }
            
            for num in array1 {
                let target = num - halfM
                if hashMap[target] != nil {
                    return [num, target]
                }
            }
            return []
        }
    
    /// https://leetcode-cn.com/problems/intersection-of-two-arrays-ii/
    func intersect(_ nums1: [Int], _ nums2: [Int]) -> [Int] {
        // 用nums1构造哈希表，存储[num, num次数]
        // 遍历nums2，如果哈希表中存在值，则加入到结果集中，并且哈希表中该值减一，减到0时在移除
        var result: [Int] = []
        var hashMap: [Int: Int] = [:]
        for num in nums1 {
            if let count = hashMap[num] {
                hashMap[num] = count + 1
            } else {
                hashMap[num] = 1
            }
        }
        
        for num in nums2 {
            if let count = hashMap[num] {
                if count == 1 {
                    hashMap[num] = nil
                } else {
                    hashMap[num] = count - 1
                }
                result.append(num)
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

// https://leetcode-cn.com/problems/lru-cache/
class LRUCache {
    // 双向链表节点
    class DListNode {
        var key: Int
        var val: Int
        var next: DListNode?
        var pre: DListNode?
        
        init(key: Int, val: Int) {
            self.key = key
            self.val = val
            next = nil
            pre = nil
        }
    }
    /// 链表最后一个节点，表示最近使用的节点，头结点表示最久使用的节点
    private var listTail: DListNode?
    private var dummyHead = DListNode(key: Int.min, val: Int.min)
    /// [Key: Node]
    private var data: [Int: DListNode] = [:]
    /// 容量
    private var capacity: Int
    /// 当前缓存的元素数量
    private var count: Int = 0
    
    // 要求get和put的时间复杂度都是O(1)
    init(_ capacity: Int) {
        self.capacity = capacity
        listTail = dummyHead
    }
    
    func get(_ key: Int) -> Int {
        // check当前key是否存在，若不存在则直接返回。否则继续
        // 获取到对应的node，将node放到链表最后，更新tail，返回结果
        guard let node = data[key] else {
            return -1
        }
        moveNodeToTail(node)
        
        return node.val
    }
    
    func put(_ key: Int, _ value: Int) {
        // check当前key是否已经存在，若存在则更新node对应的内容。否则继续
        // 再check缓存有没有满
        // 若没有满，创建node，将node插入到链表尾部，更新tail，数据插入到哈希表中，count+1
        // 若满了，先删除头结点，删除哈希表中的对应key的内容。再执行上面的操作
        if let node = data[key] {
            node.val = value
            moveNodeToTail(node)
            return
        }
        
        if count == capacity {
            // 删除最久远的节点，即头结点
            if let deleteNode = dummyHead.next {
                // check是否需要更新tail
                if deleteNode === listTail {
                    listTail = deleteNode.pre
                }
                dummyHead.next = deleteNode.next
                deleteNode.next?.pre = dummyHead
                data[deleteNode.key] = nil
                count -= 1
            }
        }
        
        // 添加新数据
        let newNode = DListNode(key: key, val: value)
        newNode.pre = listTail
        listTail?.next = newNode
        listTail = newNode
        
        data[key] = newNode
        count += 1
    }
    /// 将节点移到链表尾部，更新使用顺序
    private func moveNodeToTail(_ node: DListNode) {
        if node === listTail { return }
        
        let nodeNext = node.next
        node.pre?.next = nodeNext
        nodeNext?.pre = node.pre
        
        node.pre = listTail
        node.next = listTail?.next
        listTail?.next = node
        
        listTail = node
    }
}
