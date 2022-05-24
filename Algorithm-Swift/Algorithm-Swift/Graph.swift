//
//  Graph.swift
//  Algorithm-Swift
//
//  Created by songgeb on 2022/5/20.
//  Copyright © 2022 Songgeb. All rights reserved.
//

import Foundation

class Graph {
    
    /// https://leetcode.cn/problems/color-fill-lcci/
    func floodFill(_ image: [[Int]], _ sr: Int, _ sc: Int, _ newColor: Int) -> [[Int]] {
        // 深度优先搜索算法皆可以搞定
        // 注意要有一个visited数组，表示某个位置是否已经遍历过了
        // 每个阶段可选列表，探测四个方向，并且visited没有探测过
        // dfs何时结束，自动结束即可
        if image.isEmpty { return image }
        var newImage = image
        var visited: [[Bool]] = Array(repeating: Array(repeating: false, count: image[0].count), count: image.count)
        let rowCount = image.count
        let colCount = image[0].count
        func dfs(row: Int, col: Int) {
            // 填充颜色+标记为已读
            newImage[row][col] = newColor
            visited[row][col] = true
            // 从row、col开始探测，四个方向
            for direction in [(-1,0),(1,0),(0,-1),(0,1)] {
                let targetRow = row + direction.0
                let targetCol = col + direction.1
                if targetRow >= rowCount || targetRow < 0 { continue }
                if targetCol >= colCount || targetCol < 0 { continue }
                if visited[targetRow][targetCol] { continue }
                if image[targetRow][targetCol] != image[row][col] { continue }
                dfs(row: targetRow, col: targetCol)
            }
        }
        dfs(row: sr, col: sc)
        return newImage
    }
    
    /// https://leetcode.cn/problems/number-of-islands/
    func numIslands(_ grid: [[Character]]) -> Int {
        // 找到一个1，然后一直dfs遍历，遍历结束后就找到1个岛屿
        // 直到所有节点都遍历过了
        var result = 0
        if grid.isEmpty { return 0 }
        let rowCount = grid.count
        let colCount = grid[0].count
        var visited: [[Bool]] = Array(repeating: Array(repeating: false, count: colCount), count: rowCount)
        func dfs(row: Int, col: Int) {
            // dfs，一直到达visited为true或者
            visited[row][col] = true
            
            for direction in [(-1, 0), (1, 0), (0, -1), (0, 1)] {
                let newRow = row + direction.0
                let newCol = col + direction.1
                if newRow >= rowCount || newRow < 0 { continue }
                if newCol >= colCount || newCol < 0 { continue }
                if visited[newRow][newCol] { continue }
                if grid[newRow][newCol] != "1" { continue }
                dfs(row: newRow, col: newCol)
            }
        }
        
        for i in 0..<rowCount {
            for j in 0..<colCount {
                if visited[i][j] || grid[i][j] != "1" { continue }
                dfs(row: i, col: j)
                result += 1
            }
        }
        return result
    }
    
    /// https://leetcode.cn/problems/pond-sizes-lcci/
    func pondSizes(_ land: [[Int]]) -> [Int] {
        // 和上一题很类似
        // 区别点在于，这次要计算入对角线，深度优先遍历时要计算水域大小（即值为0的格子个数），且最后结果要从大到小输出
        // 结果从大到小输出，直接排个序就好了
        if land.isEmpty { return [] }
        var result: [Int] = []
        var waterSize = 0
        let rowCount = land.count
        let colCount = land[0].count
        var visited: [[Bool]] = Array(repeating: Array(repeating: false, count: colCount), count: rowCount)
        
        func dfs(row: Int, col: Int) {
            visited[row][col] = true
            waterSize += 1
            
            for direction in [(-1, 0), (1, 0), (0, -1), (0, 1), (-1, -1), (-1, 1), (1, -1), (1,1)] {
                let newRow = row + direction.0
                let newCol = col + direction.1
                if newRow >= rowCount || newRow < 0 { continue }
                if newCol >= colCount || newCol < 0 { continue }
                if visited[newRow][newCol] { continue }
                if land[newRow][newCol] != 0 { continue }
                dfs(row: newRow, col: newCol)
            }
        }
        
        for i in 0..<rowCount {
            for j in 0..<colCount {
                if visited[i][j] { continue }
                if land[i][j] != 0 { continue }
                waterSize = 0
                dfs(row: i, col: j)
                result.append(waterSize)
            }
        }
        
        return result.sorted()
    }
    
    /// https://leetcode.cn/problems/route-between-nodes-lcci/
//    func findWhetherExistsPath(_ n: Int, _ graph: [[Int]], _ start: Int, _ target: Int) -> Bool {
//
//    }
    
    /// https://leetcode.cn/problems/course-schedule/
    func canFinish(_ numCourses: Int, _ prerequisites: [[Int]]) -> Bool {
        // 用Kahn算法试一下
        // 构建一个课程依赖关系表，维护每个课程及其对应的前置课程的数量
        // 然后寻找依赖数为0的的课程开始上课，上一次课就更新关系表
        // 何时停止？列表为空时，说明所有课程都学完了；否则，当找不到依赖数为0的课程时，说明课程无法再继续执行下去了
        // 遍历numsCourses，初始化关系表
        var hashMap: [Int: Int] = [:]
        for course in 0..<numCourses {
            hashMap[course] = 0
        }
        
        // 遍历前置课程列表，构建关系表
        for item in prerequisites {
            if let count = hashMap[item[0]] {
                hashMap[item[0]] = count + 1
            } else {
                hashMap[item[0]] = 1
            }
        }
        // 遍历哈希表，初始化zeroset
        var zeroSet: [Int] = []
        for item in hashMap {
            if item.value == 0 {
                zeroSet.append(item.key)
            }
        }
        // 开始上课（为了优化性能，新增一个zeroset）
        // 如果zeroset不为空就要开始上课
        // 否则，关系表中是否还有数据
        while !zeroSet.isEmpty {
            let course = zeroSet.removeLast()
            hashMap.removeValue(forKey: course)
            
            // course已经完成上课，需要看下哪些课程的依赖关系发生了变化
            // 遍历pre数组，只要发现item[1] == course，就记录下item[0]
            // 更新关系表，hashMap[item[0]] = hashMap[item[0]] - 1
            for item in prerequisites {
                if item[1] == course {
                    hashMap[item[0]] = hashMap[item[0]]! - 1
                    if hashMap[item[0]] == 0 {
                        zeroSet.append(item[0])
                    }
                }
            }
        }
        return hashMap.isEmpty
    }
    
    /// https://leetcode.cn/problems/jump-game-iii/
    func canReach(_ arr: [Int], _ start: Int) -> Bool {
        // 典型的回溯、dfs问题
        // 可选列表：按照i+arr[i]和i-arr[i]的规则跳就好了
        // 结束条件：
        // 1. 跳到value为0的index即可
        // 2. 有没有可能跳起来无法停止？貌似有可能？所以要记录一个visited数组，都遍历完了都没有抵达就说明完全不可达
        let count = arr.count
        var visited = Array(repeating: false, count: count)
        func dfs(index: Int) -> Bool {
            visited[index] = true
            if arr[index] == 0 {
                return true
            }
            
            var success = false
            let forwardIndex = index + arr[index]
            if forwardIndex < count, !visited[forwardIndex] {
                success = dfs(index: forwardIndex) || success
            }
            
            if success { return true }
            
            let backwardIndex = index - arr[index]
            if backwardIndex >= 0, !visited[backwardIndex] {
                success = dfs(index: backwardIndex) || success
            }
            return success
        }
        return dfs(index: start)
    }
    
    /// https://leetcode.cn/problems/open-the-lock/
    func openLock(_ deadends: [String], _ target: String) -> Int {
        // 用BFS实现更合理点
        // 从0000，到达target的最短路径
        // 广度遍历时，每次都有8种可能的情况
        // 使用一个队列（数组模拟）存放每一种可能，只要队列不为空，就要一直遍历。当然，如果遇到死锁的情况，就不用再向队列中添加了
        // 如果一旦遇到了target就可以退出了
        // 需要一个变量，来记录旋转的次数
        // 每次大循环要做的事情有：（即每一层）
        // 子循环共循环该层的元素个数次，子循环中要做的事情
        // 1. 8种情况得到的元素找出来，看有没有target，看是不是死锁。
        // 2. 如果是target，则找到目标，返回count；如果是死锁，则不加入到队列中；否则加入到队列中
        // 需要做些优化，添加一个visited集合，避免重复访问
        // 将deadends加入到集合中，避免判断contains时耗时多
        var deadendsSet: Set<String> = []
        for deadend in deadends {
            deadendsSet.insert(deadend)
        }
        
        var visited: Set<String> = []
        var queue: [String] = []
        var count = 0
        let initialStr = "0000"
        if deadendsSet.contains(initialStr) { return -1 }
        visited.insert(initialStr)
        if initialStr == target { return 0 }
        queue.append(initialStr)
        
        while !queue.isEmpty {
            let itemCount = queue.count
            count += 1 // 旋转一次
            for _ in 0..<itemCount {
                // 8种情况
                let chars = Array(queue.first!)
                queue.removeFirst()
                for j in 0..<4 {
                    for delta in [-1, 1] {
                        guard let num = chars[j].wholeNumberValue else {
                            continue
                        }
                        var newChars = chars
                        let newNum = ((num + delta) + 10) % 10
                        newChars[j] = Character("\(newNum)")
                        let newStr = String(newChars)
                        if visited.contains(newStr) { continue }
                        if newStr == target {
                            return count
                        } else {
                            if !deadendsSet.contains(newStr) {
                                queue.append(newStr)
                            }
                        }
                        visited.insert(newStr)
                    }
                }
            }
        }
        return -1
    }
    
    /// https://leetcode.cn/problems/word-transformer-lcci/
    func findLadders(_ beginWord: String, _ endWord: String, _ wordList: [String]) -> [String] {
        // 只能用dfs，因为要记录路径
        // 图上的dfs遍历
        // 核心操作，从wordList中找到beginWord的相邻元素，进行深度遍历
        var reached = false
        var path: [String] = []
        var result: [String] = []
        var visited: Set<String> = []
        
        func isOK(_ word1: String, _ word2: String) -> Bool {
            var diff = 0
            var index1 = word1.startIndex
            var index2 = word2.startIndex
            while index1 < word1.endIndex, index2 < word2.endIndex {
                if word1[index1] != word2[index2] {
                    diff += 1
                }
                index1 = word1.index(index1, offsetBy: 1)
                index2 = word2.index(index2, offsetBy: 1)
            }
            return diff == 1
        }
        
        func dfs(beginWord: String, path: inout [String]) {
            // 遍历wordList，找到相邻的元素，继续深度遍历
            if reached { return }
            
            visited.insert(beginWord)
            path.append(beginWord)
            if beginWord == endWord {
                result = path
                reached = true
                return
            }
            
            for word in wordList {
                if visited.contains(word) { continue }
                if isOK(beginWord, word) {
                    dfs(beginWord: word, path: &path)
                }
            }
            path.removeLast()
        }
        dfs(beginWord: beginWord, path: &path)
        return result
    }
    
    /// https://leetcode.cn/problems/route-between-nodes-lcci/
    func findWhetherExistsPath(_ n: Int, _ graph: [[Int]], _ start: Int, _ target: Int) -> Bool {
        // 构建图，会容易遍历
        // 使用邻接表构建
        var adj: [Set<Int>] = Array(repeating: [], count: n)
        for edge in graph {
            var set = adj[edge[0]]
            set.insert(edge[1])
            adj[edge[0]] = set
        }
        
        // 使用dfs，从start进行深度遍历
        var visited = Array(repeating: false, count: n)
        // dfs写法
        // 进入遍历逻辑，遍历当前节点，标记visited，寻找相邻的节点，继续递归遍历
        // 如果找到target，则返回，并标记整个流程结束(success)
        var success = false
        func dfs(curNode: Int) {
            if success { return }
            visited[curNode] = true
            if curNode == target {
                success = true
                return
            }
            
            let nodes = adj[curNode]
            for node in nodes {
                if visited[node] { continue }
                dfs(curNode: node)
            }
        }
        dfs(curNode: start)
        return success
    }
    
    /// https://leetcode.cn/problems/ji-qi-ren-de-yun-dong-fan-wei-lcof/
    func movingCount(_ m: Int, _ n: Int, _ k: Int) -> Int {
        // 使用dfs
        // 配合visited标记
        // 1. 开始遍历时，标记visited已经访问，记录访问数
        // 2. 探测四个方向，如果可以就继续访问
        
        var visited = Array(repeating: Array(repeating: false, count: n), count: m)
        var count = 0
        
        func isOK(i: Int, j: Int, k: Int) -> Bool {
            var sum = 0
            var newI = i
            var newJ = j
            while newI != 0 {
                sum += newI % 10
                newI /= 10
            }
            
            while newJ != 0 {
                sum += newJ % 10
                newJ /= 10
            }
            return sum <= k
        }
        
        func dfs(i: Int, j: Int) {
            visited[i][j] = true
            count += 1
            // 四个方向进行探测
            for direction in [(-1, 0), (1,0), (0, -1), (0, 1)] {
                let newI = i + direction.0
                let newJ = j + direction.1
                // 计算数位和
                if newI < 0 || newI >= m || newJ < 0 || newJ >= n { continue }
                if visited[newI][newJ] { continue }
                if isOK(i: newI, j: newJ, k: k) {
                    dfs(i: newI, j: newJ)
                }
            }
        }
        dfs(i: 0, j: 0)
        return count
    }
    
    /// https://leetcode.cn/problems/word-search/
    func exist(_ board: [[Character]], _ word: String) -> Bool {
        // 从任何一个格子开始，每选择一个格子，就判断当前格子选择的有无问题
        // 要避免重复选择格子，使用visited标记
        // 每一次格子选择过程结束后，要讲visited重置
        // dfs中要记录step
        if board.isEmpty { return false }
        var success = false
        var targetWord: [Character] = []
        for c in word {
            targetWord.append(c)
        }
        let rowCount = board.count
        let colCount = board[0].count
        var visited = Array(repeating: Array(repeating: false, count: colCount), count: rowCount)
        func dfs(step: Int, i: Int, j: Int) {
            if success {
                return
            }
            
            if targetWord[step] != board[i][j] {
                return
            }
            
            if step == targetWord.count-1 {
                success = true
                return
            }
            
            visited[i][j] = true
            // 四个方向探测
            for direction in [(-1, 0), (1, 0), (0, -1), (0, 1)] {
                let newI = i + direction.0
                let newJ = j + direction.1
                if newI < 0 || newI >= rowCount || newJ < 0 || newJ >= colCount { continue }
                if visited[newI][newJ] { continue }
                dfs(step: step + 1, i: newI, j: newJ)
            }
            visited[i][j] = false
        }
        
        for i in 0..<rowCount {
            for j in 0..<colCount {
                dfs(step: 0, i: i, j: j)
            }
        }
        return success
    }
}
