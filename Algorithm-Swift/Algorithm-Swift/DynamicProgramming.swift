//
//  DynamicProgramming.swift
//  Algorithm-Swift
//
//  Created by songgeb on 2020/6/1.
//  Copyright © 2020 Songgeb. All rights reserved.
//

import Foundation

class DynamicProgramming {
    
    static let array = [2, 2, 4, 6, 3]
    static let capacity = 9
    
    /// 动态规划解决背包问题
    /// 所谓动态规划，就是依靠上一步的结果，制定下一步的策略，将当前一步的所有情况标记出来，通过技巧规避掉重复项
    /// 联想到二维数组，去重的01背包问题
    /// 想象一个二维数组，行数表示物品数量，列数表示重量，列数最大不超过背包总重量
    /// 假设物品重量是[2,2]，a[0][0] = 1，表示第一个物品不放入背包时重量为0，a[0][2]=1表示第一个物品放入了背包，重量是2
    
    static var states: [[Bool]] = [[Bool]].init(repeating: [Bool].init(repeating: false, count: 10), count: 5)
    static func zhuang3() {
        // 先对第一个物品做特殊处理
        // 不装
        states[0][0] = true
        // 装
        if array[0] > capacity {
            states[0][array[0]] = true
        }
        
        // 从第二个物品到结束
        for i in 1..<array.count {
            for j in 0...capacity {
                // 只用关前面已装或未装的
                if states[i - 1][j] {
                    // 当前i物品，不装的状态
                    states[i][j] = true
                    // 当前i物品，装的状态
                    if j + array[i] <= capacity {
                        states[i][j + array[i]] = true
                    }
                }
            }
        }
        
        //按行输出结果集
        for i in 0..<array.count {
            for j in 0...capacity {
                print(states[i][j], terminator: " ")
            }
            print("")
        }
    }
    
    /// 使用一位数组实现动态规划实现01背包
    static var states4: [Bool] = [Bool].init(repeating: false, count: Package.capacity + 1)
    static func zhuang4() {
        states4[0] = true
        if array[0] <= capacity {
            states4[array[0]] = true
        }
        
        for i in 1..<array.count {
            for j in stride(from: capacity - array[i], to: -1, by: -1) {
                if states4[j] {
                    
                    states4[j + array[i]] = true
                }
            }
        }
        
        for i in 1..<array.count {
            for j in 0...capacity - array[i] {
                if states4[j] { states4[j + array[i]] = true }
            }
        }
        
        print(states4)
    }
    
    /// https://leetcode.cn/problems/partition-equal-subset-sum/
    func canPartition(_ nums: [Int]) -> Bool {
        // 问题可以分解为能否找到一个子集，使得和为sum / 2
        // 回溯当然可以搞了
        // 本次先使用动态规划搞一下
        // 先计算 sum / 2 = A
        // 然后开辟一个A+1长度的数组dp，for循环（长度为n），尝试填充和更新这个数组
        // 直到dp[A]有值，如果有值则停止循环，如果没有值则说明不能放了
        if nums.isEmpty { return false }
        var halfSum = 0
        for num in nums {
            halfSum += num
        }
        if halfSum % 2 != 0 { return false }
        halfSum /= 2
        let count = nums.count
        var dp = Array(repeating: Array(repeating: false, count: halfSum + 1), count: count)
        // 初始化dp
        dp[0][0] = true
        if nums[0] <= halfSum {
            dp[0][nums[0]] = true
        }
        if dp[0][halfSum] { return true }
        for i in 1..<count {
            for j in 0...halfSum {
                // dp[i][j]，从dp[i-1][j]和dp[i-1][j-nums[i]]得出
                dp[i][j] = dp[i-1][j] || (j-nums[i] >= 0 && dp[i-1][j-nums[i]])
                if dp[i][halfSum] {
                    return true
                }
            }
        }
        return false
    }
    
    func canPartition1(_ nums: [Int]) -> Bool {
        // 再用回溯做一遍
        if nums.isEmpty { return false }
        var halfSum = 0
        for num in nums {
            halfSum += num
        }
        if halfSum % 2 != 0 { return false }
        halfSum /= 2
        let count = nums.count
        
        // 分多个阶段，共n个阶段，每个阶段针对第n个元素，选择或者不选择
        // 结束条件：1. sum正好等于halfSum；2. sum大于了halfSum；3. 已经大于n个步骤了
        var success = false
        func dfs(step: Int, sum: Int) {
            // 第step个元素，选择与否
            if success { return }
            if sum == halfSum {
                success = true
                return
            }
            
            if sum > halfSum || step == count {
                return
            }
            
            // 不选
            dfs(step: step + 1, sum: sum)
            // 选择
            dfs(step: step + 1, sum: sum + nums[step])
        }
        dfs(step: 0, sum: 0)
        return success
    }
    
    /// https://leetcode.cn/problems/target-sum/
    func findTargetSumWays(_ nums: [Int], _ target: Int) -> Int {
        // 使用dp填表完成
        // dp[n-1][target]表示最终和为target时有多少种情况
        // dp[n-1][targt] = dp[n-2][target-nums[n-1]] + dp[n-2][target+nums[n-1]]
        // 开辟一个n行，2001列的二维数组，行表示nums中每个数，列表示加入不同符号后的和。每个位置的内容表示到达当前列所表示的和时，有多少种情况
        // 填完最后一行表就知道结果了
        // 先填第一行元素，之后，每一行的元素dp[i][j] = dp[i-1][j-nums[i]] + dp[i-1][j+nums[i]]
        // 需要注意的是，列中要表示和是-1000-1000范围，所以下标j与和之间的映射为0表示-1000,2000的下标表示的和为1000，sum = j - 1000
        let count = nums.count
        var dp = Array(repeating: Array(repeating: 0, count: 20001), count: count)
        // 填充第一行数据
        dp[0][nums[0] + 1000] = 1 // 第一个元素之前放正号
        dp[0][1000 - nums[0]] = dp[0][1000 - nums[0]] + 1 // 放负号
        
        for i in 1..<count {
            for j in 0...2000 {
                let curSum = j - 1000
                let preJ1 = curSum - nums[i] + 1000
                if preJ1 >= 0 {
                    dp[i][j] += dp[i-1][preJ1]
                }
                
                let preJ2 = curSum + nums[i] + 1000
                if preJ2 <= 2000 {
                    dp[i][j] += dp[i-1][preJ2]
                }
            }
        }
        
        let targetJ = target + 1000
        return dp[count-1][targetJ]
    }
    
    /// https://leetcode.cn/problems/coin-change/
    func coinChange(_ coins: [Int], _ amount: Int) -> Int {
        // 完全背包问题
        // dp二维数组，count行，amount+1列
        // 每个格子的内容为，达到j所表示的钱数时，所需要的最少的硬币数
        // dp[i][j] = Min(dp[i-1][j], dp[i-1][j-coins[i]] + 1, dp[i-1][j-2*coins[i]] + 2, ....)
        // dp的第一行数据，尝试放0个、1个。。。。。amount/coins[0]个元素
        let count = coins.count
        var dp = Array(repeating: Array(repeating: Int.max, count: amount + 1), count: count)
        for c in 0...amount/coins[0] {
            let j = c * coins[0]
            dp[0][j] = c
        }
        
        // 从第二行到第n-1行
        for i in 1..<count {
            for j in 0...amount {
                var minCount = Int.max
                for c in 0...j/coins[i] {
                    let preJ = j - c * coins[i]
                    if dp[i-1][preJ] != Int.max, dp[i-1][preJ] + c < minCount {
                        minCount = dp[i-1][preJ] + c
                    }
                }
                dp[i][j] = minCount
            }
        }
        if dp[count-1][amount] == Int.max {
            return -1
        }
        return dp[count-1][amount]
    }
    
    func coinChange1(_ coins: [Int], _ amount: Int) -> Int {
        // 会超时
        // dp[amount] = Min(dp[amount-t1], dp[amount-t2], .... dp[amount-tk]) + 1
        // dp[t1] = dp[t2] = ... = dp[tk] = 1
        if amount == 0 { return 0 }
        func what(amount: Int) -> Int {
            if coins.contains(amount) {
                return 1
            }
            var minChangeCount = Int.max
            for coin in coins {
                if amount - coin >= 0 {
                    let v = what(amount: amount - coin)
                    if v < minChangeCount {
                        minChangeCount = v
                    }
                }
            }
            if minChangeCount == Int.max {
                return Int.max
            }
            return minChangeCount + 1
        }
        let xx = what(amount: amount)
        if xx == Int.max {
            return -1
        }
        return xx
    }
    
    func coinChange2(_ coins: [Int], _ amount: Int) -> Int {
        // 再尝试一下使用这个递推公式能否搞出答案
        // dp[amount] = Min(dp[amount-t1], dp[amount-t2], .... dp[amount-tk]) + 1
        // dp[t1] = 1, dp[t2] = 1, dp[t3] = 1, .... dp[tk] = 1
        // dp[0] = 0
        var dp = Array(repeating: Int.max, count: amount+1)
        dp[0] = 0
        for i in 0...amount {
            // 计算完dp
            for coin in coins {
                if i - coin >= 0, dp[i-coin] != Int.max {
                    dp[i] = min(dp[i], dp[i-coin] + 1)
                }
            }
        }
        if dp[amount] == Int.max {
            return -1
        }
        return dp[amount]
    }
    
    /// https://leetcode.cn/problems/coin-change-2/
    func change(_ amount: Int, _ coins: [Int]) -> Int {
        // 完全背包问题
        // dp[i][j]表示，在使用coins[0]。。。coins[i]这些硬币凑出金额为j时，有多少个组合情况
        // dp[i][j] = dp[i-1][j] + dp[i-1][j-coins[i]] + dp[i-1][j-2*coins[i]]...
        // 上面的式子，有[0, j/coins[i]]一共j/coins[i] + 1个
        // 二维数组，有count行，amount+1列，初始化为0
        let count = coins.count
        var dp = Array(repeating: Array(repeating: 0, count: amount + 1), count: count)
        // 初始化第一行，即使用coins[0]这一个硬币凑出从0--amout的钱数，有多少个组合情况
        for c in 0...amount/coins[0] {
            dp[0][c*coins[0]] = 1
        }
        
        // 第二行到最后一行
        for i in 1..<count {
            for j in 0...amount {
                for c in 0...j/coins[i] {
                    dp[i][j] += dp[i-1][j-c*coins[i]]
                }
            }
        }
        return dp[count-1][amount]
    }
    
    /// https://leetcode.cn/problems/minimum-path-sum/
    func minPathSum(_ grid: [[Int]]) -> Int {
        // dp[i][j] = min(dp[i-1][j], dp[i][j-1]) + grid[i][j]
        // dp[0][0] = grid[0][0]
        let rowCount = grid.count
        let colCount = grid[0].count
        var dp = Array(repeating: Array(repeating: Int.max, count: colCount), count: rowCount)
        dp[0][0] = grid[0][0]
        for i in 0..<rowCount {
            for j in 0..<colCount {
                if i == 0, j == 0 { continue }
                var minPath = Int.max
                if i - 1 >= 0 {
                    minPath = min(dp[i][j], dp[i-1][j])
                }
                if j - 1 >= 0 {
                    minPath = min(minPath, dp[i][j-1])
                }
                if minPath != Int.max {
                    dp[i][j] = minPath + grid[i][j]
                }
            }
        }
        return dp[rowCount-1][colCount-1]
    }
    
    /// https://leetcode.cn/problems/li-wu-de-zui-da-jie-zhi-lcof/
    func maxValue(_ grid: [[Int]]) -> Int {
        // dp[i][j] = max(dp[i-1][j], dp[i][j-1]) + grid[i][j]
        let rowCount = grid.count
        let colCount = grid[0].count
        var dp = Array(repeating: Array(repeating: Int.min, count: colCount), count: rowCount)
        dp[0][0] = grid[0][0]
        for i in 0..<rowCount {
            for j in 0..<colCount {
                if i == 0, j == 0 { continue }
                var maxValue = Int.min
                if i - 1 >= 0 {
                    maxValue = max(dp[i][j], dp[i-1][j])
                }
                if j - 1 >= 0 {
                    maxValue = max(maxValue, dp[i][j-1])
                }
                if maxValue != Int.min {
                    dp[i][j] = maxValue + grid[i][j]
                }
            }
        }
        return dp[rowCount-1][colCount-1]
    }
    /// https://leetcode.cn/problems/triangle/
    func minimumTotal(_ triangle: [[Int]]) -> Int {
        // dp[i][j] = Min(dp[i-1][j], dp[i-1][j-1]) + triangle[i][j]
        // dp[i][j]表示，到达triangle[i][j]时，最小的路径和
        // 还有一个小点，是遍历三角形
        // 第一行一个元素，最后一行有triangle.count个元素
        let rowCount = triangle.count
        var dp = Array(repeating: Array(repeating: Int.max, count: rowCount), count: rowCount)
        dp[0][0] = triangle[0][0]
        for i in 1..<rowCount {
            for j in 0..<(i+1) { //第i行有i+1个元素
                var minValue = Int.max
                if j < i {
                    minValue = dp[i-1][j]
                }
                if j-1 >= 0 {
                    minValue = min(minValue, dp[i-1][j-1])
                }
                dp[i][j] = minValue + triangle[i][j]
            }
        }
        
        var minValue = Int.max
        for j in 0..<rowCount {
            if dp[rowCount-1][j] < minValue {
                minValue = dp[rowCount-1][j]
            }
        }
        return minValue
    }
    /// https://leetcode.cn/problems/unique-paths/
    func uniquePaths(_ m: Int, _ n: Int) -> Int {
        // dp[i][j]表示走到ij位置，有多少条路径可以选
        // dp[i][j] = dp[i-1][j] + dp[i][j-1]
        // 初始值，第一行和第一列都为1
        var dp = Array(repeating: Array(repeating: 0, count: n), count: m)
        for i in 0..<m {
            dp[i][0] = 1
        }
        for j in 0..<n {
            dp[0][j] = 1
        }
        
        for i in 1..<m {
            for j in 1..<n {
                dp[i][j] = dp[i-1][j] + dp[i][j-1]
            }
        }
        return dp[m-1][n-1]
    }
    
    /// https://leetcode.cn/problems/unique-paths-ii/
    func uniquePathsWithObstacles(_ obstacleGrid: [[Int]]) -> Int {
        // dp[i][j]表示走到ij位置，有多少条路径可以选
        // dp[i][j] = dp[i-1][j] + dp[i][j-1]
        // if grid[i][j] == 1，则不可达；
        // if grid[i-1][j]==1，则dp[i][j] = dp[i][j-1], else dp[i]
        let rowCount = obstacleGrid.count
        let colCount = obstacleGrid[0].count
        var dp = Array(repeating: Array(repeating: 0, count: colCount), count: rowCount)
        if obstacleGrid[0][0] != 1 {
            dp[0][0] = 1
        }
        
        for i in 0..<rowCount {
            for j in 0..<colCount {
                if obstacleGrid[i][j] == 1 { continue }
                if i - 1 >= 0 {
                    dp[i][j] += dp[i-1][j]
                }
                if j - 1 >= 0 {
                    dp[i][j] += dp[i][j-1]
                }
            }
        }
        return dp[rowCount-1][colCount-1]
    }
}
// MARK: - 找零钱

/// 找零钱问题，1元、3元、5元的硬币若干枚，支付9元使用的最少的硬币数是多少
/// 本算法尝试使用回溯算法，找出所有可能的组合情况，然后从中选择硬币数最小的
func check_backtracking() {
    let icons = [1, 3, 5]
    var selectedIcons: [Int] = []
    var minIcons = Int.max
    /// i表示选择第几个硬币，从0开始
    func action(_ i: Int, currentMoney: Int) {
        if currentMoney > 9 {
            return
        }
        if currentMoney == 9 {
            print(selectedIcons)
            minIcons = min(minIcons, selectedIcons.count)
            return
        }
        /// 选择一枚1元的硬币
        selectedIcons.append(1)
        action(i + 1, currentMoney: currentMoney + 1)
        selectedIcons.removeLast()
        
        selectedIcons.append(3)
        action(i + 1, currentMoney: currentMoney + 3)
        selectedIcons.removeLast()
        
        selectedIcons.append(5)
        action(i + 1, currentMoney: currentMoney + 5)
        selectedIcons.removeLast()
        
    }
    
    action(0, currentMoney: 0)
    print(minIcons)
}

/// 给定任意可选硬币和任意钱数，给出一个所有可能的找零组合
func checkn_backtracking(coins: [Int], total: Int) {
    
    var result :[Int] = []
    func action(currentMoney: Int) {
        if currentMoney == 0 {
            print("出现一个结果->\(result)")
            return
        }
        
        if currentMoney < 0 {
            return
        }
        
        for coin in coins {
            result.append(coin)
            action(currentMoney: currentMoney - coin)
            result.removeLast()
        }
    }
    
    action(currentMoney: total)
}
/// 动态规划实现给定任意可选硬币和任意钱数，给出需要的最少找零硬币数
func check_dp(coins: [Int], total: Int) -> Int {
    // 一个dptable，长度是total+1
    // i从1开始，每个位置的值表示要找i数值的零钱，需要最少多少个硬币
    // 这个值通过遍历coins所有硬币，通过取得最小的dptable[i - coin]来得到
    
    let placeholder = Int.max - total
    var dptable = [Int].init(repeating: placeholder, count: total + 1)
    dptable[0] = 0
    for i in 1...total {
        for coin in coins {
            if i - coin >= 0 {
                let numCoin = dptable[i-coin] + 1
                if numCoin  < dptable[i] {
                    dptable[i] = numCoin
                }
            }
        }
    }
    
    return dptable[total] == placeholder ? -1 : dptable[total]
}

func yanghui() {
    let array = [[5], [7,8], [2,3,4], [4,9,6,1], [2,7,9,4,5]]
    
    var states = [[Int]].init(repeating: [0, 0, 0, 0, 0], count: 5)
    states[0][0] = array[0][0]
    
    // 构造状态转移表
    for i in 1..<array.count {
        for j in 0..<array[i].count {
            if j == 0 {
                states[i][j] = states[i-1][j] + array[i][j]
            } else if j == array[i].count - 1 {
                states[i][j] = states[i-1][array[i-1].count - 1] + array[i][j]
            } else {
                let topLeft = states[i-1][j-1]
                let topRight = states[i-1][j]
                states[i][j] = min(topLeft, topRight) + array[i][j]
            }
        }
    }
    
    //取出最后一排节点中最短路径长度
    var minValue = Int.max
    for i in 0..<states[states.count - 1].count {
        minValue = min(states[states.count - 1][i], minValue)
    }
    print(minValue)
}

/// 回溯方法求出数组中所有递增子序列
func increasingSubSequence(_ array: [Int]) {
    
    var result: [Int] = []
    /// 从i起，所有递增子序列
    func action(_ i: Int) {
        if i == array.count {
            print(result)
            return
        }
        
        //选择
        if result.isEmpty || result.last! <= array[i] {
            result.append(array[i])
            action(i+1)
            result.removeLast()
        }
        
        // 不选择
        action(i+1)
    }
    
    for i in 0..<array.count {
        action(i)
    }
}

func lengthOfLIS(_ nums: [Int]) -> Int {
    guard nums.count > 0 else { return 0 }
    var dp = [Int](repeating: 1, count: nums.count)
    var result = 1
    for i in 1..<nums.count {
        var maxPre = 0
        for j in 0..<i {
            if nums[j] < nums[i] {
                maxPre = max(maxPre, dp[j])
            }
        }
        dp[i] = maxPre + 1
        result = max(result, dp[i])
    }
    return result
}

/// 滑动窗口解决“不重复最长子串长度”
func lengthOfLongestSubstring(_ s: String) -> Int {
    /// 相比暴力的遍历O(n^2)的时间复杂度，该方法仅需要O(n)，是因为避免了无用的遍历情况
    /// 滑动窗口需要一左一右指针表示滑动的窗口left、right
    /// left和right都从0开始，right用于遍历后序的字符，left用于限定滑动窗口左边界和计算子串长度
    /// right遍历每个字符时，check字符是否在滑动窗口中出现过，此处为了提高效率可以是用哈希表来存储滑动窗口中出现的字符
    // 若字符在滑动窗口中出现过，说明遇到重复字符了，那此时就不满足求解要求，没有再往后遍历的必要，此时我让left前进一位，然后开始新的遍历比较，注意，同时，要将之前left对应的字符从哈希表中删除，其实就是更新当前滑动窗口中出现的字符
    /// 若字符在滑动窗口中没出现过，说明遇到了新字符，那就将这个字符加入到哈希表中，同时更新下最新的子串最大长度，然后right继续遍历
    /// https://zhuanlan.zhihu.com/p/74022291
    var max = 0
    var left = s.startIndex
    var right = s.startIndex
    var map: [Character: Int] = [:]

    while right < s.endIndex {
        let character = s[right]
        if map[character] == nil {
            map[character] = 1
            let length = s.distance(from: left, to: right) + 1
            max = Swift.max(max, length)
            right = s.index(after: right)
        } else {
            map.removeValue(forKey: s[left])
            left = s.index(after: left)
        }
    }
    return max
}
