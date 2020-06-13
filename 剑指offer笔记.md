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

