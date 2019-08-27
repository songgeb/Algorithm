//
//  main.swift
//  Algorithm-Swift
//
//  Created by songgeb on 2019/1/14.
//  Copyright © 2019 Songgeb. All rights reserved.
//

import Foundation

print("Hello, World!")

// MARK: - 排序

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

func insertionSort() {
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

// 链表
//LinkedList().palindromeTest()

// 队列
//QueueTest.testCircularQueue()

// 排序
//Sort.testBubbleSort()
//Sort.testInsertionSort()
//Sort.testSelectionSort()
//Sort.testMergeSort()
Sort.testPartition()

