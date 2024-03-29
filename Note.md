# 算法笔记
 
我们学习数据结构和算法，要学习它的**由来**、**特性**、**适用的场景**以及**它能解决的问题**。
 
## 工具
 
### 等比数列求和公式
∑ = Sn = a1 + a2 + ... + an = a1 * (1 - qn) / (1 -q)
 
(特殊情况: 当 q = 1 时, Sn = n * a1)

### 等差数列求和公式
Sn = (a1 + an) * n / 2

#### 推导
1. 通过特殊例子来证明一下
2. Sn = 1 + 2 + ... + n
3. Sn = n + n - 1 + ... + 1
4. 2Sn = (n + 1) + (n + 1) + ... + (n + 1)
5. Sn = n * (n + 1) / 2

## 数组

### 特点
- 用于存储相同类型、连续的数据
- 由于其连续性，可以通过下标和首地址直接计算出不同位置的元素位置，从而获取该值，所以通过下标getvalue时间复杂度是O(1)

## 链表
 单链表、双链表、循环链表

### 单链表

以下单链表的操作要熟练写出

- 链表原地翻转
- 找到链表中点
- 判断链表回文数
- 链表环路检测及环起点计算
- 有序链表合并
- 删除链表倒数第n个结点

#### 哨兵
当往链表中插入一个节点时

```
pNode insertNodeN(pNode head, int pos, int value)
{
    int count;
    pNode temp;
    pNode prev = head;
    temp = (pNode)malloc(sizeof(node));
    temp->data = value;
    if(head == NULL || pos == 0){
        temp->next = head;
        return temp;
    }
    for(count = 1; count < pos && prev->next != NULL; count++){
        prev = prev->next;
    }
    temp->next = prev->next;
    prev->next = temp;      //链

    return head;
}
————————————————
版权声明：本文为CSDN博主「bg2wlj」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/bg2wlj/java/article/details/52300565
```

那如果我们用**哨兵**，即加入一个空头结点，则可以这样写
```
void insertNodeWithSentinelN(const pNode head, int pos, int value)
{
    int count;
    pNode temp;
    pNode prev = head;
    temp = (pNode)malloc(sizeof(node));
    temp->data = value;
    for(count = 0; count < pos && prev->next != NULL; count++){
        prev = prev->next;
    }
    temp->next = prev->next;
    prev->next = temp;      //链
}
————————————————
版权声明：本文为CSDN博主「bg2wlj」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/bg2wlj/java/article/details/52300565
```

哨兵的作用是用一个空节点，让代码逻辑能够统一、简洁明了，不需要额外处理空节点情况

- [带哨兵节点和不带哨兵节点的单链表操作的对比](https://blog.csdn.net/bg2wlj/article/details/52300565)

### LRU
> least recently used

- 最近使用缓存淘汰算法，保留最近使用过的数据
- 为什么做缓存？
  - 通常缓存是将一些常访问的数据存放到**内存**中，以后再用时直接在这里获取，而避免了每次都去磁盘中取数据，磁盘的IO比较耗时
  - 所以缓存的目的是为了提高读取速度，提高性能
- 链表可以实现LRU算法吗？什么优势？
  - 我想，任何数据结构，数组、链表、队列、栈都可以实现，因为LRU是一个存取缓存数据的算法，不依赖具体的数据结构（其实所有算法都是这样）
  - 选择链表要比数组好
    - LRU算法要求，当要访问的数据已经存在结构中时，要标记该元素为最近刚使用，通常需要移动该元素到数据结构的头或尾，所以可能涉及元素移动
    - 当要存储的数据超过最大缓存空间时，要删掉最远访问的数据，此时如果是数组，仍需要移动元素，让空出来的空间可以被复用
    - 数组不擅长元素移动，不如用链表
- 但链表查数据（O(n)）始终不如数组通过下标（O(1)）快，有没有办法让单链表查数据更快些呢？

![](https://raw.githubusercontent.com/songgeb/Algorithm/master/Resources/LRU_implementation.png)

## 栈

- 函数调用栈
- 表达式求值
	- 使用两个栈，一个存操作数，一个存运算符，实现复杂表达式的求值过程
	- 遇到操作数就进栈
	- 遇到运算符，当前运算符与栈顶运算法比较，若当前优先级高于栈顶，先让当前运算符入栈，后面要然优先级高的先计算
	- 若当前优先级低于栈顶，说明还有优先级高的没计算，那就从操作数中弹出两个操作数，从运算符栈中弹出优先级高的运算符，进行计算，结果存入操作数栈，继续遍历表达式
	- 当表达式结束后，检查一下运算符栈，若没有清空，则把剩下的计算一下，最后两个栈都空了就
	![](https://raw.githubusercontent.com/songgeb/Algorithm/master/Resources/stack_expression.jpg)

### 相关习题
- 校验给定的两个入栈、出栈序列是否正确

## 递归

可以用递归实现的问题一般符合三个原则
- 问题可以分解为子问题，并且可以一直往下分
- 不同层级子问题做的事情都是一个流程
- 存在终止条件

### 如何写
- 找到递推公式
- 找到终止条件

### 习题
- n个台阶，每次可以走1步，或两步，总共有多少种走法
	- 第一个台阶有两种走法一步或两步，所有走法可以写成f(n) = f(n-1) + f(n-2)
	- f(1) = 1，f(2) = 2

### 注意
- 要注意递归次数太多会导致函数调用栈激增，通常给程序分配的栈空间不会太大，可能导致溢出问题
- 这时候可以设置一个递归深度阈值，超过阈值就停止
- 递归可能会导致重复计算问题，可以用缓存思想提高性能
- 也可以自己在堆内存上手动实现一个函数调用栈，模拟递归操作，这样就没有函数栈溢出问题了

## 排序
经典的排序算法有

|名称|时间复杂度(最好、最坏、平均)|原地排序|稳定排序|
|:-:|:-:|:-:|:-:|
|冒泡排序|O(n)、O(n<sup>2</sup>)、O(n<sup>2</sup>)|是|是|
|插入排序|O(n)、O(n<sup>2</sup>)、O(n<sup>2</sup>)|是|是|
|选择排序|O(n<sup>2</sup>)、O(n<sup>2</sup>)、O(n<sup>2</sup>)|是|否|
|归并排序|O(nlogn)|否|是|
|快速排序|O(nlogn)、O(n<sup>2</sup>)、O(nlogn)|是|否|
|桶排序|O(n)|否|是|
|计数排序|O(n)|否|是|
|基数排序|O(n)|否|是|

### 基于比较的排序
冒泡、插入和选择排序

- 对于平均时间复杂度的分析可以从有序度角度
- 排序算法的稳定性是一个重要的指标
- 实际应用中，插入排序常用一些
	- 虽然时间复杂度和冒泡相等，但冒泡是有交换逻辑，该逻辑占用三行代码，而插入排序中移动元素实际就是赋值，只有一行代码，性能要更好

### 分治的排序
快排和归并排序

- 归并和快排都能做到平均O(nlogn)的时间复杂度
- 而且归并由于无论好与坏，都要进行归并，所以时间复杂度是稳定的O(nlogn)
- 但快排在最坏的情况下，分区不均匀时，时间复杂度会退化为O(n<sup>2</sup>)
- 但实际应用中，快排应用更多，因为归并排序为了合并需要额外的O(n)的空间复杂度

#### 归并排序示意图
![](https://raw.githubusercontent.com/songgeb/Algorithm/master/Resources/mergesort.jpg?raw=true)

#### 快排示意图
![](https://raw.githubusercontent.com/songgeb/Algorithm/master/Resources/quicksort.jpg?raw=true)

#### 习题
- O(n)时间内找到一个无序数组中第K大的值
	-  为什么用快排来做时间复杂度符合要求？
	- 之所以用快排，快排有个好处，每次分区后，选择的pivot的位置就不会再变了
	- 而且每次分区后，这个pivot就是第i大的数了，我们就可以据此来缩小大约一半（如果pivot选的好的话）的问题查找范围
	- 第一次n，找一次缩小到n/2、n/4，这样加起来总和是n的多项式，所以时间复杂度符合

### 疑问
1. leetcode上查找数据流中第K大元素一提，add方法添加value时，使用插入排序思路，为这一个value排序，时间复杂度只有O(n)，为啥还超时呢？

### 非基于比较的排序算法

桶排序（BucketSort）、计数排序（CountingSort）、基数排序（RadixSort）

- 这三种排序并不是基于比较的
- 这三种排序时间复杂度可以达到O(n)
- 所以这些算法也叫做线性排序算法
- 这三种排序对适用的场景有一些限制

#### 桶排序

![](https://raw.githubusercontent.com/songgeb/Algorithm/master/Resources/BucketSort.jpg)

核心思想是

- 了解一下待排的数据按照要排序的指标范围，划分成一个个范围区间，即一个个桶便表示不同范围
- 遍历一遍数据，将这些数据分到不同的桶里
- 每个桶里的数据进行各自的排序，比如用快排或归并
- 所有桶排好后，将每个桶的数据合并到一起

时间复杂度

- 假设m个桶，每个桶分到k=n/m个数
- 每个桶用快排（或归并），那每个桶时间复杂度应该是O(klogk)
- 最后合并数据的时间复杂度是O(n)，所以总时间复杂度应该是O(n + m * klogk)=O(n + nlogk)
- 如果n和m比较接近的话，可以近似时间复杂度为O(n)

所以

- 所以桶排序要达到O(n)的复杂度，还是有不少限制
- 桶排序的思想更多的用于外部排序中
- 比如有10G的订单数据需要排序，但内存只有几百兆，无法一次性读取到内存排序，所以可以分到多个桶里（文件），各自排完序再合并

#### 计数排序

是桶排序的一种特殊情况，桶排序中每个桶表示一个范围，计数排序中每个桶表示一个确定的值

比如给100万考生的成绩进行排名，这里面成绩只能是从0-100，由于范围比较小，我们可以每个分数给分配一个桶

再比如一组数：2，5，3，0，2，3，0，3，最大的只有5，也可以用放到6个桶里

![](https://raw.githubusercontent.com/songgeb/Algorithm/master/Resources/CountingSort.jpg)

核心思想

- 根据小的范围找出划分几个桶
- 每个桶代表一个值，有个数组C来记录每个桶里出现的相同值的次数，C的下标表示要排序的数据的值
	- 本例中C数组为：[2, 0, 2, 3, 0, 1]
- 如果不考虑稳定性的话，因为本来数组C的下标（待排序的值）就是有序的，所以直接遍历数组C，然后输出结果即可
- 但考虑到算法稳定性问题，这里做“计数”处理，即更新数组C，每一项的值更新为与前一项的加和
	- 即 [2, 2, 4, 7, 7, 8]
	- 以第一个7举例，7表示待排数组中小于等于3(7的下标)的数有7个
- 然后对待排数组，从后向前，根据新的C数组，将每个待排值放到结果数组相应的位置
	- 放完后记得C数组中相应位置的值减一，表示少了一个值了
- 该方法能够保持稳定性

时间复杂度妥妥的O(n)

所以

- 对于技术排序，桶的个数一定不能太多，所以对待排内容提出了要求
- 计数排序因为需要用到数组下标，所以对于正整数的排序比较友好
- 因为要划分到具体的桶中，对于不能枚举出桶个数的待排内容就不能用了，比如对小数排序
- 但有的看似不能用计数排序的方法可以通过转换成正整数搞定
	- 比如小数排序，但所有小数只有1位小数部分，完全可以通过乘法，将小数变为整数，通过排整数达到目的
	- 或者待排数中有负数，可以给所有数加个offset，让所有负数都成正的，也可搞定

#### 基数排序

基数排序，也是针对一些特殊的待排内容，比较适合由多“位”组成的待排内容

比如给20万手机号排序，手机号由11位构成，如果枚举出所有11位的数，尝试用计数排序搞定，不现实。

![](https://raw.githubusercontent.com/songgeb/Algorithm/master/Resources/RadixSort.jpg)

核心思想

- 计数排序核心思想就是对待排数每一位排序
- 由低到高位进行排序，每一位都排完序，就都排好了
- 注意每一位排序的时候也要用线性排序算法

整体时间复杂度

- 假设有k位的话，时间复杂度就是O(k*n)，k不大时就认为是O(n)了

所以

- 要求对每一位排序时得是稳定排序算法
- 为了好的时间复杂度，位数不能太多


## 二分查找
 
 - 二分查找算法O(logn)的算法时间复杂度，正好和O(n<sup>2</sup>)形成鲜明对比，一个爆炸式增长，一个爆炸式减小，可谓是优秀的时间复杂度
 - 但使用起来要求也很严苛，首先在有序的数组中查询时才有效，如果是无序的则无意义
 - 其次，这种查找算法依赖底层数组的结构，如果换做链表就没这么快了，因为查找时使用下标直接定位时间复杂度是需要O(n)
 - 复杂一点的二分查找也要会
 	- 查找第一个值等于给定值的元素
 	- 查找最后一个值等于给定值的元素
 	- 查找第一个值大于等于给定值的元素
 	- 哈找最后一个值小于等于给定值的元素

### 习题
- leetcode 33
- 从20W条ip范围中，给定ip，快速查找范围
- ip to int, int to ip
	- ip地址可以用32位整数来表示，每个ip段最大值是255，8位就够了
 
## 跳表（Skiplist）
 
> 从跳表这个知识点开始，我们将接触**动态数据结构**。之前的数据结构都是对静态的数组、链表等结构进行查询等操作，在这过程中并没有动态的插入删除等操作。有些时间复杂度很低的算法在面临动态操作时，时间复杂度就会降低，比如二分查找。后续接触到的数据结构中，就会有即使考虑动态的操作，性能仍很优越的算法和数据结构
 
- 实现了基于链表的二分查找
- 为**有序**的链表添加了多级索引链表
- 通过查找索引链表再找到原始链表中的数据，相比直接在原始链表中查询要更高效

![](https://raw.githubusercontent.com/songgeb/Algorithm/master/Resources/Skiplist.jpg?raw=true)

### 时间复杂度分析

- 如果对原链表每两个节点建立一个索引，那第1级索引链表中有n/2个节点，第2级是n/4个节点
- 假设建立h级索引，会有n/2<sup>h</sup>个节点
- 假设h已经是最高级索引，节点有2个
- 那可以计算出h = log<sub>2</sub>n - 1，那包含原始链表在内，整个跳表的高度是log<sub>2</sub>n
- 假设在查找时，每级索引访问的节点为m个，则总时间复杂度是O(m*logn)
- 根据下图可知一个特性，每一级访问节点数不超过3个，所以最终时间复杂度就是O(logn)

![](https://github.com/songgeb/Algorithm/blob/master/Resources/skiplist-index-3.jpg?raw=true)

> 当然，上面的时间复杂度分析是以每两个节点建立一个索引为基础计算的。假设选取其他个数节点创建索引也是类似，比如每3个节点的话，跳表高度就是log<sub>3</sub>n，查找时每一级访问节点数不超过4个。最终的时间复杂度仍是O(logn)

#### 所以

- 跳表查数据时间复杂度可以到O(logn)，空间复杂度是O(n)，即索引链表占用的空间
- 跳表除了缩短了查询的时间复杂度，还由于链表特性能够高效的动态插入、删除
	- 由于可以通过索引一级一级定位到待插入或删除位置，所以时间复杂度仍是O(logn)
	- 插入元素是可根据一定策略更新索引状态，使得跳表不会因为频繁的插入删除导致性能降低太多
- redis的复杂存储结构中使用到了跳表

![](https://raw.githubusercontent.com/songgeb/Algorithm/master/Resources/skiplist-insert.jpg)
 
## 散列表
 
- 利用数组通过下标查找数据的O(1)特征
- 散列表的两个关键点：散列函数 和 散列冲突解决
 
### 散列函数Hash
- key1 == key2, hash(key1) == hash(key2)
- key1 != key2, 现实中却很难做到 hash(key1) != hash(key2)，这就是三列冲突问题：不同的key指向了同一个散列值
 
### 散列冲突两种解决办法
- 开放寻址法
    - 基本思想是，散列表的结构是数组，且数组中存了元素。发现冲突后，如果要插入元素且因为散列冲突问题，待插入位置已经有其他元素，就想办法找一个空闲的位置
    - 找空闲位置的办法就有：线性探测，就是继续往后一个位置一个位置看
    - 二次探测，不再是一个一个的看了，可能按照2的n次方的步长找
    - 双重散列法，前面散列不是出现了冲突了么，那我多准备几个散列函数，每个散列函数都试试
    - 一个概念--装载因子=数组中元素个数/数组长度
        - 装载因子越大，说明空闲位置越少，冲突可能性越大
- 链表法
         
    ![](https://raw.githubusercontent.com/songgeb/Algorithm/master/Resources/hashtable-conflict-linkedlist.jpg)
     
### 哈希算法
> 重点掌握，实际开发中如何用哈希算法解决问题


就是将任意长度的二进制串映射成固定长度的二进制串
 
4000个汉字的文章做MD5哈希用时不到1ms
 
#### 哈希分片

 
#### 区块链对哈希算法的应用
 
区块链是一块块区块组成的，每个区块分为两部分：区块头和区块体。
 
区块头保存着 自己区块体 和 上一个区块头 的哈希值。
 
因为这种链式关系和哈希值的唯一性，只要区块链上任意一个区块被修改过，后面所有区块保存的哈希值就不对了。
 
区块链使用的是 SHA256 哈希算法，计算哈希值非常耗时，如果要篡改一个区块，就必须重新计算该区块后面所有的区块的哈希值，短时间内几乎不可能做到。
 
### 散列表和链表一起使用
 
- 散列表可以让查询时间复杂度达到O(1)
- 而链表又能使得删除、添加操作时间复杂度降到O(1)
- 二者结合能够让查询+添加+删除整体的时间复杂度降到O(1)
 
![](/Users/songgeb/Desktop/linkedhashtable.jpg)
 
1. 除了散列表和双向链表，还有一个hnext指针，用于将解决散列冲突用的链表连接起来
2. 使用双向链表因为有前项引用，可以更容易删除元素
 
 ### 应用
 - Word文档中如何检查单词拼写错误？
 - 10W个访问日志URL，如何按照访问次数快速进行排序
 - 两个字符串数组，每个数组有10W个字符串，如何找出两个数组中相同的字符串
 
## 树
 
节点的高度、深度、层数
 
![](https://raw.githubusercontent.com/songgeb/Algorithm/master/Resources/tree-depth.jpg?raw=true)
 
- 高度：结合生活中的高度，从下往上数，最下面是0
- 深度：结合生活中水深，从水平面往下，最上面是0
- 层数：从上往下，最上面层数是1
 
- 完全二叉树 vs 满二叉树
 
 
### 二叉树

#### 遍历二叉树时间复杂度

![](https://raw.githubusercontent.com/songgeb/Algorithm/master/Resources/binarytree-walkthrough.jpg?raw=true) 

每个节点遍历两边，所以时间复杂度是O(n)

二叉树的数组存储形式
 
![](https://raw.githubusercontent.com/songgeb/Algorithm/master/Resources/tree-array.jpg?raw=true)
 
- 根节点存储下标为1
- 2 * i 是左节点的下标，2 * i + 1是右节点位置
- 对于完全二叉树，相比链式存储，数组存储比较节省空间，只需要存储数据，不用存指针
- 非完全二叉树，会有些浪费

#### 习题
- 树的前序、中序、后序遍历
- 编程实现求解树的高度
 
#### 二叉搜索树
 
又名二叉查找树
 
- 因为二叉查找树每个节点的左子树所有节点都比根节点小，右子树总比根节点大；因为这样方便查询数据，所以叫做二叉搜索、查找树
- 当中序打印二叉搜索树时，输出的节点就是排好序的，所以也叫二叉排序树
 
**查询、删除、插入时间复杂度**
 
时间复杂度范围：O(1)-O(height)
 
当极端情况下，当二叉搜索树极度不平衡时，比如退化成链表时时间复杂度就是O(n)了
 
如果是完全二叉树的话：时间复杂度最差不会超过O(logn)
 
所以二叉树越平衡，查找等操作的时间复杂度就越低
 
#### 平衡二叉树
 
平衡二叉树首先是二叉搜索树
 
#### 红黑树
 
红黑树虽不是严格意义上的平衡二叉树，这是综合考虑的结果，所以红黑树的查找性能很好
 
红黑树的定义规定了一些条件和左右旋转、替换节点等操作
 
这些条件或各种旋转的核心目的是**尽可能让这棵树保持平衡**，以方便查找搜索
 
- 红黑树通过定义的严格的条件和复杂的变色、左右旋操作为的是实现自平衡的平衡二叉搜索树
- 只有这样才能让动态的插入、删除、查找等操作在接近O(logn)的高性能时间复杂度内完成
- 红黑树在工业级应用比较广泛，因为相比于其他的平衡二叉搜索树，它更加稳定
	- 其他平衡树比如严格的平衡二叉树AVL，虽然可以保证时间复杂度，但也因此使得调整树达到平衡时操作过于复杂
- 理解红黑树的前提是理解[2-3树](https://www.cnblogs.com/tiancai/p/9072813.html) 
- [漫画：什么是红黑树？](https://mp.weixin.qq.com/s/jz1ajDUygZ7sXLQFHyfjWA)
 
### 动态数据结构的比较

- 散列表：插入删除查找都是O(1), 是最常用的，但其缺点是不能顺序遍历以及扩容缩容的性能损耗。适用于那些不需要顺序遍历，数据更新不那么频繁的。

- 跳表：插入删除查找都是O(logn), 并且能顺序遍历。缺点是空间复杂度O(n)。适用于不那么在意内存空间的，其顺序遍历和区间查找非常方便。

- 红黑树：插入删除查找都是O(logn), 中序遍历即是顺序遍历，稳定。缺点是难以实现，去查找不方便。其实跳表更佳，但红黑树已经用于很多地方了。
 
### 递归树

会用递归树来分析递归算法的时间复杂度

目前有两种计算递归算法时间复杂度的方法
- 根据递推公式推导
- 画出递归树，每层分析进行计算

#### 习题
- 1 个细胞的生命周期是 3 小时，1 小时分裂一次。求 n 小时后，容器内有多少细胞？请你用已经学过的递归时间复杂度的分析方法，分析一下这个递归问题的时间复杂度。
 
## 堆
 
- 此处的堆是一种数据结构，与内存的堆无关
- 其实是一个完全二叉树
- 这个二叉树符合
    - 每个节点的值都要大于等于它左右子节点的值，即为大顶堆
    - 反之则为小顶堆
 
![](https://static001.geekbang.org/resource/image/e5/22/e578654f930002a140ebcf72b11eb722.jpg)
 
> 前面有提到，对于完全二叉树，为了节省空间，可以使用数组作为存储结构
 
堆有两个重要操作
 
- 插入元素
- 删除堆顶元素
 
#### 堆化
 
当插入或更改堆中的节点，导致不再是大（小）顶堆时，通过重复与父节点或子节点进行比较、交换，使成为新的大（小）顶堆的过程
 
堆化可以是从下到上，也可从上到下
 
堆化与更改节点的高度有关，所以堆化的时间复杂度是O(log n)
 
#### 插入元素
 
- 将新元素插入到数组最后
- 从下往上进行堆化

![](https://raw.githubusercontent.com/songgeb/Algorithm/master/Resources/heap-insert.jpg?raw=true)
 
#### 删除堆顶元素
 
如果直接删除堆顶元素，删除堆顶元素从上到下堆化时可能会出现数组空洞

![](https://raw.githubusercontent.com/songgeb/Algorithm/master/Resources/heap-delete-kongdong.jpg?raw=true) 

所以这里可以使用一个小技巧，同时从下往上进行堆化

- 将最后一个元素替换到堆顶位置
- 从新的堆顶元素开始，进行堆化
- 这就相当于删除了堆顶元素

![](https://raw.githubusercontent.com/songgeb/Algorithm/master/Resources/heap-delete.jpg?raw=true)
 
#### 堆排序
 
堆排序算法是堆结构的一个经典应用
 
算法的核心操作是 建堆 + 排序
 
建堆：根据乱序数据，构建一个大顶堆
 
建堆思路1：从前到后，从第2个元素开始，通过插入元素的操作构建
建堆思路2：从后往前，因为是完全二叉树，所以数组中[n/2 + 1, n]是叶子节点，无需，我们可以从n/2这个元素开始构建

- 建立堆的时间复杂度是O(n)
- 排序时相当于为n-1个元素做堆化处理，所以时间复杂度为O(nlogn)
- 所以总的时间复杂度是O(nlogn)
- 堆排序不需要额外的空间，所以空间复杂度是O(1)
- 因为需要交换数据，所以不是稳定排序
- 与快排相比
	- 快排更常用
	- 因为同样的数据快排的交换次数要小于堆排序
	- 因为堆排序要对原数据进行建堆，所以可能会破坏掉原有的逆序度，导致逆序度增加
	- 而快排总体上是让逆序度减小的

#### 合并有序小文件

> 堆有时也被叫做优先级队列

- 有很多（100）个小文件，每个文件存储了很多个有序的字符串，我们想将这些字符串合并成一个大的有序的文件
- 我们每次都这个100个文件中，各取一个字符串存入一个数据结构，找出最小的那个字符串，放入到大文件中，然后从数据结构中删除这个字符串，再去小文件中找一个字符串出来。重复该过程
- 此处选用小顶堆作为该数据结构就要比数组性能更高
	- 因为若用数组，每次查找最小值就得O(n)复杂度，同时还要考虑删除、数据搬移等耗时
	- 而上面描述的先插入再删除的操作，若用堆实现，就是两次堆化的过程，时间复杂度是O(logn)

#### 高性能定时器

假设我们有一个定时器，和一个任务列表，要求到一定时间执行某个任务

- 最笨的办法我们给定时器设置1个比较小的固定的时间间隔（比如1秒），轮询查找任务列表是否有可以执行的任务。显然比较低效
- 使用优先级队列则更优
	- 对任务列表建立小顶堆，堆顶元素是最近要执行的任务
	- 取堆顶任务，计算出任务执行时间距离当前时间的时间间隔T，启动定时器，设置时间间隔为T
	- 执行完任务后，删除堆顶任务，堆化，继续执行上面步骤
	- 这能更高效的利用定时器，避免无用的轮询

#### 用堆解决Top K问题
 
假设求Top K大的数据（Top K小的数据也类似）
 
我们可以用快排，对数据进行排序，然后取出Top K的数据。
 
快排时间复杂度为O(nlogn)
 
也可以用堆来实现
 
1. 新建一个大小为K的小顶堆
2. 将前K个数据插入到堆中
3. 遍历K + 1到n的每个元素
    - 当元素比堆顶元素大，则删除堆顶元素，插入该元素
    - 当元素比堆顶元素小，则不管
4. 所有元素遍历结束，则堆中元素即为Top K大的数据
5. 遍历元素时间复杂度是O(n)，最坏情况下，每个元素都进行堆化，时间复杂度是O(nlogk)，所以性能仍更好
6. 如果不是静态的数据，而是需要动态插入数据，同时询问top k大的值时，用堆就更好了
	- 可以始终维护着一个上面说的k的大顶堆
	- 每次添加数据后，就更新大顶堆
	- 这样每次时间复杂度仅是O(logk)，远比每次询问top k时再使用上面的方法计算一遍性能要好

#### 中位数问题

> 中位数，就是一组数据排好序后，中间位置的数。如果是奇数，那正中间数就是，若是偶数，那中间的两位可以任选其一

静态数据求的话，先排序再取值即可。但如果是动态数据结构，边插入边计算中位数，这样的方式就很低效

可以使用两个堆来实现

- 1个小顶堆用于存放后半部分数据，1个大顶堆存放前半部分数据。显然两个堆得堆顶元素就对应着中位数
- 当有数据插入时，若小于大顶堆的堆顶元素，就放到这个堆里，反之放到另一个堆里
- 记住，插入元素后，就不符合两个堆各一半数据的要求，此时再将数据匀一匀，本质上还是堆化
- 这样总体时间复杂度是O(n)，真正取中位数的时候只是获取一下堆顶元素，O(1)

#### 如何快速求接口的 99% 响应时间

如果有 n 个数据，将数据从小到大排列之后，99 百分位数大约就是第 n\*99% 个数据，同理，80 百分位数大约就是第 n\*80% 个数据。

弄懂了这些，我们再来看如何求 99% 响应时间。我们维护两个堆，一个大顶堆，一个小顶堆。假设当前总数据的个数是 n，大顶堆中保存 n\*99% 个数据，小顶堆中保存 n\*1% 个数据。大顶堆堆顶的数据就是我们要找的 99% 响应时间。

其余操作和求中位数就完全一样了

#### 习题

1. 10 亿个搜索关键词的日志文件，如何快速获取到 Top 10 最热门的搜索关键词

	要求单机处理，内存1GB
	
	
## 图

### 图的概念

生活中社交关系经常用图结构来表示

#### 无向图
比如微信中的好友关系，就可以表示为**无向图**

![](https://github.com/songgeb/Algorithm/blob/master/Resources/undirected-graph.jpg?raw=true)

- 图中将每个节点叫做**顶点**，可以认为微信中的好友
- 图中的边叫做**边**，可以认为是好友之间的朋友关系
- 一个顶点关联多条边，叫做**度**，可以认为是一个微信用户的好友个数

#### 有向图

微博中的好友关系更复杂些，可以用户A可以关注B，但B不一定关注A，用于表示单向关系的图可以是**有向图**

![](https://github.com/songgeb/Algorithm/blob/master/Resources/directed-graph.jpg?raw=true)

- 每个顶点有**入度**和**出度**
- 入度可以认为是顶点表示的用户被关注数
- 出度表示关注其他人的数量

#### 带权图

QQ中的好友关系有一个亲密度的概念，即若用户A和B之间交流很频繁，那对应的亲密度就很高。所以不同用户之间的亲密度可能都不同，可以用**带权图**来表示该关系

![](https://github.com/songgeb/Algorithm/blob/master/Resources/weighted-graph.jpg?raw=true)

- 每条边上的数值表示权重，即这里的亲密度

### 图的存储

#### 邻接矩阵

- 本质上是一个二维数组
	- 对无向图，i和j若有边，则A[i][j]和A[j][i]为1
	- 有向图，则i和j的先后顺序表示方向
	- 带权图，则每个元素的值表示权重
- 缺点明显，浪费空间，对于**稀疏图**尤为如此
	- 稀疏图是顶点可能很多，但边并不多，比如微信好友关系，大部分人的好友数都不会很多
- 优点是，获取数据高效，计算方便，使用简单

![](https://github.com/songgeb/Algorithm/blob/master/Resources/graph-adjacency-matrix.jpg?raw=true)

#### 邻接表

- 结构上很像使用链表处理冲突的哈希表结构
- 优点是节省空间
- 结构更复杂，操作更繁琐了
- 由于单链表查找速度慢问题，可以进行优化升级
	- 比如将链表改为更高效支持动态操作的数据结构如二叉平衡查找树、跳表等

![](https://github.com/songgeb/Algorithm/blob/master/Resources/graph-adjacencylist.jpg?raw=true)

### 搜索

> 大部分搜索问题，搜索场景都可以抽象成图

不管是深搜还是广搜，本质都是搜索算法，用于查找搜索元素的

- 深度优先搜索（Depth-First-Search）
- 广度优先搜索（Breadth-First-Search）

### 疑问
1. 深度优先搜索和回溯思想区别是？
2. 感觉dfs和bfs的时间复杂度分析很不严谨，需要看下更严谨的分析
3. 图在实践中有哪些应用

### 习题
1. 如何存储微博的好友关系，要支持如下功能
	- 判断用户 A 是否关注了用户 B；
	- 判断用户 A 是否是用户 B 的粉丝；
	- 用户 A 关注用户 B；用户 A 取消关注用户 B；
	- 根据用户名称的首字母排序，分页获取用户的粉丝列表；
	- 根据用户名称的首字母排序，分页获取用户的关注列表。

## 字符串匹配

模式串、主串

### BF（Brute Force）

暴力匹配

![](https://github.com/songgeb/Algorithm/blob/master/Resources/BruteForce.jpg?raw=true)

- 假设模式串长度是m，主串长度为n，n > m
- 最坏情况，模式串要易懂n-m+1次，每次都要比较m个元素
- 时间复杂度是O(m * n)

### RK（Rabin-Karp）

基于BF进行改进

- 核心是每次模式串和主串比较时不再挨个比较，而是转为哈希值比较
- 通过设计合适的哈希算法，计算出，主串中要与每个模式串比较的子串的哈希值（设计的好的话，相邻子串之间的哈希值是有关联的，可以通过计算互相得出，进一步提高匹配性能）
- 模式串的哈希值与每个子串的哈希值进行比较
- 若哈希值相等，再比较两个串是否真的相等，以避免哈希冲突问题
	- 所以哈希算法的设计比较重要，如果冲突概率太高，每次比较哈希值都相等，不得已再去比较两个串的话，时间复杂度就降为O(m * n)了
- 哈希值的比较相比子串挨个比较效率更高
- 时间复杂度方面
	- 遍历一遍主串计算相邻子串的哈希值，O(n)
	- 模式串和子串比较，每次O(1)，一共比较n-m+1次，O(n)
	- 总时间复杂度是O(n)

### BM（Boyer-Moore）

> 文本编辑器中的替换功能如何实现的？

- 本质上BM算法是在BF和RK的基础上，针对字符串本身的特性，力求减少字符的比较次数，规避掉无用的比较，从而达到降低时间复杂度的目的
- 当然，算法本身由于技巧性比较强，并不容易懂，但学习算法本身的目的并不是记住某个算法，而是了解算法，同时掌握不同算法的使用场景，更高阶的则要求有些普适性的算法技巧可以举一反三
- 比如本算法中，为了提高查找效率可以使用散列表；为了减少不必要的计算可以通过预处理，将常计算的值提前存储起来，使用时通过查表快速找到
- BM算法中总体上是应用两个规则来降低字符比较次数的
	- 坏字符规则
	- 好后缀规则
- 仅适用坏字符规则不妥，的情况
- 坏字符规则需要根据要比较的字符集大小开辟一个相应大小的额外空间，所以对于字符集太大的情况，内存不够用时可以只运用好后缀规则，只不过可能时间复杂度就会增大一些了
- 好后缀当然也需要额外空间
- 文本编辑器的替换功能就会使用该方法

### KMP（Knuth Morris Pratt）

本质和BM类似，也是跳过不必要的字符比较

- [字符串匹配的KMP算法](http://www.ruanyifeng.com/blog/2013/05/Knuth%E2%80%93Morris%E2%80%93Pratt_algorithm.html)
- [怎么理解kmp算法中的next数组?](https://www.zhihu.com/question/21474082)

### Trie 树

> 也叫字典树

- Trie 树的本质，就是利用字符串之间的公共前缀，将重复的前缀合并在一起

比如下面是一个Trie树，代表着`how`，`hi`，`her`，`hello`，`so`，`see`这组字符串列表

![](https://github.com/songgeb/Algorithm/blob/master/Resources/TrieTree.jpg?raw=true)

- 如果要查找一个字符串a是否在上面列表中出现，最暴力的办法，挨个匹配
- 若用Trie树，则最多需要比较K次即可得出结果，K为a的长度

#### 存储
- 可以看出Trie树是一个多叉树，为了能够实现多叉树的结构，每一个节点除了存储数据本身以外，还要能够存储每个分支信息
- 所以每个节点中包含了一个哈希表，每个key表示一个分支
	- Trie树之所以叫做字典树也是因为这个
- 比如如图所示，将a-z26个字母作为key

![](https://github.com/songgeb/Algorithm/blob/master/Resources/TrieTree-Storage.jpg?raw=true)

#### 时间、空间复杂度

- 创建一个Trie树需要遍历一遍所有字符O(n)
- 创建好树后，每次查询时间复杂度O(K)，K表示待查询字符串长度
- 查询速度是比较高效的
- 但比较浪费内存，而且由于字符集的不同，需要额外哈希表的空间也不同

#### 总结

- Trie树其实是用空间换时间的思想，以提高搜索效率
- Trie树还有一个普世思想
	- 想在多个字符串中查找一个字符串，我们可以提前做一些预处理，比如这里的构建成Trie树，构建好后在查询就快了
	- 突出预处理思想的重要性
- 对于字符串的精确匹配Trie树应用的并不多，因为有更节约内存的红黑树等动态数据结构
- Trie树的优势是适用查找前缀匹配的字符串，比如搜索引擎中的关键词提示功能

### AC自动机

- 单模式串匹配算法：在主串中查找一个模式串
- 多模式串匹配算法：在主串中查找多个模式串
- 多模式串匹配，可以使用Trie树，将多个模式串预处理成Tire树
	- 然后从主串第一个字符开始，到树种检索，第一个检索结束后再从第二个开始检索
- AC自动机是基于Trie树的改进，相当于单模式串匹配中加入了KMP算法的特性

## 贪心（greedy algorithm）

> 掌握贪心算法的关键是**多练习**

### 习题
1. 在一个非负整数 a 中，我们希望从中移除 k 个数字，让剩下的数字值最小，如何选择移除哪 k 个数字呢？
	1. 先算出移除k个数字，还剩下几位
	2. 然后根据从高位到低位，取a中选数字即可
	3. 每次在可选范围内选最小的
2. 假设有 n 个人等待被服务，但是服务窗口只有一个，每个人需要被服务的时间长度是不同的，如何安排被服务的先后顺序，才能让这 n 个人总的等待时间最短？
	- 简单的举例画一下即可得出
	- 应该优先安排服务时间最短的
	- 因为当1个人被服务时，其他人都要等待这个人的服务时长
	- 如果1个人需要的服务时间很长，且他先被服务的话，那有更多人需要等待这个较长的服务时间。所以应该优先选择服务时间短的

## 分治
分治算法符合如下特征
- 大问题分解为小问题
- 小问题和大问题可以用相同的方法来解决

### 习题
- 二维平面上有 n 个点，如何快速计算出两个距离最近的点对？

## 回溯（BackTracking）
- 有点类似枚举出所有结果集
- 在岔路口进行选择，如果后续发现不满足要求再退回到岔路口重新选择
- 一般都会讲问题分解成n个阶段，每个阶段来做选择
- 时间复杂度比较高，指数级别

### 习题
- 数独、八皇后、01背包

## 动态规划（DynamicProgramming）

Richard Bellman与19世纪50年代发明了动态规划算法

- 动态规划是在回溯算法之上，加入**去重**逻辑后产生的
- 回溯算法中可能会计算重复的子问题，动态规划则通过一些技巧规避掉重复问题的计算，以提高效率

- 状态转移表法
- 状态转移方程法

### 字符串相似度

- 编辑距离：将一个字符串转化成另一个字符串，需要的最少编辑操作次数
- 根据编辑操作的不同可以分成
	- 莱文斯坦距离（Levenshtein distance）
		- 允许增加、删除、替换
	- 最长公共子串长度（Longest common substring length）
		- 只允许增加、删除
- 两个距离的值在表达字符串相似度上正好相反
	- 莱文斯坦距离越大说明相似度越低
	- 最长公共子串越大说明相似度越高

## 疏漏
1. 平衡二叉查找树部分，印象比较浅，基本没有实践过
2. KMP算法中NEXT数组的构建过程还是懵逼
3. 全排列的非递归实现
4. 递归时间复杂度的分析
	- 包括快排