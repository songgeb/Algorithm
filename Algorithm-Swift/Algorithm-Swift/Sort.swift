//
//  Sort.swift
//  Algorithm-Swift
//
//  Created by songgeb on 2019/8/8.
//  Copyright © 2019 Songgeb. All rights reserved.
//

import Foundation

// 排序


/// 冒泡
/// 拿从小到大排序来说，冒泡是，一次一次的将最大的沉底，或将最小的上浮，最终实现排序
/// 如何沉底呢？要有比较和交换的操作，相邻两个元素比较，大的交换到后面
/// 一共执行n次（每个元素都冒一次泡），每一次要进行比较的元素在变少，第一次是比较n个，第二次的话，最后一个元素已经排好了，只需要比较剩下的n-1个就行了，a[j]和a[j+1]进行比较，若a[j] > a[j+1]就交换
///
/// - Parameter array:
func bubbleSort(_ array: inout [Int]) {
  let length = array.count
  for i in stride(from: 0, to: length, by: 1) {
    var flag = false
    // 开启本次冒泡
    for j in stride(from: 1, to: length - i, by: 1) {
      // 沉底
      if array[j] < array[j-1] {
        let tmp = array[j-1]
        array[j-1] = array[j]
        array[j] = tmp
        flag = true
      }
    }
    // 本次冒泡没有任何交换，说明已经排好序了
    if !flag { break }
  }
}

/// 插入排序，核心思想是插入
/// 如何插入、往哪插入是关键。从前往后插入，插到合适的位置，插入的这些元素成为有序区
///
/// - Parameter array:
func insertionSort(_ array: inout [Int]) {
  if array.count <= 1 { return }
  let length = array.count
  for i in stride(from: 1, to: length, by: 1) {
    let insertValue = array[i]
    var insertIndex = i
    for j in stride(from: i - 1, to: -1, by: -1) {
      if insertValue < array[j] {
        array[j+1] = array[j]
        insertIndex = j
      } else {
        break
      }
    }
    
    array[insertIndex] = insertValue
  }
}

/// 选择排序
/// 选择啥呢？冒泡算法也是选择啊，每次选择最大的沉底也叫选择排序啊，为啥那个叫冒泡算法，这个就叫做选择排序呢？
func selectionSort(_ array: inout [Int]) {
  // 对于数组中每个元素，每次选择一个最小的，放到相应的位置
  let length = array.count
  for i in stride(from: 0, to: length, by: 1) {
    var minIndex = i
    
    for j in stride(from: i + 1, to: length, by: 1) {
      if array[j] < array[minIndex] {
        minIndex = j
      }
    }
    
    // 交换minIndex和i
    let tmp = array[minIndex]
    array[minIndex] = array[i]
    array[i] = tmp
  }
}

/// 归并排序
/// 分治思想，一个无序的数组，分成两半，对左右两半递归的分下去，最终子问题就变成了只剩下一个元素
/// 对每次递归分出来的两半数组进行合并排序
/// 合并排序，要借助新的数组，将排序的元素放到新数组中，拍好后，拷贝到原数组
func mergeSort(_ array: inout [Int], start: Int, end: Int) {
  if start >= end {
    return
  }
  // 将start...half 和 (half+1)...end 合并到start...end中
  func merge(_ array: inout [Int], start: Int, end: Int, half: Int) {
    let tmpLength = end - start + 1
    var tmpArray = Array(repeating: 0, count: tmpLength)
    
    var lIndex = start
    var rIndex = half + 1
    var cIndex = 0
    while lIndex <= half && rIndex <= end {
      let l = array[lIndex]
      let r = array[rIndex]
      if l < r {
        tmpArray[cIndex] = l
        lIndex += 1
      } else {
        tmpArray[cIndex] = r
        rIndex += 1
      }
      cIndex += 1
    }
    
    while lIndex <= half {
      tmpArray[cIndex] = array[lIndex]
      lIndex += 1
      cIndex += 1
    }
    
    while rIndex <= end {
      tmpArray[cIndex] = array[rIndex]
      rIndex += 1
      cIndex += 1
    }
    
    cIndex = 0
    for index in start...end {
      array[index] = tmpArray[cIndex]
      cIndex += 1
    }
  }
  
  let half = (end + start) / 2
  mergeSort(&array, start: start, end: half)
  mergeSort(&array, start: half + 1, end: end)
  merge(&array, start: start, end: end, half: half)
}

/// 快速排序
/// 为什么快？
func quickSort(_ array: inout [Int], start: Int, end: Int) {
  print("开始点->\(start), 结束点->\(end)")
  if start >= end {
    print("本次作废")
    return
  }
  print("分解前->\(array)")
  let point = partition2(&array, start: start, end: end)
  print("分解后的点是->\(point)")
  print("此时数组->\(array)")
  quickSort(&array, start: start, end: point - 1)
  quickSort(&array, start: point, end: end)
}


/// 最简单暴力的方法
///
func partition() {
  
}

/// 原地分区函数，将一个数组按照某个值pivot，分成小于pivot、等于pivot和大于pivot三个区域
/// 两个指针从前往后
func partition1(_ array: inout [Int], start: Int, end: Int) -> Int {
  if start < 0 || end < 0 || array.count < 2 { return -1 }
  if start >= end { return -1 }
  
  // 两个指针，i、j
  // 选择第一个元素作为pivot
  // <= i的元素是比pivot小或相等的
  // > i小于j的元素是比pivot大的，> j的元素是未知的
  // i从0开始，j从i的下一个开始
  // j往后移动，如果遇到
  return -1
}

/// 两个指针一前一后
func partition2(_ array: inout [Int], start: Int, end: Int) -> Int {
  if start < 0 || end < 0 { return -1 }
  if start > end { return -1 }
  if start == end { return start }
  //pivot可以选择第一个或者最后一个
  //i指向开始，j指向结尾
  // 从任意一头开始，比如从i这一头，如果元素小于piovt则前进， 大于等于pviot，则停止；注意不能超过j
  // 从j开始，如果元素大于等于pivot，则往左前进，小于pivot时则停止；注意j不能小于i
  // 此时如果i<j，则说明位置的元素大于等于pivot，j位置的元素小于pivot；对这两个元素进行交换
  // 最后要注意，到最后i会和j重合，如果先从左边开始扫描的，，此时i的位置是大于pivot的。所以此时如果选择数组第一个元素作为pivot的话，然后直接将位置的值和pivot交换的话，就不对了。
  // 所以，如果选择数组第一个元素作为pivot，那应该先从右向左扫描，这样最终的i、j位置的值就是小于pivot，此时再交换位置的值和pivot的值就牟问题了。或者，选择元素最后一个作为pivot的话，就可以先从左到右扫描了
  
  // 还有，pivot所在的位置除了最后的交换，其余不能被赋值或者说不能被挪动
  // 所以要求，从左往右扫描时，得用array[i] <= pivot的判断条件，否则pivot会被挪走
  let pivot = array[start]
  var i = start
  var j = end
  while i != j {
    
    while i < j && array[i] <= pivot {
      i += 1
    }
    
    while i < j && array[j] > pivot {
      j -= 1
    }
    
    if i < j {
      let tmp = array[i]
      array[i] = array[j]
      array[j] = tmp
    }
  }
  
  array[start] = array[j]
  array[j] = pivot
  return j
}

class Sort {
  static func testBubbleSort() {
    // 生成随机数组
    var array = (0...10).map {
      Int.random(in: $0...100)
    }
    print("原数组->\(array)")
    bubbleSort(&array)
    print(array)
  }
  
  static func testInsertionSort() {
    // 生成随机数组
    var array = (0...10).map {
      Int.random(in: $0...100)
    }
    print("原数组->\(array)")
    insertionSort(&array)
    print(array)
  }
  
  static func testSelectionSort() {
    // 生成随机数组
    var array = (0...0).map {
      Int.random(in: $0...100)
    }
    print("原数组->\(array)")
    selectionSort(&array)
    print(array)
  }
  
  static func testMergeSort() {
    var array = (0...10).map {
      Int.random(in: $0...100)
    }
    print("原数组->\(array)")
    mergeSort(&array, start: 0, end: array.count - 1)
    print(array)
  }
  
  static func testPartition() {
    var array = (0...10).map { (value) -> Int in
      value + 1
      return Int.random(in: 1...100)
    }
    array = [13, 63, 1, 21, 20, 2, 37, 46, 9, 13]
//    array = [3, 7, 8, 1, 4, 10, 2, 5, 6, 9]
    print("原数组->\(array)")
//    quickSort(&array, start: 0, end: array.count - 1)
    let result = partition2(&array, start: 0, end: array.count - 1)
    print(array)
    print(result)
  }
    
    /// https://leetcode-cn.com/problems/kth-largest-element-in-an-array/
    func findKthLargest(_ nums: [Int], _ k: Int) -> Int {
        // 快排的划分方法 + 递归
        // 反复执行划分逻辑，直到划分出来的index==k-1
        var newNums = nums
        func partition(_ left: Int, _ right: Int) -> Int {
            // 按照由大到小进行划分，左边大右边小
            // 取最右边的值作为pivot
            if left >= right { return left }
            let pivot = newNums[right]
            var i = left
            for j in left...right {
                if newNums[j] > pivot {
                    if i != j {
                        newNums.swapAt(i, j)
                    }
                    i += 1
                }
            }
            
            newNums.swapAt(i, right)
            return i
        }
        
        func r(_ left: Int, _ right: Int) {
            let index = partition(left, right)
            if index == k - 1 {
                return
            } else if index > k - 1 {
                r(left, index-1)
            } else {
                r(index+1, right)
            }
        }
        r(0, newNums.count - 1)
        return newNums[k-1]
    }
}

func sb_merge(_ array: [Int], p: Int, q: Int, r: Int) -> [Int] {
  var i = p
  var j = r + 1
  var tmp = Array(repeating: 0, count: 10)
  var index = 0
  while i <= r && j <= q {
    let left = array[i]
    let right = array[j]
    if left <= right {
      tmp.append(left)
      i += 1
    } else {
      tmp.append(right)
      j += 1
    }
    index += 1
  }
  
  while i <= r {
    tmp.append(array[i])
    i += 1
    index += 1
  }
  
  while j <= q {
    tmp.append(array[j])
    j += 1
    index += 1
  }
  
  return tmp
}

func testMergeFunction() {
  let array = [4, 8, 12, 21, 30, 2, 3, 8, 19]
  
  let result = sb_merge(array, p: 0, q: 8, r: 4)
  print(result)
}


class SolutionS {
    func sortArray(_ nums: [Int]) -> [Int] {
        if nums.count <= 1 { return nums }
        // 准备用插入排序实现一把
        // 所谓插入排序，即从数组第二个开始遍历，认为前面的都是排好序的区域，将每个遍历的元素插入到前面有序的序列中
        // 第一层遍历从第1个元素(c)开始，从前往后，对于这个元素，内层遍历是，从它前面一个元素p开始从后往前遍历
        // 一旦遇到c < p，则将p往后移
        // 内层循环结束后，位置也移动好了，将c放到新位置
        // for i in stride(from: 1, to: nums.count, by: 1) {
        //     let c = nums[i]
        //     var cTargetIndex = i
        //     for j in stride(from: i - 1, to: -1, by: -1) {
        //         let p = nums[j]
        //         if c < p {
        //             nums[j+1] = p
        //             cTargetIndex = j
        //         } else {
        //             break
        //         }
        //     }
        //     nums[cTargetIndex] = c
        // }
        // return nums

        // 使用归并排序排一把
        // 归并核心思想是分治，如何分治，怎么分，一分为二，然后合并，递归的一分为二，直到无法分为止
        // 递推公式是：mergeSort([p, r]) = mergeSort(p, q) merge mergeSort(q+1, r)
        // 终止条件是：p <= r，说明只剩下一个元素了，就没必要再一分为二了
        // 注意，这里面有个merge方法，需要额外空间，所以不是原地排序
        // 排完序，再将数据拷贝到nums中
        var nums = nums
        quickSort(&nums, 0, nums.count - 1)
        return nums
    }

    // MARK: - 快速排序
    func quickSort(_ nums: inout [Int], _ p: Int, _ r: Int) {
        if p >= r { return }
        let q = partition(&nums, p, r)
        quickSort(&nums, p, q - 1)
        quickSort(&nums, q + 1, r)
    }
    /// 分区，选择一个数组中的数，让所有小于他的值都在左边，所有大于他的值都在右边，返回这个值所在的下标
    func partition(_ nums: inout [Int], _ p: Int, _ r: Int) -> Int {
        // 这个算法是需要技巧的
        // 通常我们选择最后一个作为分界点值pivot
        // 至于如何分区，可能只能死记硬背了。。。。这个技巧确实不好想
        // i和j两个指针，从头开始一直到r-1结束
        // i左边的元素表示都是比pivot小的值，或者说已经分好区的值，同样i右边的表示比pivot大的值
        // i和j的工作就是，随着往后移，要一点点将未处理的元素都处理一边
        // 具体是，j走在前面，当发现j处的元素比pivot小时，不是移动j的元素，而是和i处的元素进行交换，这样相比移动元素比较高效，交换完之后已处理的元素多了一个，所以i也要往前进了
        // 最后要将r位置的元素和i位置元素交换
        let pivot = nums[r]
        var i, j: Int
        i = p
        j = p
        while j <= r - 1 {
            if nums[j] <= pivot {
                nums.swapAt(j, i)
                i += 1
            }
            j += 1
        }
        nums.swapAt(i, r)
        return i
    }
    
    // MARK: - 线性排序
    
    /// 设计一个排序算法，时间复杂度是O(n)
    /// 为公司员工按照年龄排序，员工有几万人
    /// 核心思想是计数排序
    func sortAges(_ ages: inout [Int]) {
        // 使用计数排序
        // 从0-100岁，每个年龄想象成一个桶
        // 扫描一遍所有年龄，将相应年龄的人放入相应桶里
        // 最终取出桶里所有人合并到一起就排序成功了
        
        var bottles = [Int].init(repeating: 0, count: 101)
        
        for age in ages {
            bottles[age] += 1
        }
        // 数字重新填回原数组中
        // 对每个年龄，取出一个个数，让后给原数组赋值，同时索引加一
        var index = 0
        for age in 0...100 {
            for _ in 0..<bottles[age] {
                ages[index] = age
                index += 1
            }
        }
    }
}

/// https://leetcode-cn.com/problems/valid-anagram/
func isAnagram(_ s: String, _ t: String) -> Bool {
    // 用哈希表存储每个字符
    // 遍历s，往哈希表里存每个字符和出现次数
    // 遍历t，从哈希表里删除，如果字符对应的值>0，则减一，减到0后则删除
    if s.count != t.count { return false }
    var hashSet: [Character:Int] = [:]
    for c in s {
        if let num = hashSet[c] {
            hashSet[c] = num + 1
        } else {
            hashSet[c] = 1
        }
    }
    
    for c in t {
        if let num = hashSet[c] {
            if num == 1 {
                hashSet.removeValue(forKey: c)
            } else {
                hashSet[c] = num - 1
            }
        } else {
            return false
        }
    }
    return hashSet.isEmpty
}

func isAnagram1(_ s: String, _ t: String) -> Bool {
    if s.count != t.count { return false }
    let ss = s.sorted()
    let ts = t.sorted()
    for (index, sv) in ss.enumerated() {
        if sv != ts[index] {
            return false
        }
    }
    return true
}

/// https://leetcode-cn.com/problems/merge-intervals/
func merge(_ intervals: [[Int]]) -> [[Int]] {
    // 用一个O(n)的算法完成
    // 有一个区间，叫做待决断区间(pendingInterval)，初始值为第一个输入的区间
    // 核心算法如下：
    // 从第二个元素开始遍历，当前元素为item
    // 与pendingInterval比较发现有重叠（item.0 <= pendingInterval.1），则更新pendingInterval
    // 如果没有重叠，则将pendingInterval放入结果集，并更新pendingInterval为item
    // 遍历结束后，需要将pendingInterval放入结果集
    if intervals.isEmpty { return [] }
    let count = intervals.count
    if count == 1 { return intervals }
    let intervals = intervals.sorted {
        $0[0] < $1[0]
    }
    var pendingInterval = intervals.first!
    var results: [[Int]] = []
    for index in 1..<count {
        let item = intervals[index]
        if item[0] <= pendingInterval[1] {
            pendingInterval[0] = min(item[0], pendingInterval[0])
            pendingInterval[1] = max(item[1], pendingInterval[1])
        } else {
            results.append(pendingInterval)
            pendingInterval = item
        }
    }
    results.append(pendingInterval)
    return results
}

/// https://leetcode-cn.com/problems/sort-colors/
func sortColors(_ nums: inout [Int]) {
    // 使用类似快排的partition的思想
    // 两个指针：i和j
    // 在排序过程中，我们将全部数据局分为[left, i)和[i, right]两个区间
    // [left, i)表示所有小于pivot的元素
    // [i, right]则表示还不确定的元素
    // 刚开始[left, i)区间是空的，j在[i, right]中遍历，随着遍历，逐渐更新[left, i)区间
    // 只要nums[j] < pivot，就swap(i, j)，并且让i前进
    // 该次遍历之后，[left, i)中就都是0了；而[i, right]则混杂着1和2
    // 我们需要再在[i, right]中执行一遍，就能将1和2划分出来了
    var i = 0
    let numCount = nums.count
    for j in i..<numCount {
        if nums[j] < 1 {
            nums.swapAt(i, j)
            i += 1
        }
    }
    
    let rightNumCount = (numCount - 1) - i + 1
    if rightNumCount <= 1 { return }
    
    for j in i..<numCount {
        if nums[j] < 2 {
            nums.swapAt(i, j)
            i += 1
        }
    }
}

/// https://leetcode-cn.com/problems/insertion-sort-list/
func insertionSortList(_ head: ListNode?) -> ListNode? {
    // 利用插入排序的思想对链表进行排序
    // 从第二个节点遍历元素，需要一个表示前驱节点的变量
    // 为了方便插入元素，可以构造一个虚拟头结点
    if head?.next == nil { return head }
    
    let dummyNode = ListNode(Int.min)
    dummyNode.next = head
    
    var pre: ListNode? = head
    
    while let curNode = pre?.next {
        if curNode.val >= pre!.val {
            pre = pre?.next
            continue
        }
        //
        pre?.next = curNode.next
        // 从头开始遍历节点，直到找到大于curNode.val的元素
        var tmpPre: ListNode? = dummyNode
        while let nextNode = tmpPre?.next, nextNode.val <= curNode.val {
            tmpPre = tmpPre?.next
        }
        curNode.next = tmpPre?.next
        tmpPre?.next = curNode
    }
    return dummyNode.next
}

/// https://leetcode-cn.com/problems/sort-list/
func sortList(_ head: ListNode?) -> ListNode? {
    // 快排的思想对链表进行排序
    // 递归实现快排
    // 递
    // 进行划分，划分函数需要返回privot对应node的指针
    // 子方法 quickSortList需要接收两个参数preLeft和afterRiight，表示left的前驱和right的后继
    // 递归终止条件是，只有一个节点或空区间时
    if head == nil { return head }
    
    /// 交换node1与node2
    /// - Parameters:
    ///   - node1Pre: node1的前驱节点
    ///   - node2Pre: node2的前驱节点
    func swapNode(_ node1Pre: inout ListNode?, _ node2Pre: inout ListNode?) {
        let node1 = node1Pre?.next
        let node2 = node2Pre?.next
        let tmpNode2Next = node2?.next
        if node1?.next === node2 {
            // 相邻节点情况
            node1Pre?.next = node2
            node2?.next = node1
            node1?.next = tmpNode2Next
            node2Pre = node1 // 保证nodePre不变
        } else {
            // 节点不相邻的情况
            node1Pre?.next = node2
            node2Pre?.next = node1
            node2?.next = node1?.next
            node1?.next = tmpNode2Next
        }
    }
    
    func partitionList(_ preLeft: ListNode?, _ afterRight: ListNode?) -> ListNode? {
        // 选取第一个元素作为pivot，并将该元素放到最后
        // 通过两个指针，将小于pivot的元素都归到左边，大于等于pivot的元素归到右边
        // i从第二个元素开始，j从第三个元素开始
        // 用j来遍历元素，当jValue < pivot时，则j和i进行交换，直到j遍历结束
        // 遍历结束后，再pivot和i位置元素进行交换
        // 只有一个元素时不需要划分
        if preLeft == nil { return nil }
        if preLeft?.next != nil, preLeft?.next?.next == nil {
            return preLeft?.next
        }
        let pivot = preLeft?.next
        let pivotValue = pivot!.val
        var preI = pivot
        var preJ = preI
        
        while preJ?.next !== afterRight {
            if let jValue = preJ?.next?.val, jValue < pivotValue {
                // 交换i和j位置的节点
                swapNode(&preI, &preJ)
                preI = preI?.next
            }
            preJ = preJ?.next
        }
        // pivot与i进行交换
        
        return pivot
    }
    
    func quickSortList(_ preLeft: ListNode?, _ afterRight: ListNode?) {
        if preLeft?.next?.next === afterRight || preLeft?.next === afterRight {
            return
        }
        let pivotNode = partitionList(preLeft, afterRight)
        quickSortList(preLeft, pivotNode)
        quickSortList(pivotNode, afterRight)
    }
    
    let dummyHead = ListNode(-1)
    dummyHead.next = head
    quickSortList(dummyHead, nil)
    return dummyHead.next
}

func canMakeArithmeticProgression(_ arr: [Int]) -> Bool {
    if arr.isEmpty { return false }
    let count = arr.count
    if count == 1 { return true }
    let array = arr.sorted()
    let interval = array[1] - array[0]
    for i in 1..<count {
        if array[i] - array[i-1] != interval {
            return false
        }
    }
    return true
}

/// https://leetcode-cn.com/problems/sorted-merge-lcci/
func merge1(_ A: inout [Int], _ m: Int, _ B: [Int], _ n: Int) {
    // 插入排序的思想
    // 从下标m开始，使用插入排序的方式
    // 先将B的元素放到A中，然后插入排序
    for i in 0..<n {
        let aIndex = i + m
        A[aIndex] = B[i]
    }
    // 插入排序
    // 4, 2, 3, 6, 1
    // 从第2个数开始，根前面的数字比较，找到合适位置插入
    // 和前一个元素比较，若大于等于，则遍历下一个元素
    // 若非大于等于，则遍历从前一个元素到第一个元素，直到满足大于等于
    // 只要不满足大于等于，则挪动元素
    // 将待插入元素放到合适位置
    for i in m..<m+n {
        if i == 0 { continue }
        let insertionNum = A[i]
        if insertionNum >= A[i-1] { continue }
        
        var j = i - 1
        while j >= 0 {
            if insertionNum >= A[j] {
                break
            }
            A[j+1] = A[j]
            j -= 1
        }
        
        // 此时j为-1，或者insertionNum >= A[j]
        A[j+1] = insertionNum
    }
}

/// https://leetcode-cn.com/problems/smallest-k-lcci/submissions/
func smallestK(_ arr: [Int], _ k: Int) -> [Int] {
    // 快排中的划分算法
    // 递归来做
    // 递归核心逻辑: 执行划分，如果恰好index==k，则递归结束；如果index!=k，则更新left和right继续递归
    if k == 0 { return [] }
    if arr.isEmpty { return arr }
    let count = arr.count
    if k >= count { return arr }
    
    var array = arr
    
    func partition(_ left: Int, _ right: Int) -> Int {
        // 划分方法
        // 选right位置数据作为pivot
        if left >= right { return left }
        var i = left
        let pivot = array[right]
        for j in left..<right {
            if array[j] < pivot {
                if i != j {
                    array.swapAt(i, j)
                }
                i += 1
            }
        }
        array.swapAt(i, right)
        return i
    }
    
    func r(_ left: Int, _ right: Int) {
        let index = partition(left, right)
        if index+1 == k {
            return
        }
        if index+1 > k {
            r(left, index-1)
        } else {
            r(index+1, right)
        }
    }
    r(0, count-1)
    
    var result: [Int] = []
    for i in 0..<k {
        result.append(array[i])
    }
    return result
}

/// https://leetcode-cn.com/problems/diao-zheng-shu-zu-shun-xu-shi-qi-shu-wei-yu-ou-shu-qian-mian-lcof/
func exchange(_ nums: [Int]) -> [Int] {
    // 使用快排的划分方法思想：奇数都放到左边，剩下的右边就都是偶数了
    // 区别在于，由于不是排序，所以不用最后进行交换，而且遍历时需要每个都遍历到
    if nums.isEmpty { return [] }
    var newNums = nums
    var i = 0
    for j in 0..<newNums.count {
        // 奇数放到左边
        if newNums[j] % 2 != 0 {
            if i != j {
                newNums.swapAt(i, j)
            }
            i += 1
        }
    }
    return newNums
}

