# 二叉树的X序遍历（非递归实现）

二叉树的X序遍历的非递归代码，想准确无误的写出来并不是件容易事，主要还是，1先得有思路；2将思路转化为可实现的代码。这两点不容易实现

而且坦白讲，我看了几个实现之后，虽然算法能看懂，但感觉如果换做自己写，不一定能写出来。所以本文记录下自己思考过程和代码实现，作为备忘。

## 前序遍历

总体的思路和方法我们是知道的，无非要借助一个**栈结构**，其目的是模拟从子节点到父节点的回溯过程

关键是解决具体细节问题，让整个遍历思路完整、准确

- 先不考虑代码如何实现，想下手工遍历的实现流程
- 首先找到树最左下的叶子节点，打印叶子节点，这是第一个输出
	- 注意寻找左下节点的同时，要将节点入栈
- 然后此时可能会有两种情形，如下面代码所示，当前都在2叶子节点
	
	```
	   1                   2
	2     3      或          3
	```
- 对于第一种情况，应该去找2的父节点的右子树即值为3的节点；而情况二，则是直接找2的右子节点
- 上面两种情况可以继续抽象为一件事情，就是**找最近的右子树**
- 针对这个遍历过程，每次循环其实都在做
	- 找到最左下叶子节点，并将经过的节点入栈，同时节点值加入结果集
	- 找最近右子树，切换到右子树上，同时将找过程中经历的节点弹出
	- 继续这三个步骤
- 至于循环的停止条件，是找不到可遍历节点为止。据此我们写代码看下

```
func preorderTraversal(_ root: TreeNode?) -> [Int] {
        guard let root = root else { return [] }
        let stack = Stack<TreeNode>()
        var p: TreeNode? = root
        var result: [Int] = []
        while p != nil {
            while let pp = p {
                stack.push(pp)
                result.append(pp.val)
                p = p?.left
            }
            // 找到最近右子树
            while !stack.isEmpty, p == nil {
                p = stack.pop()?.right
            }
        }
        return result
    }
```

## 中序遍历

- 也是先走到最左下的叶子节点，不过经过的节点只加入到栈中，不能输出到结果集
- 先将当前叶子节点输出到结果集，然后将游标p切换为叶子节点的右子树，同时将叶子节点弹出
- 只要p不为空或stack不是空，循环就继续

```
func inorderTraversal(_ root: TreeNode?) -> [Int] {
        guard let root = root else { return [] }
        var result: [Int] = []
        let stack = Stack<TreeNode>()
        
        var p: TreeNode? = root
        // 此处判断条件多了一个!stack.isEmpty，这是必须的，因为假设当前节点的父节点没有右子树，打印完当前节点后弹出，切换到右节点时发现是空，但stack中还有父节点，所以循环不能停
        while p != nil || !stack.isEmpty {
            while let pp = p {
                stack.push(pp)
                p = p?.left
            }

            if let cur = stack.pop() {
                result.append(cur.val)
                p = cur.right
            }
        }
        return result
    }
```

## 后序遍历

本文使用双栈实现

- 用到两个栈，其中一个栈是用来实现**根右左**的遍历顺序，类似于先序遍历中的**根左右**
- 实现**根右左**的节点遍历过程中，将节点放入另外一个栈中
- 最后将栈内容一次弹出，就是**左右根**的后序遍历顺序



## 参考
- [二叉树后序遍历的两种易写的非递归写法](https://zhuanlan.zhihu.com/p/80578741)