//
//  Algorithm.swift
//  AwesomeDemoCodeSwift
//
//  Created by Johnson on 2020/8/31.
//  Copyright © 2020 Johnson. All rights reserved.
//

/**
 下面几个经典的算法来自这里: https://mp.weixin.qq.com/s/vn3KiV-ez79FmbZ36SX9lg
 */

import Foundation
import CoreGraphics

//全排列算法 (回溯算法)
func permuted(nums: [Int]) -> Array<Array<Int>> {
    
    var perform_func_count = 0
    var cycle_str = ""
    var res: Array<Array<Int>> = Array()
    func backtrack(nums:[Int], track:[Int]) {
        print("当前track值:\(track), 第\(perform_func_count)次递归调用")
        perform_func_count += 1
        var track = track
        if nums.count == track.count {
            res.append(track)
            return
        }
        cycle_str += ">"
        for i in 0...nums.count - 1 {
            let value = nums[i]
            print("\(cycle_str) index:\(i) value值:\(value)")
            if track.contains(value) {
                continue
            }
            
            track.append(value)
            backtrack(nums: nums, track:track)
            track.removeLast()
        }
        cycle_str.removeLast()
    }
    
    backtrack(nums: nums, track: [])

    return res
}

//N皇后问题, 未写完, 使用C++语法写完了 参考AlgorithmCPP.cpp
func solveNQueues(n: Int) -> Void {
    
    var res: Array<Array<String>> = Array()
    var chars:[String] = Array()
    for _ in 0...n {
        for _ in 0...n {
            chars.append("X")
        }
        res.append(chars)
        chars.removeAll()
    }
    
    res[0][0] = "2";
    var aaa:String = "xxxxxx"
//    String.Index
//    Range
//    aaa.replaceSubrange(Range.init(NSMakeRange(1, 1)), with: [])
//    aaa.replaceSubrange(NSMakeRange(1, 1), with: "A")
    
}



//选择排序 每次循环从后面的数值中找出最小值, 如果找到, 就和当前i值进行替换
func select_sort(arr: [Int]) -> [Int] {
    if arr.count <= 1 {
        return arr
    }
    
    var arr = arr
    for i in 0...arr.count - 2 {
        var min = i;
        // 每轮需要比较的次数 N-i
        for j in (i+1)...arr.count - 1 {
            if (arr[j] < arr[min]) {
                // 记录目前能找到的最小值元素的下标
                min = j;
            }
        }
        // 将找到的最小值和i位置所在的值进行交换
        if (i != min) {
            let tmp = arr[i];
            arr[i] = arr[min];
            arr[min] = tmp;
        }
    }
    return arr;
}

//插入排序
func insert_sort(arr:[Int]) -> [Int] {
    if arr.count <= 1 {
        return arr
    }
    
    // 对 arr 进行拷贝，不改变参数内容
    var arr = arr
    
    // 从下标为1的元素开始选择合适的位置插入，因为下标为0的只有一个元素，默认是有序的
    for i in 1...arr.count - 1 {
        
        // 记录要插入的数据
        let tmp = arr[i];
        
        // 从已经排序的序列最右边的开始比较，找到比其小的数, 循环判断, 如果比之前一位数小, 则用前一位的数覆盖到现在这个位置
        var j = i;
        while (j > 0 && tmp < arr[j - 1]) {
            arr[j] = arr[j - 1];
            j -= 1;
        }
        
        // 存在比其小的数，插入  通过上面的查找, 找到比签名位置的数小的数, 那么就在j位插入当前这个数.
        if (j != i) {
            arr[j] = tmp;
        }
        
    }
    return arr;
}

//shell排序 希尔排序    根据增量因子gap(长度)拆分数据. 每组数据长度为gap.  当gap为1的时候, 就和上面的插入排序一样
func shell_sort(arr: [Int]) -> [Int] {
    // 对 arr 进行拷贝，不改变参数内容
    var arr = arr
    
    var gap = 1
    let ratio = 2
    while (gap < arr.count) {
        gap = gap * ratio + 1;
    }
    
    while (gap > 0) {
        if gap < arr.count {
            for i in gap...arr.count - 1 {//(int i = gap; i < arr.length; i++) {
                let tmp = arr[i];
                var j = i - gap;
                while (j >= 0 && arr[j] > tmp) {
                    arr[j + gap] = arr[j];
                    j -= gap;
                }
                arr[j + gap] = tmp; // == (arr[i] = tmp)
            }
        }
        gap = Int(floor(Float(gap/ratio)))//(int) Math.floor(gap / 3);
    }
    
    return arr;
}

//归并排序 有点像希尔排序, 拆分成一小段, 小段小段小段的排序好, 然后合并排序好
//比如 1:1 2:1 1:2的小段拆分排序
func merge_sort(arr:[Int]) -> [Int] {
    
    func merge(left: [Int], right: [Int]) -> [Int] {
        var left = left, right = right
//        left = [11, 22, 0, 1, 34]  //这种未排序好的数据无法通过以下方式进行排序
//        right = [3, 2, 5, 32, 5]
        var result:[Int] = Array()
        while (left.count > 0 && right.count > 0) { //当数据存在时依次 1对1比对, t提取出需要的数值, 并把数据从原来的数组移除
            if (left[0] <= right[0]) {
                result.append(left[0])
                left.removeFirst()
            } else {
                result.append(right[0])
                right.removeFirst()
            }
        }
        
        while (left.count > 0) {
            result.append(left[0])
            left.removeFirst()
        }
        
        while (right.count > 0) {
            result.append(right[0])
            right.removeFirst()
        }
        
        return result;
    }
    
    func sort(arr: [Int]) -> [Int] {
        if (arr.count < 2) { //只有一个的时候, 不需要拆分
            return arr;
        }
        let middle = Int(floor(Float(arr.count / 2)));
        
        let left:[Int] = (arr as NSArray).subarray(with: NSMakeRange(0, middle)) as! [Int] //Arrays.copyOfRange(arr, 0, middle);
        let right:[Int] = (arr as NSArray).subarray(with: NSMakeRange(middle, arr.count - middle)) as! [Int]//Arrays.copyOfRange(arr, middle, arr.length);
        
        return merge(left: sort(arr: left), right: sort(arr: right));
    }
    
    let arr = sort(arr: arr)
    return arr
}

//快排
/**
 找一个基准值(一般选第一个), 把小于基准值的放左边, 大于基准值的放右边, 最后把基准值放中间
 然后把小和大的分为两组, 继续按照前面的规则进行操作
 */
func quick_sort(arr: [Int]) -> [Int] {
    
    func swap(arr: inout [Int], i: Int, j: Int) {
        let temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
    }

    func partition(arr: inout [Int], left: Int, right: Int) -> Int {
        // 设定基准值（pivot）
        let pivot = left;
        let pivotValue = arr[pivot]
        var index = pivot + 1;
        for i in index...right {
            let currentValue = arr[i]
            if (currentValue < pivotValue) {
                swap(arr: &arr, i: i, j: index);
                index += 1;
            }
        }
        swap(arr: &arr, i: pivot, j: index - 1);
        return index - 1;
    }
    func quickSort(arr: inout [Int], left: Int, right: Int) -> [Int] {
        if (left < right) {
            let partitionIndex = partition(arr: &arr, left: left, right: right);
            let _ = quickSort(arr: &arr, left: left, right: partitionIndex - 1);
            let _ = quickSort(arr: &arr, left: partitionIndex + 1, right: right);
        }
        return arr;
    }

    func sort(arr: [Int]) -> [Int] {
        var arr = arr
        return quickSort(arr: &arr, left: 0, right: arr.count - 1);
    }

    let arr = sort(arr: arr)
    return arr
}

//快排2  https://wiki.jikexueyuan.com/project/easy-learn-algorithm/fast-sort.html
func quick_sort2(arr: [Int]) -> [Int] {
    
    func quickSort(arr: inout [Int], left: Int, right: Int) {
        if (left < right) {
            let pivot = arr[left];  //pivot基准数
            var i = left;
            var j = right;
            while (i < j) {

                while (arr[j] >= pivot && i < j) { //从右往左找, 小于基准数的, 跳出循环 (得到小于基准数的数的下标)
                    j -= 1;
                }
                while (arr[i] <= pivot && i < j) { //从左往右找, 大于基准数的, 跳出循环 (得到大于基准数的数的下标)
                    i += 1;
                }
                
                if (i < j) { //交换两个数的位置
                    let t = arr[i];
                    arr[i] = arr[j];
                    arr[j] = t;
                }
            }
            //最终将基准数归位
            arr[left] = arr[i];
            arr[i] = pivot;

            quickSort(arr: &arr, left: left, right: i - 1); //继续处理左边的  递归
            quickSort(arr: &arr, left: i + 1, right: right); //继续处理右边的  递归
        }
    }

    var arr = arr
    quickSort(arr: &arr, left: 0, right: arr.count - 1)
    return arr
}

//堆排序
/**
 堆结构描述: https://www.jianshu.com/p/6b526aa481b1
 堆排序详解: https://www.cnblogs.com/chengxiao/p/6129630.html
 */
func heap_sort(arr:[Int]) -> [Int]
{

    func swap(arr: inout [Int], i: Int, j: Int) {
        let temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp
    }
    
    //堆化  shift_down
    func heapify(arr: inout [Int], i: Int, len: Int) {
        //记住以下三个公式即可
        let parent = Int( floor((1 - 1) / 2) ) //i的父节点
        let left = 2 * i + 1 //i的左子节点
        let right = 2 * i + 2 //i的右子节点
        var largest = i  //大于当前节点的节点(大顶堆), 反向就是小顶堆
        

        if left < len && arr[left] > arr[largest] {
            largest = left
        }

        if right < len && arr[right] > arr[largest] {
            largest = right
        }

        if largest != i { //计算出的两子节点有一个大于当前节点的话, 把当前节点和子节点互换, 并再次进行堆化. 用新的节点去计算它的子节点
            swap(arr: &arr, i: i, j: largest)
            heapify(arr: &arr, i: largest, len: len)
        }
    }

    func buildMaxHeap(arr: inout [Int], len: Int) {
        for i in -Int(floor(Float(len / 2)))...0 {
            let i = abs(i)
            heapify(arr: &arr, i: i, len: len)
        }
    }

    var arr = arr
    var len = arr.count
    buildMaxHeap(arr: &arr, len: len) //建立最大堆

    for i in -(len - 1)...(-1) {  //
        let i = abs(i)
        //因为是大顶堆, 所以第一个是最大的, 把第一个和最后一个进行交换, 然后把剩下的部分重新生成大顶堆, 再从这个堆里面取第一个数和倒数第二个进行交换, 后续重复上面的操作即可
        swap(arr: &arr, i: 0, j: i)
        len -= 1 //此处一定要递减, 否则每次都是用完整的数据生成大顶堆
        heapify(arr: &arr, i: 0, len: len) //使用前面部分数据继续生成大顶堆
    }

    return arr
}


//计数排序  如果最大值过于大, 此算法就不合适, 常规情况下只支持数组中无负数的情况
/**
 根据最大值生成一个新的数组, 然后根据 arr 值对应的下标做个数标记, 最后按下标生成的数据, 就是数组的排序.
 为什么内部不能有负数: 因为它是利用数组的结构来排序. 数组的下标没有负数
 (仅针对正数)
 */
func count_sort(arr:[Int]) -> [Int] {
    
    func getMaxValue(arr: [Int]) -> Int {
        var maxValue = arr[0];
        for value in arr {
            if (maxValue < value) {
                maxValue = value;
            }
        }
        return maxValue;
    }
    
    func countingSort1(arr: inout [Int], maxValue: Int) -> [Int] {
        let bucketLen = maxValue + 1; //+1的原因是: 下标的最大为最大值, 所以总个数要+1
        var bucket: [Int] = Array.init(repeating: 0, count: bucketLen)

        for i in arr {
            bucket[i] += 1  //记录i值在数组中有几个
        }

        var sortedIndex = 0;
        for j in 0...bucketLen - 1 {
            while (bucket[j] > 0) {
                arr[sortedIndex] = j; //如发现大于0, 则提取出j值, 并依次放回数组中
                sortedIndex += 1
                bucket[j] -= 1;
            }
        }
        return arr;
    }
    
    var arr = arr
    return countingSort1(arr: &arr, maxValue: getMaxValue(arr: arr))
}

//计数排序2(仅针对正数)  没有上面的函数好理解, 但这是标准做法
func count_sort2(arr:[Int]) -> [Int] {
    var arr = arr
    var maxValue = arr[0], minValue = arr[0]
    for value in arr {
        if (maxValue < value) {
            maxValue = value;
        }
        
        if (minValue > value) {
            minValue = value
        }
    }
    
    let bucketLen = maxValue - minValue + 1;
    var bucket: [Int] = Array.init(repeating: 0, count: bucketLen)
    
    for i in arr {
        bucket[i - minValue] += 1 //记录i值在bucket中的个数  后续补回来时, 需手动+minValue
    }
    
    var sortedIndex = 0;
    for j in 0...bucketLen - 1 {
        while (bucket[j] > 0) {
            arr[sortedIndex] = j + minValue;
            sortedIndex += 1
            bucket[j] -= 1
        }
    }
    return arr;
}
//计数排序3  针对负数也做排序
func count_sort3(arr:[Int]) -> [Int] {
    var arr = arr
    var maxValue = arr[0], minValue = arr[0]
    for value in arr {
        if (maxValue < value) {
            maxValue = value;
        }
        
        if (minValue > value) {
            minValue = value
        }
    }
    
    var bucketPositive: [Int] = Array.init(repeating: 0, count: maxValue + 1)  //正数
    var bucketNegative: [Int] = Array.init(repeating: 0, count: abs(minValue) + 1) //负数
    
    for i in arr {
        if i > 0 {
            bucketPositive[i] += 1
        }else {
            bucketNegative[abs(i)] += 1
        }
    }
    
    //先排序负的部分, 再排序正的部分. 负的部分注意下标取反, 反向排序
    var sortedIndex = 0;
    for j in -(bucketNegative.count - 1)...0 {
        let index = abs(j)
        while bucketNegative[index] > 0 {
            arr[sortedIndex] = -index
            sortedIndex += 1
            bucketNegative[index] -= 1
        }
    }
    
    for j in 0...bucketPositive.count - 1 {
        while (bucketPositive[j] > 0) {
            arr[sortedIndex] = j;
            sortedIndex += 1
            bucketPositive[j] -= 1
        }
    }
   
    return arr;
}


//桶排序
/**
 属于用空间换速度的算法.
 要么指定桶的大小(存放数据的个数), 要么指定桶的个数
 指定桶的大小, 来算出桶个数
 */
func bucket_sort(arr: [Int]) -> [Int] {
    
    func bucketSort(arr: [Int], bucketSize: Int) -> [Int] {
        var arr = arr
        if (arr.count == 0) {
            return arr;
        }
        
        var minValue = arr[0];
        var maxValue = arr[0];
        for value in arr {
            if (value < minValue) {
                minValue = value;
            } else if (value > maxValue) {
                maxValue = value;
            }
        }
        //根据桶的大小, 得到桶的个数
        let bucketCount = Int(floor(Float((maxValue - minValue) / bucketSize))) + 1;
        var buckets = Array<Array>.init(repeating: Array<Int>(), count: bucketCount)
        
        // 利用映射函数将数据分配到各个桶中
        for i in 0...arr.count - 1 {
            let index = Int(floor(Float((arr[i] - minValue) / bucketSize)))
            
            var bucket = buckets[index]
            bucket.append(arr[i])
            
            buckets[index] = bucket
        }
        
        var arrIndex = 0;
        for bucket in buckets {
            if (bucket.count <= 0) {
                continue;
            }
            // 对每个桶进行排序，这里使用了插入排序
            let sort_bucket = insert_sort(arr: bucket)
            for value in sort_bucket {
                arr[arrIndex] = value;
                arrIndex += 1
            }
        }
        
        return arr;
    }
    return bucketSort(arr: arr, bucketSize: 5)
}

//桶排序2 //指定桶的个数来算出桶范围  最容易理解的方式
//参考 https://blog.csdn.net/liaoshengshi/article/details/47320023
//参考 https://dailc.github.io/2016/12/03/baseKnowlenge_algorithm_sort_bucketSort.html
func bucket_sort2(arr: [Int]) -> [Int] {

    func bucketSort(arr: [Int], bucketCount: Int) -> [Int] {
        let len = arr.count;
        var min = arr[0];
        var max = arr[0];
        //找到最大值和最小值
        for i in 1...len - 1 {//}(int i = 1; i < len; i++) {
            min = min <= arr[i] ? min : arr[i];
            max = max >= arr[i] ? max : arr[i];
        }
        //求出每一个桶的数值范围, 此处要注意精度, 否则无法准确的获取下面的 index
        let space = Float((max - min + 1)) / Float(bucketCount)
        //先创建好需要的桶
        var buckets: Array<Array<Int>> = Array.init(repeating: [], count: bucketCount)
        //把arr中的数均匀的的分布到[0,1)上，每个桶是一个list，存放落在此桶上的元素
        for i in 0...len - 1 {
            let index = Int(floor(Float(Float(arr[i] - min) / space)));
            
            var bucket = buckets[index]
            bucket.append(arr[i])
            buckets[index] = bucket
        }
        
        //把各个桶的排序结果合并
        var result: [Int] = Array()
        for i in 0...bucketCount - 1 {
            if (buckets[i].count > 0) {
                let sort_bucket = insert_sort(arr: buckets[i])
                result.append(contentsOf: sort_bucket)
            }
        }
        return result
    }

    return bucketSort(arr: arr, bucketCount: 5)
}



//基数排序  从数值的最后一位网前一个个提取排序 默认不支持负数.  以下针对负数的整理, 生成区间来存负数
func radix_sort(arr: [Int]) -> [Int] {

    //获取最高位数
    func getMaxDigit(arr: [Int]) -> Int {
        var maxValue = arr[0];
        for value in arr {
            maxValue = max(maxValue, value)
        }

        var length = 0
        while maxValue != 0 {
            maxValue /= 10
            length += 1
        }

        return length
    }

    func radixSort(arr: [Int], maxDigit: Int) -> [Int] {
        var arr = arr
        var mod = 10;
        var dev = 1;

        for _ in 0..<maxDigit {  //个 十 百 千 循环下去获取基数
            // 考虑负数的情况，这里扩展一倍队列数，其中 [0-9]对应负数，[10-19]对应正数 (bucket + 10)
            var buckets = Array.init(repeating: Array<Int>(), count: mod * 2)

            for j in 0..<arr.count { //123
                let value = arr[j]
                let currentDigitValue = (value % mod) / dev
                let index = currentDigitValue + mod;

                var bucket = buckets[index]
                bucket.append(arr[j])
                buckets[index] = bucket
            }

            var pos = 0;
            for bucket in buckets {
                for value in bucket {
                    arr[pos] = value
                    pos += 1
                }
            }
            dev *= 10
            mod *= 10
        }

        return arr;
    }

    return radixSort(arr: arr, maxDigit: getMaxDigit(arr: arr))
}

//基数排序(仅针对正数)   参考链接
func radix_sort1(arr: [Int]) -> [Int] {
    var arr = arr

    func getMaxDigit(arr: [Int]) -> Int {
        var maxValue = arr[0];
        for value in arr {
            maxValue = max(maxValue, value)
        }

        var length = 0
        while maxValue != 0 {
            maxValue /= 10
            length += 1
        }

        return length
    }

    func getNumInPos(num: Int, pos: Int) -> Int {
        var temp = 1
        for _ in 0..<pos {
            temp *= 10
        }

        return (num / temp) % 10
    }


    var radixArrays = Array.init(repeating: Array.init(repeating: 0, count: 1), count: 10)

    for pos in 0..<getMaxDigit(arr: arr) {

        //分配过程
        for i in 0..<arr.count {
            let num = getNumInPos(num: arr[i], pos: pos)
            radixArrays[num][0] += 1 //第一个数值用于保存出现的次数, 后续保存出现的次数
            radixArrays[num].append(arr[i])
        }

        //收集过程
        var j = 0
        for i in 0..<10 {
            if radixArrays[i][0] >= 1 {
                for k in 1...radixArrays[i][0] {
                    arr[j] = radixArrays[i][k]
                    j += 1
                }
                radixArrays[i].removeAll()
                radixArrays[i].append(0)
            }
        }
    }
    return arr
}

