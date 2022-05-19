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
/// 字符串全排列
func permutation(_ s: String) -> [String] {
    // 全排列问题
    // 所有字符排列组合可以分解成：
    // {a, *, *} + {b, *, *} + {c, *, *}
    // 文字描述的话，就是固定第一个元素，让后面的元素进行全排列
    // 显然可以用递归来实现
    
    // 如何固定呢
    // 对于第i个，j从i到length-1，swap(i, j)
    // 然后递归的进行第1个、第2个，直到第length-1个，就完成一个结果
    var result: [String] = []
    var chars: [Character] = []
    for c in s {
        chars.append(c)
    }
    func hasSameValue<T: Equatable>(start: Int, end: Int, target: T, array: [T]) -> Bool {
        if start > end { return false }
        for i in start...end {
            if array[i] == target {
                return true
            }
        }
        return false
    }
    // 固定住第i个元素，让后面的元素进行全排列
    func action(_ i: Int) {
        if i == chars.count - 1 {
            result.append(String(chars))
            return
        }
        
        for j in i..<chars.count {
            // j表示要讲第i个元素固定为第j位置的元素
            // 如果在j之前曾经出现过j位置的元素，说明这个值已经固定过了，不能再重复递归了
            // 剪枝策略是，如果在[i...j-1]这个区间里出现了chars[j]元素
            if hasSameValue(start: i, end: j - 1, target: chars[j], array: chars) { continue }
            chars.swapAt(i, j)
            action(i+1)
            chars.swapAt(i, j)
        }
    }
    
    action(0)
    return result
}

/// 一个字符串所有字符的组合
func permutation2(_ s: String) -> [String] {
    if s.isEmpty { return [] }
    var result: [String] = []
    var chars: [Character] = []
    for c in s {
        chars.append(c)
    }
    
    var tmp: [Character] = []
    /// 计算在s字符串中，由num个字符组成的组合
    func action(_ num: Int, _ start: Int) {
        if num == 0 {
            result.append(String(tmp))
            return
        }
        
        for i in start..<chars.count {
            tmp.append(chars[i])
            action(num - 1, i + 1)
            tmp.removeLast()
        }
    }

    for i in 1...s.count {
        action(i, 0)
    }
    
    return result
}
/// 整数组合，输入n和k，求从1到n中，选择k个数，所有的组合
func combinex(_ n: Int, _ k: Int) -> [[Int]] {
    if n == 0 || k == 0 { return [] }
    // 核心思想是，一个一个选
    // 第一次选，可选择的有n个，第二次选从生下的n-1个中选择1个
    
    var result: [[Int]] = []
    var tmp: [Int] = []
    
    func action(_ start: Int) {
        if tmp.count == k {
            result.append(tmp)
            return
        }
        /// 第i次选择数字
        
        for i in stride(from: start, to: n+1, by: 1) {
            tmp.append(i)
            action(i+1)
            tmp.removeLast()
        }
    }
    action(1)
    return result
}

/// 整数组合2
func combiney(_ n: Int, _ k: Int) -> [[Int]] {
    // 对于每一个数字有两种可能，选或者不选
    // 于是递归的核心工作是，选当前数字i，不选当前数字i，然后继续进行下一个数的递归工作
    // 递归终止条件：当前索引已经超出了n，或者结果集的数字已经到k个了
    var result: [[Int]] = []
    var tmpResult: [Int] = []
    // 对第i个数做决策
    func action(_ i: Int) {
        
        if tmpResult.count == k {
            result.append(tmpResult)
            return
        }
        
        if i > n {
            return
        }
        
        // 选
        tmpResult.append(i)
        action(i + 1)
        tmpResult.removeLast()
        
        // 不选
        action(i+1)
    }
    action(1)
    return result
}
/// 子集
func subsets2(_ nums: [Int]) -> [[Int]] {
    if nums.isEmpty {
        return [[]]
    }
    
    var nums = nums
    let lastValue = nums.removeLast()
    var sets = subsets2(nums)
    
    for s in sets {
        var tmp = s
        tmp.append(lastValue)
        sets.append(tmp)
    }
    return sets
}

/// 找零钱
func check() -> [[Int]] {
    var counter = 0
    var result: [[Int]] = []
    var tmpResult = [String]()
    var coins = [2, 3, 7]
    var cc = [50, 34, 15]
    func action(_ sum: Int, _ start: Int) {
        if sum == 100 {
            //            result.append(tmpResult)
            print(tmpResult)
            counter += 1
            return
        }
        
        if start == coins.count || sum > 100 {
            return
        }
        
        for i in start..<coins.count {
            for j in 1...cc[start] {
                // 选择j个coins[start]
                tmpResult.append("\(j)个\(coins[i])")
                action(sum + j * coins[i], start + 1)
                tmpResult.removeLast()
            }
        }
    }
    
    action(0, 0)
    print(counter)
    return result
}

func check2() {
    var counter = 0
    for i in 0...50 {
        for j in 0...34 {
            for k in 0...15 {
                if 2 * i + 3 * j + 7 * k == 100 {
                   counter += 1
                }
            }
        }
    }
    print(counter)
}

class BackTracking {
    
    /// https://leetcode.cn/problems/eight-queens-lcci/
    func solveNQueens(_ n: Int) -> [[String]] {
        // N皇后问题，经典回溯问题，多阶段决策
        // 每次决定当前行需要往哪里放棋子
        // 递归函数的参数有，当前进展到第几行了--row；当前的结果集是啥，即二维数组表示的棋盘
        //
        var result: [[String]] = []
        // 可以复用的棋盘
        var chars: [[Character]] = Array(repeating: Array(repeating: ".", count: n), count: n)
        
        func isOK(row: Int, col: Int, chars:[[Character]]) -> Bool {
            // check 列、左上对角线、右上对角线
            // 列方向
            for i in 0..<row {
                if chars[i][col] == "Q" {
                    return false
                }
            }
            
            // 左上对角线
            var i = row - 1
            var j = col - 1
            while i >= 0, j >= 0 {
                if chars[i][j] == "Q" { return false }
                i -= 1
                j -= 1
            }
            
            // 右上对角线
            i = row - 1
            j = col + 1
            while i >= 0, j < n {
                if chars[i][j] == "Q" { return false }
                i -= 1
                j += 1
            }
            return true
        }
        
        func backtracking(row: Int, chars: inout [[Character]]) {
            if row == n {
                var tmpResult: [String] = []
                for i in 0..<n {
                    tmpResult.append(String(chars[i]))
                }
                result.append(tmpResult)
            }
            
            // n个位置有可能防止棋子
            for i in 0..<n {
                if isOK(row: row, col: i, chars: chars) {
                    chars[row][i] = "Q"
                    backtracking(row: row + 1, chars: &chars)
                    chars[row][i] = "."
                }
            }
        }
        backtracking(row: 0, chars: &chars)
        return result
    }
    /// https://leetcode.cn/problems/sudoku-solver/
    func solveSudoku(_ board: inout [[Character]]) {
        // 该问题最关键的是，给定一个[row, col]，如何限定出这个元素所在的数独3*3区间
        // 回溯结束的条件是有两个，1是发现已经过了最后一行，说明所有的空格子都填满了，问题解找到了，这是问题的解；2是任意一行在决策时，发现没有填满就可以退出了。
        var solved = false
        
        func isOK(row: Int, col: Int, value: Character) -> Bool {
            // 所在行不能有与value相等的值
            for j in 0..<9 {
                if board[row][j] == value { return false }
            }
            // 所在列不能有与value相等的值
            for i in 0..<9 {
                if board[i][col] == value { return false }
            }
            // row、col所在的3*3区域，不能有相等的值
            var minI = 0
            var minJ = 0
            var maxI = 0
            var maxJ = 0
            if row > 5 {
                minI = 6
            } else if row > 2 {
                minI = 3
            } else {
                minI = 0
            }
            maxI = minI + 2
            
            if col > 5 {
                minJ = 6
            } else if col > 2 {
                minJ = 3
            } else {
                minJ = 0
            }
            maxJ = minJ + 2
            
            for i in minI...maxI {
                for j in minJ...maxJ {
                    if board[i][j] == value { return false }
                }
            }
            return true
        }
        
        func backtracking(row: Int, col: Int) {
            // 先写核心骨架代码
            // row和col表示上次填写内容的地方，本次依次为起点进行新的填写
            // 算法总体思想是，将棋盘中的每个有空格的地方都看做回溯算法的一个决策阶段
            // 找到一个未填充的地方
            var i = row
            var j = col
            while i < 9, j < 9, board[i][j] != "." {
                if j == 8 {
                    j = 0
                    i += 1
                } else {
                    j += 1
                }
            }
            
            if i >= 9 || j >= 9 {
                // 已经没有需要填充的格子了，说明已经成功完成填充
                solved = true
                return
            }
            
            // 为(i, j)位置填充元素
            for guess in 1...9 {
                let char = Character("\(guess)")
                if isOK(row: i, col: j, value: char) {
                    board[i][j] = char
                    backtracking(row: i, col: j)
                    if solved { return }
                    board[i][j] = "."
                }
            }
        }
        backtracking(row: 0, col: 0)
    }
    
    /// https://leetcode.cn/problems/letter-combinations-of-a-phone-number/
    func letterCombinations(_ digits: String) -> [String] {
        // 输入的digits中，每个数字表示多阶段决策模型中的一个阶段
        // 每个阶段可以选择的字符各不相同
        // 回溯方法参数至少需要两个，阶段数（digits的索引）和当前路径
        // 回溯结束条件，index == digits.count
        if digits.isEmpty { return [] }
        let dicts: [Character: [Character]] = [
            "2" : ["a","b","c"],
            "3" : ["d","e","f"],
            "4" : ["g","h","i"],
            "5" : ["j","k","l"],
            "6" : ["m","n","o"],
            "7" : ["p","q","r","s"],
            "8" : ["t","u","v"],
            "9" : ["w","x","y","z"]
        ]
        var result: [String] = []
        var chars: [Character] = []
        func backtracking(index: Int, chars: inout [Character]) {
            // 核心逻辑，遍历可选择字符列表，从中选一个，继续递归
            let strIndex = digits.index(digits.startIndex, offsetBy: index)
            if strIndex == digits.endIndex {
                // 结束了
                result.append(String(chars))
                return
            }
            guard let list = dicts[digits[strIndex]] else {
                return
            }
            for tmpChar in list {
                chars.append(tmpChar)
                backtracking(index: index+1, chars: &chars)
                chars.removeLast()
            }
        }
        backtracking(index: 0, chars: &chars)
        return result
    }
    
    /// https://leetcode.cn/problems/subsets/
    func subsets(_ nums: [Int]) -> [[Int]] {
        // 分nums.count个阶段
        // 对于nums中的每个元素，都有放与不放（放到结果集中）的选择，所有选择的组合就构成了所有子集
        // 回溯方法有一个表示阶段（也可当做作nums下标取数据），和path
        var result: [[Int]] = []
        var path: [Int] = []
        func backtracking(k: Int, path: inout [Int]) {
            if k == nums.count {
                result.append(path)
                return
            }
            // 放
            path.append(nums[k])
            backtracking(k: k+1, path: &path)
            path.removeLast()
            // 不放
            backtracking(k: k+1, path: &path)
        }
        backtracking(k: 0, path: &path)
        return result
    }
    
    /// https://leetcode.cn/problems/subsets-ii/
    func subsetsWithDup(_ nums: [Int]) -> [[Int]] {
        // 该问题不好想，如果按照普通子集的解法，最后进行去重，也可以工作，但效率会降低
        // 本次实现一个一次性搞定的算法
        // 关键点在于，先统计一下nums中每个数出现的次数
        // 如[1,2,2,5]，统计结果为[1:1, 2,2, 5:1]
        // 进行回溯时，分为1、2、5三个阶段，每个阶段要做的事情是，决定当前阶段的可选择值，放置0、1、2...还是多个
        var hashMap: [Int: Int] = [:]
        for num in nums {
            if let count = hashMap[num] {
                hashMap[num] = count + 1
            } else {
                hashMap[num] = 1
            }
        }
        var newNums: [(Int, Int)] = []
        for item in hashMap.enumerated() {
            newNums.append((item.element.key, item.element.value))
        }
        
        var result: [[Int]] = []
        var path: [Int] = []
        
        func backtracking(k: Int, path: inout [Int]) {
            if k == newNums.count {
                result.append(path)
                return
            }
            
            // 不放
            backtracking(k: k+1, path: &path)
            
            // 放1-n个
            for count in 1...newNums[k].1 {
                for _ in 0..<count {
                    path.append(newNums[k].0)
                }
                backtracking(k: k+1, path: &path)
                for _ in 0..<count {
                    path.removeLast()
                }
            }
        }
        backtracking(k: 0, path: &path)
        return result
    }
    /// https://leetcode.cn/problems/combinations/
    func combine(_ n: Int, _ k: Int) -> [[Int]] {
        // 最终要返回的是k个元素的集合，那就看做k个阶段的决策模型
        // 每个阶段从1...n中选择一个数，不能重复
        
        var result: [[Int]] = []
        var path: [Int] = []
        
        /// r从0开始
        func backtracking(r: Int, path: inout [Int]) {
            if r == k {
                result.append(path)
                return
            }
            // 另一个关键点在于
            var begin = path.last != nil ? path.last! + 1 : 1
            while begin <= n {
                path.append(begin)
                backtracking(r: r+1, path: &path)
                path.removeLast()
                begin += 1
            }
        }
        backtracking(r: 0, path: &path)
        return result
    }
    
    /// https://leetcode.cn/problems/permutations/
    func permute(_ nums: [Int]) -> [[Int]] {
        var result: [[Int]] = []
        var path: [Int] = []
        
        func backtracking(step: Int, path: inout [Int]) {
            if step == nums.count {
                result.append(path)
                return
            }
            
            for num in nums {
                if path.contains(num) { continue }
                path.append(num)
                backtracking(step: step + 1, path: &path)
                path.removeLast()
            }
        }
        backtracking(step: 0, path: &path)
        return result
    }
    
    /// https://leetcode.cn/problems/permutations-ii/
    func permuteUnique(_ nums: [Int]) -> [[Int]] {
        // 该问题的关键在于剪枝
        // 之前做过使用used数组进行剪枝的操作，但本次刷题时就已经忘了这种逻辑
        // 但发现一种新去重逻辑，此处进行实现，估计以后还是会忘掉
        // 使用哈希表进行去重
        // 比如[1,1,2]这种数据，如果统计成哈希表的话，[1: 2, 2: 1]
        // 进行回溯时，有1和2两种选择，比如第一次选择了1，继续选择时还有一个1和一个2可以选择。这样就把第一次选择两次1的情况过滤掉了
        // 另外，当第一次选择2时，第二次选择的时候，其实就只能选择1个1，这就又把第2次选择时，选择两次1的情况过滤掉了
        // 为了使用方便，其实存储下来并不是一个真正的哈希表，而是两个数组
        
        var hashMap: [Int: Int] = [:]
        for num in nums {
            if let count = hashMap[num] {
                hashMap[num] = count + 1
            } else {
                hashMap[num] = 1
            }
        }
        let newNums = hashMap.keys.map({ $0 })
        var result: [[Int]] = []
        var path: [Int] = []
        func backtracking(step: Int, path: inout [Int]) {
            if step == nums.count {
                result.append(path)
                return
            }
            
            // 遍历newNums，如果能用就用
            for num in newNums {
                if hashMap[num]! <= 0 { continue }
                path.append(num)
                hashMap[num] = hashMap[num]! - 1
                backtracking(step: step + 1, path: &path)
                path.removeLast()
                hashMap[num] = hashMap[num]! + 1
            }
        }
        backtracking(step: 0, path: &path)
        return result
    }
    
    /// https://leetcode.cn/problems/permutations-ii/
    func permuteUnique1(_ nums: [Int]) -> [[Int]] {
        // 再使用used数组剪枝实现一次
        // 该思路的核心是，在非重复数字全排列的骨架代码下加入剪枝逻辑
        // 剪枝关键点有几个：排序
        let newNums = nums.sorted()
        var used = Array(repeating: false, count: nums.count)
        var result: [[Int]] = []
        var path: [Int] = []
        
        func backtracking(step: Int, path: inout [Int]) {
            if step == newNums.count {
                result.append(path)
                return
            }
            
            for i in 0..<newNums.count {
                if used[i] { continue }
                // 关键点
                if i > 0, newNums[i] == newNums[i-1], !used[i-1] { continue }
                path.append(newNums[i])
                used[i] = true
                backtracking(step: step + 1, path: &path)
                used[i] = false
                path.removeLast()
            }
        }
        backtracking(step: 0, path: &path)
        return result
    }
    
    /// https://leetcode.cn/problems/combination-sum/
    func combinationSum(_ candidates: [Int], _ target: Int) -> [[Int]] {
        // 多阶段
        // 每个阶段在candidates中选取，但不能是用过的，否则结果会重复
        // 就以[2,3,6,7]为例，我们分为4个阶段
        // 第一个阶段，可以选择0、1、2、3个2；第二阶段根据第一阶段剩余的值，继续第三阶段，第四阶段
        var result: [[Int]] = []
        var path: [Int] = []
        
        func backtracking(step: Int, left: Int, path: inout [Int]) {
            if left == 0 {
                result.append(path)
                return
            }
            
            if step == candidates.count { return }
            // 最多几个candidates[i]？left/candidates[i]
            for i in 0...left/candidates[step] {
                // 分别向path中添加i个元素
                for _ in 0..<i {
                    path.append(candidates[step])
                }
                backtracking(step: step+1, left: left - i*candidates[step], path: &path)
                for _ in 0..<i {
                    path.removeLast()
                }
            }
        }
        backtracking(step:0, left: target, path: &path)
        return result
    }
    
    /// https://leetcode.cn/problems/combination-sum-ii/
    func combinationSum2(_ candidates: [Int], _ target: Int) -> [[Int]] {
        // 将candidates进行哈希统计
        // 以[2,5,2,1,2]为例，统计后[1:1, 2:3, 5:1]
        // 分1、2、5三个阶段进行决策
        // 递归结束条件，有两个，left为0时；step到达时
        
        var hashMap: [Int: Int] = [:]
        for num in candidates {
            if let count = hashMap[num] {
                hashMap[num] = count + 1
            } else {
                hashMap[num] = 1
            }
        }
        let candidates = hashMap.keys.map({ $0 })
        
        var result: [[Int]] = []
        var path: [Int] = []
        func backtracking(step: Int, left: Int, path: inout [Int]) {
            if left == 0 {
                result.append(path)
                return
            }
            if step == candidates.count {
                return
            }
            
            // 判断可以选择几个当前阶段对应的candidate
            let count = min(left/candidates[step], hashMap[candidates[step]]!)
            let candidate = candidates[step]
            for i in 0...count {
                for _ in 0..<i {
                    path.append(candidate)
                    hashMap[candidate] = hashMap[candidate]! - 1
                }
                backtracking(step: step + 1, left: left - i*candidate, path: &path)
                for _ in 0..<i {
                    path.removeLast()
                    hashMap[candidate] = hashMap[candidate]! + 1
                }
            }
        }
        backtracking(step: 0, left: target, path: &path)
        return result
    }
}

