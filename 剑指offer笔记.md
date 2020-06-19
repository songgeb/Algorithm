# 剑指offer习题笔记

## 面试题11. 旋转数组的最小数字

- 感觉该题核心根本不是考察**遇到有序数组查找问题首先去想高效的二分**这个逻辑
- 而是一些细节边界问题
- 比如有重复值情况、特殊的旋转数组情况
- 重复值情况下，二分的逻辑可能完全搞不定，所以要改用其他方法查找最小值

## 面试题18：树的子结构

输入两棵二叉树A和B，判断B是不是A的子结构

- 好题
- 这个算法具有一定复杂度，对于递归的实现，是两个递归的嵌套，非普通递归
- 递归终止条件等边界情况的注意点比较多
- 感觉该题很适合用来对编程完整性进行练习

```
   func isSubStructure(_ A: TreeNode?, _ B: TreeNode?) -> Bool {
        guard let A = A, let B = B else { return false }
        // A是否包含B子树
        // 如果A.val == B.val，则继续比较A.left B.left以及A.right B.right
        // 如果不相等，则重新找和B相等A中的节点，继续进行上面的操作
        // 终止条件：根据具体例子的尝试，发现A中节点是空时就停止递归
        // 检查边界、特殊情况：

        func doesTree1HaveTree2(_ a: TreeNode?, _ b: TreeNode?) -> Bool {
            /// 这些判断条件很关键，对应不同的情况，一定要想清楚才行
            if a == nil, b == nil { return true }
            if a == nil { return false }
            if b == nil { return true }

            // 如果两个节点值相等，则继续递归左子树和右子树，否则退出
            if a?.val == b?.val {
                return doesTree1HaveTree2(a?.left, b?.left) && doesTree1HaveTree2(a?.right, b?.right)
            }
            return false
        }

        func hasSubTree(_ A: TreeNode?, _ B: TreeNode) -> Bool {
            guard let A = A else { return false }
            if A.val == B.val {
                // 比较两棵树
                let result = doesTree1HaveTree2(A, B)
                if result {
                    return true
                } else {
                    return hasSubTree(A.left, B) || hasSubTree(A.right, B)
                }
            } else {
                return hasSubTree(A.left, B) || hasSubTree(A.right, B)
            }
        }
        return hasSubTree(A, B)
    }
```

## 面试题62. 圆圈中最后剩下的数字
0,1,,n-1这n个数字排成一个圆圈，从数字0开始，每次从这个圆圈里删除第m个数字。求出这个圆圈里剩下的最后一个数字。

例如，0、1、2、3、4这5个数字组成一个圆圈，从数字0开始每次删除第3个数字，则删除的前4个数字依次是2、0、4、1，因此最后剩下的数字是3。

```
输入: n = 5, m = 3
输出: 3
```

关键是找出f(n)和f(n-1)之间的关系

- [换个角度举例解决约瑟夫环](https://leetcode-cn.com/problems/yuan-quan-zhong-zui-hou-sheng-xia-de-shu-zi-lcof/solution/huan-ge-jiao-du-ju-li-jie-jue-yue-se-fu-huan-by-as/)

## 面试题65. 不用加减乘除做加法

> 计算机使用补码存储数据，可以将正数负数的相加减规则统一，而且统一成我们平时了解的加法规则

- 两个二进制数做”异或“操作，可以完成二进制的无进位加法
- 先做与运算，再左移，相当于进位操作
- 继续执行上面两个操作，直到进位是0，就是最终结果了

```
var sum = 0
var a = a
var b = b
while b != 0 {
	sum = a ^ b
	b = (a & b) << 1
	a = sum
}
return sum
```

- [负数在计算机中如何表示？为什么用补码存储](https://leetcode-cn.com/problems/bu-yong-jia-jian-cheng-chu-zuo-jia-fa-lcof/solution/mian-shi-ti-65-bu-yong-jia-jian-cheng-chu-zuo-ji-9/)

## 面试题 16.01. 交换数字
编写一个函数，不用临时变量，直接交换numbers = [a, b]中a与b的值。

```
var a = numbers[0]
var b = numbers[1]
// a = a ^ b
// b = a ^ b
// a = a ^ b
// return [a, b]

a = a + b
b = a - b
a = a - b
return [a, b]
```