# 快排Partition笔记

快排的关键是`分区`函数如何写

- 划分算法比较巧妙
- 一个指针i，表示[left, i-1]范围的元素都是已经划分好的
- 一个指针j，表示[j, right - 1]都是没有划分好的，j就是待检查的元素指针
- i和j都从left开始，我们选择right位置作为pivot
- i始终指在待交换位置，j则是遍历指针
- j遍历开始后，若arr[j] < pivot，说明要和arr[i]进行交换，以实现j元素的划分，同时，i要前进
- 遍历结束后，让i和right交换一下，让pivot回到合适的位置

```
func partition(_ left: Int, _ right: Int) -> Int {
	if left == right { return left }
	if left > right { fatalError() }
     
     var i = left
     let pivot = arr[right]
     for j in left...right-1 {
     	if arr[j] < pivot {
     		arr.swapAt(i, j)
	     	i += 1
     	}
     }
     arr.swapAt(i, right)
     return i
}
```