//
//  BackTracking.swift
//  Algorithm-Swift
//
//  Created by songgeb on 2020/2/22.
//  Copyright © 2020 Songgeb. All rights reserved.
//
/// 回溯算法
import Foundation


// MARK: - 回溯算法
// 回溯算法特点就是回溯
// 回溯思想一般用于解决求一个问题的多个解或从多个解中找最优解
// 回溯思想能求解的问题，可以用二叉树的结构画出来，从根到每个叶子节点分别构成了问题的多个解
// 以全排列举例
//                      null
//          1            2              3
//      2       3    1        3     1       2
//      3       2    3        1     2       1
// 对除叶子节点外的节点，要做的事情是一样的，
// 1. 从剩余的数字中选一个放到本次排列数组中，然后可选的就少了一个
// 2. 重复1的过程，直到没有可选的了

/// 回溯法求全排列组合
/// - Parameter n:
func allRank(array: [Int]) {
    // 给定一个无重复整数数组，输出所有的全排列
    // 我们尝试用递归实现全排列
    // 有一个数组path来记录当次遍历中全排列的数字
    // 还要解决在本次递归中，如何直到哪些数字是剩余的--可以用一个used数组，长度和原数组一样，每个值表示原数组中相同位置的值有没有被选择过
    
    var path = [Int]()
    var used = Array<Bool>.init(repeating: false, count: array.count)
    var counter = 0
    allRankRecursion(array: array, path: &path, used: &used, counter: &counter)
    print("总个数->\(counter)")
}

func allRankRecursion(array: [Int], path: inout [Int], used: inout [Bool], counter: inout Int) {
    if path.count >= array.count {
        print("出现一个结果-->\(path)")
        counter += 1
        return
    }
    //从数组中找一个你没有用过的数出来，追加到path中
    for (index, item) in array.enumerated() {
        if !used[index] {
            path.append(item)
            used[index] = true
            allRankRecursion(array: array, path: &path, used: &used, counter: &counter)
            used[index] = false
            path.removeLast()
        }
    }
}

// MARK: - 8皇后问题
// 一个8*8的棋盘，往里面放8个棋子(皇后)，要求八个棋子横向、竖向、对角线上
class EightQueen {
    /// 结果集中下标表示棋盘的行下标，值表示列下标; 初始为-1，表示没有值
    private var result: [Int] = [Int].init(repeating: -1, count: 8)
    /// 在i、j的位置放棋子可不可以
    private func isOK(_ i: Int, _ j: Int) -> Bool {
        let validRange = 0..<result.count
        if !validRange.contains(i) || !validRange.contains(i) { return false }
        // 判断同一行有木有重复的
        if result[i] >= 0 { return false }
        // 判断同一列有木有
        for row in 0..<result.count {
            if j == result[row] {
                // 第row，第j列，有棋子
                return false
            }
        }
        // 判断对角线上有木有
        var p = (i, j)
        while p.0 < result.count, p.1 < result.count {
            if result[p.0] == p.1 {
                return false
            }
            p = (p.0 + 1, p.1 + 1)
        }
        
        p = (i, j)
        while p.0 >= 0, p.1 >= 0 {
            if result[p.0] == p.1 {
                return false
            }
            p = (p.0 - 1, p.1 - 1)
        }
        
        p = (i, j)
        while p.0 < result.count, p.1 >= 0 {
            if result[p.0] == p.1 {
                return false
            }
            p = (p.0 + 1, p.1 - 1)
        }
        
        p = (i, j)
        while p.0 >= 0, p.1 < result.count {
            if result[p.0] == p.1 {
                return false
            }
            p = (p.0 - 1, p.1 + 1)
        }
        return true
    }
    /// 8皇后问题，列举出所有摆放棋子的方案
    /// j表示第几列
    public func cal8Queeens(_ j: Int) {
        if j == 8 {
            // 结束了
            print(result)
            return
        }
        // 每一行都有摆放的可能
        for i in 0...7 {
            if isOK(i, j) {
                result[i] = j
                cal8Queeens(j + 1)
                result[i] = -1
            }
        }
    }
}


// MARK: - 01背包
// 对于一组不同重量、不可分割的物品，我们需要选择一些装入背包，在满足背包最大重量限制的前提下，背包中物品总重量的最大值是多少呢？
// 同上面全排列问题
// 该问题也可以用回溯法穷举出所有的可能情况，从其中选择使得总重量最大的一个来

// [3, 5, 6, 2, 8, 9]
// 1. 刚开始有多种情况，先找一个，可选可不选，两种情况都得走一下
// 2. 随着前进，剩余的情况越来越少，等不能再往前走时，就要“回溯”了，回溯到前一个状态，选择另外一种可能
// 3. 继续从1开始

class Package {
    static let array = [2, 2, 4, 6, 3]
    static let capacity = 9
    static var method: [Int] = []
    static var max = 0
    static var maxMethod: [Int] = []
    
    static func zhuang(i: Int, cw: Int) {
        // 第i个物品，装或者不装，未装第i个物品时的重量
        if i < 0 { return }
        if i >= array.count {
            if max < cw {
                max = cw
                maxMethod = method
            }
            return
        }
        // 不装
        zhuang(i: i + 1, cw: cw)
        // 装
        if cw + array[i] <= capacity{
            method.append(array[i])
            zhuang(i: i + 1, cw: cw + array[i])
            method.removeLast()
        }
        
    }
    
    static var mem: [[Bool]] = [[Bool]].init(repeating: [Bool].init(repeating: false, count: 13), count: 6)
    /// 增加了备忘录的装法
    /// - Parameters:
    ///   - i:
    ///   - cw:
    static func zhuang2(i: Int, cw: Int) {
        if i >= array.count || cw >= capacity {
            if max < cw {
                max = cw
                maxMethod = method
            }
            return
        }
        
        if mem[i][cw] { return }
        // 不装
        zhuang2(i: i + 1, cw: cw)
        // 装
        if cw + array[i] <= capacity{
            method.append(array[i])
            zhuang2(i: i + 1, cw: cw + array[i])
            method.removeLast()
        }
    }
    
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
            for j in stride(from: capacity - array[i], to: 0, by: -1) {
                if states4[j] { states4[j + array[i]] = true }
            }
        }
        
        print(states4)
    }
    
    static func test() {
        zhuang4()
    }
}

/// 例举出所有A、B、C，使其满足A + B + C = 1000 和 A^2 + B^2 = C^2
func calABC() {
    func isOK(_ a: Int, _ b: Int, _ c: Int) -> Bool {
        return a + b + c == 1000 && a*a + b*b == c*c
    }
    
    var result: [Int] = []
    func action(_ n: Int) {
        if n == 3 {
            let c = 1000 - result[0] - result[1]
            if isOK(result[0], result[1], c) {
                result.append(c)
                print(result)
                result.removeLast()
            }
            return
        }
        
        for i in 0...1000 {
            result.append(i)
            action(n+1)
            result.removeLast()
        }
    }
    
    action(1)
    
    /// 非递归实现
    //    for a in 0...1000 {
    //        for b in 0...1000 {
    //            // 因为c是唯一的，所以此处通过公式结算得到c
    //            let c = 1000 - a - b
    //            if isOK(a, b, c) {
    //                print("\(a), \(b), \(c)")
    //            }
    //        }
    //    }
    
    // 结果集
    // 0, 500, 500
    // 200, 375, 425
    // 375, 200, 425
    // 500, 0, 500
}

/// leetcode-79，单词搜索问题
func exist(_ board: [[Character]], _ word: String) -> Bool {
    var usedCharaters = [[Bool]].init(repeating: [Bool].init(repeating: false, count: board[0].count), count: board.count)
    let wordCharacters = [Character].init(word)
    let directions = [(1, 0), (-1, 0), (0, 1), (0, -1)]
    
    func isIndexInBoard(_ i: Int, _ j: Int) -> Bool {
        return (0..<board.count).contains(i) && (0..<board[i].count).contains(j)
    }
    
    func search(i: Int, j: Int, characterIndex: Int) -> Bool {
        if board[i][j] != wordCharacters[characterIndex] {
            return false
        }
        // 注意usedCharaters[i][j] = true的位置在这句话下面，是因为当匹配到最后一个字符时，可以认为我们并没有取占用最后一个字符，就回溯告诉外面成功了
        // 也可以从另一个角度去考虑，占用和重置应该是成对出现的，如果此处占用了最后一个字符，但并没有重置它的地方，会导致状态错乱
        if characterIndex == wordCharacters.count - 1 {
            return true
        }
        usedCharaters[i][j] = true
        // 四个方向都试一遍
        for direction in directions {
            let newI = i + direction.0
            let newJ = j + direction.1
            if isIndexInBoard(newI, newJ), !usedCharaters[newI][newJ] {
                if search(i: newI, j: newJ, characterIndex: characterIndex + 1) {
                    return true
                }
            }
        }
        usedCharaters[i][j] = false
        return false
    }
    
    for i in 0..<board.count {
        for j in 0..<board[i].count {
            if search(i: i, j: j, characterIndex: 0) {
                return true
            }
        }
    }
    
    return false
}

/// 幂集。编写一种方法，返回某集合的所有子集。集合中不包含重复的元素。

/// 说明：解集不能包含重复的子集。
/// 输入： nums = [1,2,3]
///输出：
//[
//    [3],
//        [1],
//              [2],
//                    [1,2,3],
//                          [1,3],
//                                [2,3],
//                                      [1,2],
//                                            []
//]
func subsets(_ nums: [Int]) -> [[Int]] {
    var results: [[Int]] = []
    var result: [Int] = []
    func action(_ i: Int) {
        if i >= nums.count {
            print(result)
            results.append(result)
            return
        }
        // 选择i个
        result.append(nums[i])
        action(i + 1)
        
        // 不选择i个
        result.removeLast()
        action(i+1)
    }
    action(0)
    return results
}
/// 子集非递归实现
func subsets111(_ nums: [Int]) -> [[Int]] {
    var result: [[Int]] = []
    
    // 遍历nums中每个元素
    // 每次遍历中，新建一个数组用于放本次的结果集tmp，每次拿到一个元素后，先把自己包成一个数组放入tmp，再取出result中的每个元素，每个都和当前元素合成以一把，加到tmp中
    // 遍历结束时，将tmp放到结果集中
    // 空数据单独加一个
    result.append([])
    var count = 0
    for num in nums {
        var tmp: [[Int]] = []
        
        for subset in result {
            var s = subset
            s.append(num)
            tmp.append(s)
            count += 1
        }
        
        result.append(contentsOf: tmp)
    }

    return result
}

/// leetcode-https://leetcode-cn.com/problems/bracket-lcci/
/// 根据输入n，产生n对有效的括号组合
func generateParenthesis(_ n: Int) -> [String] {
    var result: Set<String> = []
    // i从2开始，一直到n，因为n=1时只有一种可能--()
    func action(_ i: Int, _ str: String) {
        if i == n {
            print(str)
            result.insert(str)
            return
        }
        
        // 往左右边插入一对括号
        var tmp1 = str
        tmp1.insert(contentsOf: "()", at: str.startIndex)
        action(i + 1, tmp1)
        
        tmp1 = str
        tmp1.insert(contentsOf: "()", at: tmp1.endIndex)
        // 往每个(后面插入一对括号
        var tmp2 = str
        for index in tmp2.indices {
            if tmp2[index] == ")" {
                tmp2.insert(contentsOf: "()", at: index)
                action(i + 1, tmp2)
                tmp2 = str
            }
        }
    }
    action(1, "()")
    return [String].init(result)
}

/// leetcode-https://leetcode-cn.com/problems/bracket-lcci/
/// 求括号另一种解法
/// 总体思想是，我们分2n步骤，每一步可以选择左括号、右括号，这样就会出现2n个数量限制下的所有左右括号的组合
/// 当然，上面还不够，还要保证括号的匹配是有效的
/// 比如第一个字符必须是左括号，左右括号数量必须相匹配
/// 所以这个判断条件是很重要的
/// 添加左括号的限制是，添加后，总数不超过2n，此处需要知道左括号数量，所以添加一个参数
/// 右括号限制，当然，添加后不超过2n，而且添加完后，不能使得添加完后，比左括号数多
func generateParenthesis1(_ n: Int) -> [String] {
    if n == 0 { return [] }
    
    let total = 2 * n
    func action(_ i: Int, str: String, leftnum: Int, rightnum: Int) {
        if i > 2 * n {
            print(str)
            return
        }
        
        // 左括号
        if 2 * leftnum + 1 <= total {
            action(i + 1, str: str + "(", leftnum: leftnum + 1, rightnum: rightnum)
        }
        
        // 右括号
        if rightnum + 1 <= leftnum {
            action(i + 1, str: str + ")", leftnum: leftnum, rightnum: rightnum + 1)
        }
    }
    
    action(1, str: "", leftnum: 0, rightnum: 0)
    
    return []
    
}
