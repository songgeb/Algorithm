//
//  main.swift
//  Algorithm-Swift
//
//  Created by songgeb on 2019/1/14.
//  Copyright © 2019 Songgeb. All rights reserved.
//

import Foundation

print("Hello, World!")
// MARK: - 数组
//print(replaceSpace("bcaa aaec"))
// 0表示没有数据
//var A = [1, 2, 3, 0, 0, 0]
//let B = [2, 5, 6]
//merge(&A, 3, B, 3)
//print(A)

// MARK: - 链表
//let listNode = LinkedList().createLinkedList([9, 7, 8]).head
//print(reversePrint(listNode))
//let node = LinkedList().reverseList1(listNode)
//LinkedList().printList(node)

// Stack
//Solution().validateStackSequences1([1,2,3,4,5], [4,5,3,2,1])

// MARK: - Tree
//let root = buildTree([3,9,20,15,7], [9,3,15,20,7])
//Tree.preTraversal(root)
//print("-----")
//Tree.inTraversal(root)
//print(verifyPostorder([4, 8, 6, 12, 16, 14, 10]))

// MARK: - 排序

//var ages = [Int]()
//for i in 0...20000 {
//    let age = Int.random(in: 1...100)
//    ages.append(age)
//}
//
//SolutionS().sortAges(&ages)
//print(ages)

// MARK: 选择排序

func selectionSort() {
    print("选择排序")
    var array: [Int] = [6, 5, 4, 3]
    //1. 先遍历一遍数组，找出其中最小的值；
    //2. 再讲找出来的最小值和第一个位置的值交换
    //3. 重复1、2过程，但注意遍历时要从第二个元素开始遍历，因为之前的元素已经排好序
    //4. 重复执行1、2过程n-1次即可
    
    //感觉实际写算法时并不好下手，比如外层循环多少次
    for index in stride(from: 0, to: array.count, by: 1) {
        var min = index
        //index位置等待交换
        for startCursor in stride(from: index + 1, to: array.count, by: 1) {
            if array[startCursor] < array[min] {
                min = startCursor
            }
            print("比较")
        }
        //index 和 min交换
        array.swapAt(index, min)
        print("交换")
    }
    
    print(array)
}

//selectionSort()

// MARK: 插入排序

public func insertionSort() {
    print("插入排序")
    //1. 从第一个元素起（第二个也可以），想办法将它插入到前面的序列中，因为前面序列已经是有序的了
    //2. 如何插入到前面的有序序列呢？和它前一个比较，如果比前面的小，就和前面的交换，直到比前面的大
    //3. 重复1、2过程，直到遍历到最后一个元素
    var array = [2, 1, 9, 8, 6]
    var current = 1
    while current < array.count {
        var j = current
        //这里面有坑, 当前的和当前的前一个比较，如果当前小于前一个，则交换，并且继续比较下去（写代码时很容易忽略继续比较下去的关键点，即j要减一，且要用j和j-1比较，不能用current和j比较）
        while j > 0 && array[j] < array[j - 1] {
            array.swapAt(j-1, j)
            j -= 1
        }
        current += 1
    }
    
    print(array)
}

//insertionSort()

// MARK: - 递归
//print(Recursion().fib(45))
//print(Recursion().climbStairs(45))

// MARK: - 位运算
//print(Bit().hammingWeight(-8))
//print(Bit().judge2Power(218))
//print(Bit().changeCount(10, 13))
//print(Bit().differentLetters("abcccwwww"))

// MARK: - 字符串匹配
//print(AString().maxFreq("abcde", 2, 3, 3))
//print(AString().maxFreq1("aababcaab", 2, 3, 4))

// MARK: - 回溯算法
let matrix: [[Int]] = [[1, 4, 7, 11, 15],
                       [2, 5, 8, 13, 19],
                       [3, 6, 9, 16, 22],
                       [10, 13, 14, 17, 24],
                       [18, 21, 23, 26, 30]]

//print(Other().searchMatrix(matrix, 18))
//EightQueen().cal8Queeens(0)
//calABC()

let board: [[Character]] = [["A", "B", "C", "E"],
                            ["S", "F", "C", "S"],
                            ["A", "D", "E", "E"]]
//print(exist(board, "ADEE"))
//subsets([1, 2, 3])
//print(subsets111([1, 2, 3]))
//print(generateParenthesis(3))
//generateParenthesis1(3)
//print(permutation("baa"))
//print(permutation2("123"))
//print(combinex(4, 3))
//print(subsets2([1,2]))
//print(check())
//print(check2())

// MARK: - 动态规划
//check()
//check_dynamic(coins: [1, 3, 5], total: 9)
//print(check_dp(coins: [1, 8, 20], total: 32))
//yanghui()
//increasingSubSequence([2,9,3,6,5,1,7])
//print(lengthOfLIS([4, 10, 4, 3, 8, 9]))

//print(lengthOfLongestSubstring("pwwkew"))

// MARK: - other
//print(myPow1(2.0, 10))
//print(printNumbers(5))
//print(printNumbers1(5).count)
//var array = [1, 2, 3, 4]
//print(exchange(&array))
//print(spiralOrder([[1,2,3],[4,5,6],[7,8,9]]))
//reversePairs([7, 5, 6, 4])
//isStraight([0,0,8,5,4])
//strToInt("-9")


// MARK: -
let sss = "A man, a plan, a canal: Panama"
//isPalindrome(sss)

//print(spiralOrder1([[1,2,3],[4,5,6],[7,8,9]]))

//print(canJump([0,2,3]))
//print(divingBoard(1, 1, 1000))

// 栈
//print(calculate("1+1+1"))
//trap([4,2,0,3,2,5])
// 递归
//numWays(10)
//Solution1().numWays(10)
//let list1 = LinkedList().createLinkedList([5]).head
//let list2 = LinkedList().createLinkedList([1, 3, 4]).head
//let list3 = Solution1().mergeTwoLists(list1, list2)
//LinkedList().printList(list3)


//print(Solution1().myPow4(0.00001, 2147483647))
//Solution1().multiply(918795921, 1)
//print(xx)

//BinarySearch().searchRange([1,4], 4)
//BinarySearch().peakIndexInMountainArray([24,69,100,99,79,78,67,36,26,19])
//BinarySearch().search1([1,3], 3)

//BinaryTree().verifyPostorder([1,3,2,6,5])
//BackTracking().subsetsWithDup([1,2,2])
//BackTracking().permuteUnique([1,1,2])
//BackTracking().combinationSum([2,3,6,7], 7)
//BackTracking().combinationSum3(3, 7)
//let xx = BackTracking().restoreIpAddresses("25525511135")
//print(xx)


var dicts = [1: 2, 3: 4]

for dict in dicts {
    print(dict)
    dicts.removeValue(forKey: 1)
}

for dict in dicts {
    print(dict)
}

var array = [1,2,3,4]

var arr = NSMutableArray(array: array)

for i in arr {
    arr.remove(i)
}
