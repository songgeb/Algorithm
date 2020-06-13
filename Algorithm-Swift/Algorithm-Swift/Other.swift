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
    /// leetcode-https://leetcode-cn.com/problems/contiguous-sequence-lcci/
    func maxSubArray(_ nums: [Int]) -> Int {
        if nums.count == 0 { return -1 }
        // 暴力办法
        // 两层for循环，遍历所有可能的组合，求出最大值
        // 时间复杂度是O(n2)
        // 分治法解决
        // 核心思想，从中间将数组分为两部分
        // 要求的总和最大的连续序列要么落在左边，要么右边，要么横跨在中间
        // 左边和右边继续递归实现，主要是中间如何求。假设中间元素下标是mid
        // 现在核心问题是，如何求横跨左右两边的总和最大的连续数列
        // 其实从mid往前加，mid+1往后加，两部分最大值加到一起就是横跨中间的最大值
        // 递推公式如上所述
        // 终止条件是：当区间缩小到只有1个时，返回自己
        // check: 空数组时，1个元素时
        func action(_ left: Int, _ right: Int) -> Int {
            if left == right {
                return nums[left]
            }
            
            let mid = left + (right - left) >> 1
            let leftSum = action(left, mid)
            let rightSum = action(mid + 1, right)
            // 计算中间最大
            // 一个maxSum记录最大和
            var maxlSum = nums[mid]
            var lSum = 0
            for i in stride(from: mid, to: left - 1, by: -1) {
                lSum += nums[i]
                maxlSum = max(maxlSum, lSum)
            }
            
            var maxrSum = nums[mid+1]
            var rSum = 0
            for i in (mid+1)...right {
                rSum += nums[i]
                maxrSum = max(maxrSum, rSum)
            }
            
            return max(max(leftSum, rightSum), maxlSum + maxrSum)
        }
        
        return action(0, nums.count - 1)
    }
    
    /// 递归实现0到100的加和
    /// 递推公式: f(n) = f(n-1) + n
    /// 终止条件: f(1) = 1
    func sum0100(_ n: Int) -> Int {
        
        if n == 1 { return 1 }
        return n + sum0100(n-1)
    }
    
    /// 矩阵中查找某个给定的元素
    /// 分治思想，
    func searchMatrix(_ matrix: [[Int]], _ target: Int) -> Bool {
        
        func action(_ i: Int, _ j: Int) -> Bool {
            if i < 0 || j < 0 { return false }
            if i >= matrix.count || j >= matrix[i].count { return false }
            if target == matrix[i][j] {
                return true
            } else if target > matrix[i][j] {
                return action(i + 1, j)
            } else {
                return action(i, j - 1)
            }
        }
        // 从右上角的元素开始找，找的次数更少
        return action(0, matrix[0].count - 1)
    }
}

func myPow(_ x: Double, _ n: Int) -> Double {
    if x == 0 { return 0 }
    if n == 0 {
        return 1
    } else if n > 0 {
        var result: Double = 1
        for _ in 0..<n {
            result *= x
        }
        return result
    } else {
        var result: Double = 1
        for _ in 0..<n {
            result *= x
        }
        return 1.0 / result
    }
}

func myPow1(_ base: Double, _ n: Int) -> Double {
    // 上面的性能不够
    if base == 0 { return 0 }
    if n == 0 { return 1 }
    let positiveN = abs(n)
    
    func action(_ i: Int) -> Double {
        if i == 1 {
            return base
        }
        
        let isEven = i & 0x1 == 0
        let halfValue = action(i >> 1)
        
        if isEven {
            return halfValue * halfValue
        } else {
            // i从3开始
            return halfValue * halfValue * base
        }
    }
    
    let result = action(positiveN)
    if n > 0 {
        return result
    } else {
        return 1.0 / result
    }
}

/// 打印从1到最大的n位数
func printNumbers(_ n: Int) -> [Int] {
    /// 此题考查的是当n很大时，整型类型无法存储的情况
    /// 无法存储就改用字符串来存
    /// 先来考虑下整个流程
    /// 我们没办法弄一个999出来，然后从1到999，输出
    /// 此处又一个讨巧（fuck）的实现，我们在字符串里模拟加一操作，每次加一的同时，都打印一次当前的值，直到无法再加一
    /// 根据上面分析的整个流程，可以翻译成如下代码
    /// while incrementOne() { printNum() }
    /// 分解一下问题，1. 模拟加一（考虑进位） 2. 判断无法加一的情况 3. 打印字符串（高位的0要干掉）
    
    /// 用字符数组可能更好处理一些，我们开辟一个长度为n的字符数组吧，初始每个字符都是"0"
    // 加一操作(注意incrementOne方法在无法继续加一时，应能返回false)
    // 用代码模拟加一过程，要考虑到进位问题
    // 每次加1，我们从数组最后一位开始，到数组第一位结束
    // 看下手算时的逻辑，当前位的字符转为真正的整数后加一，看下有没有进位，如果有进位，再加1，加完后，看下是不是大于等于10了
    // 如果大于等于10的话，那取余保留下来，告诉后面的还要进位
    // 综上，对于每一位的循环中，要有一个进位变量用于记录是否有进位
    // 关于何时无法继续加一的问题，当是第一个字符时，前面判断后还有进位的话，就是不能继续加了，所以for循环中需要由下标
    if n <= 0 { return [] }
    
    var numCharacters = [Character].init(repeating: "0", count: n)
    
    func incrementOne() -> Bool {
        var shouldCarry = false
        for i in stride(from: numCharacters.count - 1, to: -1, by: -1) {
            guard var num = Int(String(numCharacters[i])) else {
                fatalError()
            }
            
            num += 1
            if shouldCarry {
                shouldCarry = false
            }
            
            if num >= 10 {
                if i == 0 {
                    return false
                }
                num = num % 10
                shouldCarry = true
                numCharacters[i] = Character("\(num)")
            } else {
                numCharacters[i] = Character("\(num)")
                break
            }
        }
        return true
    }
    
    // 将当前字符数组表示的数字返回
    func printNum() -> Int {
        // 用打印整数的方式打印字符数组
        // 注意前面的0要干掉
        // 从头往前，从不是0，就继续
        // 增加一个标记，当遇到第一个不是0的字符时，赋值为false
        var isbegin0 = true
        var result = ""
        for i in 0..<numCharacters.count {
            if isbegin0, numCharacters[i] != "0" {
                isbegin0 = false
            }
            if !isbegin0 {
                result += String(numCharacters[i])
            }
        }
        
        guard let value = Int(result) else {
            return 0
        }
        return value
    }
    
    var result: [Int] = []
    while incrementOne() {
        result.append(printNum())
    }
    return result
}

/// 回溯实现
func printNumbers1(_ n: Int) -> [Int] {
    // n位数字，每次选一个
    // 第一位选择时不能是0
    // 长度是1、2、3、n
    if n <= 0 { return [] }
    var result = ""
    var results: [Int] = []
    /// 生成长度为length的字符串，currentPosition表示当前处要生成第几个位置的数字
    func action(length: Int, currentPosition: Int) {
        if currentPosition == length {
            results.append(Int(result)!)
            return
        }
        var start = 0
        if currentPosition == 0 {
            start = 1
        }
        
        for i in start...9 {
            result.append("\(i)")
            action(length: length, currentPosition: currentPosition + 1)
            result.removeLast()
        }
    }
    
    for i in 1...n {
        action(length: i, currentPosition: 0)
    }
    return results
}

/// 输入一个数组，经过函数执行后，让所有奇数在前，偶数在后
func exchange(_ nums: inout [Int]) -> [Int] {
    // 参考快排中的分区逻辑
    // 一个指针p从第一个位置开始，另一个指针q也指向第一个位置
    // p的含义是，在p之前的元素都是奇数，p以及之后的元素都是偶数
    // q表示还没有check的元素
    // 整个过程是这样的：一次遍历循环，每次遍历都去check q元素，如果是奇数，就和p交换
    // 每次q都要前进，但只有交换后p才会前进
    // 直到循环结束
    // check边界情况
    // 1. 空数组，遍历不进行，不受影响
    // 2. 至于一个元素，最多自己与自己交换
    
    var p, q: Int
    p = 0
    q = 0
    while q < nums.count {
        if nums[q] & 0x1 == 1 {
            nums.swapAt(p, q)
            p += 1
        }
        q += 1
    }
    
    return nums
}

func spiralOrder(_ matrix: [[Int]]) -> [Int] {
    // 第一感觉可以用递归或者回溯来解决
    // 从0,0这个位置开始
    // 递归核心工作：
    // 先把自己放入结果集
    // 按照右->下->左->上的方向，看下每个元素能不能走，当然要有一个used数组来存放某个数组是否已经访问过的问题
    // 如果发现可以走某个元素，就打印，或者放入结果集中
    // 直到发现没有可以继续前进的了
    if matrix.isEmpty { return [] }
    var result: [Int] = []
    var used: [[Bool]] = [[Bool]].init(repeating: [], count: matrix.count)
    for (index, rowArray) in matrix.enumerated() {
        used[index] = [Bool].init(repeating: false, count: rowArray.count)
    }
    let row = matrix.count
    func spiral(_ i: Int, _ j: Int) {
        result.append(matrix[i][j])
        let column = matrix[i].count
        var newI, newJ: Int
        newI = i
        newJ = j
        if j + 1 < column, !used[i][j+1] {
            newJ = j + 1
        } else if i + 1 < row, !used[i + 1][j] {
            newI = i + 1
        } else if j - 1 >= 0, !used[i][j - 1] {
            newJ = j - 1
        } else if i - 1 >= 0, !used[i - 1][j] {
            newI = i - 1
        } else {
            return
        }
        used[newI][newJ] = true
        spiral(newI, newJ)
    }
    spiral(0, 0)
    return result
}
