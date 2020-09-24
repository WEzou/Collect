//
//  File.swift
//  Algorithm
//
//  Created by oncezou on 2018/12/5.
//  Copyright © 2018年 oncezw. All rights reserved.
//

import Foundation

// 目前限定元素类型为Int
extension Array where Element == Int {
        
    // MARK: 快速排序
    // 有点类似二叉树的感觉
    func quickSort() -> [Int] {
        guard self.count > 1 else {
            return self
        }
        let middle = self[self.count/2]
        let lowArray = self.filter{ $0 < middle }
        let quealArray = self.filter{ $0 == middle }
        let hightArray = self.filter{ $0 > middle}
        return lowArray.quickSort() + quealArray + hightArray.quickSort()
    }

    // MARK: 交换排序
    /*  注: 直接从最小值开始找，如果比当前值小就直接交换
     *  外层遍历数组从0到末尾的元素，索引为i.
     *  里层遍历数组从i+1至数组末尾的元素，索引为j.
     *  当i上的元素比j上的元素大的时候，交换i和j的元素，目的是保持index为i的元素是最小的.
     */
    func switchSort() -> [Int] {
        let count = self.count
        guard count > 1 else {
            return self
        }
        var switchArray = self
        for i in 0..<count-1 {
            for j in i+1..<count {
                if switchArray[i] > switchArray[j] {
                    switchArray.swapAt(i, j)
                }
            }
        }
        return switchArray
    }

    // MARK: 冒泡排序
    /*  注: 前后位置交换，遍历count-1次
     *  外层遍历数组从1到末尾的元素，索引为i.
     *  里层遍历数组从0至数组末尾-i的元素，索引为j.
     *  当j+1上的元素比j上的元素大的时候，交换j+1和j的元素.
     */
    func bubbleSort() -> [Int] {
        let count = self.count
        guard count > 1 else {
            return self
        }
        var bubbleArray = self
        for i in 1..<count {
            for j in 0..<count-i {
                if bubbleArray[j+1] < bubbleArray[j] {
                    bubbleArray.swapAt(j+1, j)
                }
            }
        }
        return bubbleArray
    }

    // MARK: 选择排序
    /*  注: 从最小值开始查找，如果比当前保存的值小，就保存下，单次遍历结束，再交换
     *  在外层循环的开始，将i作为最小值index（很可能不是该数组的最小值）.
     *  在内层循环里面找到当前内层循环范围内的最小值，并与已经记录的最小值作比较:
     *      如果与当前记录的最小值index不同，则替换
     *      如果与当前记录的最小值index相同，则不替换
     */
    func selectSort() -> [Int] {
        let count = self.count
        guard count > 1 else {
            return self
        }
        
        var selectArray = self
        for i in 0..<count-1 {
            var m = i
            for j in i+1..<count {
                if selectArray[m] > selectArray[j] {
                    m = j
                }
            }
            if i != m {
                selectArray.swapAt(i,m)
            }
        }
        return selectArray
    }

    // MARK: 插入排序
    /*  注: 类似反过来的冒泡排序    优势在于数组后面的值是有序的 eg: [23,4,12,5,13,33,35,40,52,66,77]
     *  从数组中拿出一个元素（通常就是第一个元素）以后，再从数组中按顺序拿出其他元素。
     *  如果拿出来的这个元素比这个元素小，就放在这个元素左侧；反之，则放在右侧
     */
    func insertionSort() -> [Int] {
        guard self.count > 1 else {
            return self
        }
        
        var insertArray = self
        for i in 1..<insertArray.count {
            var j = i
            while j > 0 && insertArray[j] < insertArray[j - 1] {
                insertArray.swapAt(j - 1, j)
                j -= 1
            }
        }
        
        return insertArray
    }
}

// MARK: 合并两个数组成一个新的有序数组
/*
 * 定义一个新数组，长度为两个数组长度之和，将两个数组都copy到新数组，然后排序。
 */
func combineArraysToOrdered(_ first: [Int], _ last: [Int]) -> [Int] {
    let array = first + last
    guard array.count > 1 else {
        return array
    }
    let ordered = array.quickSort()
    return ordered
}

// MARK: 合并两个有序数组成一个新的有序数组
/*
 * 给两个数组分别定义一个下标，最大长度是数组长度减一，按位循环比较两个数组，较小元素的放入新数组，下标加一（注意，较大元素对应的下标不加一），直到某一个下标超过数组长度时退出循环，此时较短数组已经全部放入新数组，较长数组还有部分剩余，最后将剩下的部分元素放入新数组。
 */
func mergeOrderedArrays(_ first: [Int], _ last: [Int]) -> [Int] {
    var array: [Int] = []
    let countF = first.count
    let countL = last.count
    var i = 0
    var j = 0
    while (i<countF && j<countL) {
        let valueF = first[i]
        let valueL = last[j]
        if valueF > valueL {
            array.append(valueL)
            j += 1
        }else if valueF < valueL  {
            array.append(valueF)
            i += 1
        }else {
            array.append(valueF)
            array.append(valueL)
            j += 1
            i += 1
        }
    }
    
    if j >= countL {
        let temp = first[i..<countF]
        array += temp
    }
    if i >= countF {
        let temp = last[j..<countL]
        array += temp
    }
    return array
}

// MARK: 在排序数组中寻找两个数的和等于给定数
func findSumEqualGivenNumber(_ array: [Int],_ sum: Int) -> [(Int,Int)] {
    var result = [(Int,Int)]()
    var dic = Dictionary<Int, Int>()
    for index in 0..<array.count {
        let value = array[index]
        let less = sum - value
        if (dic[value] != nil) {
            result.append((dic[value]!,index))
        }else {
            dic[less] = index
        }
    }
    return result
}

// 二分法查找(升序的数组)
func binarySearch<T : Comparable>(array: [T], target: T) -> Int{
    var left = 0
    var right = array.count - 1
    
    while (left <= right) {
        let mid = (left + right) / 2
        let value = array[mid]
        
        if (value == target) {
            return mid
        }
        
        if (value < target) {
            left = mid + 1
        }
        
        if (value > target) {
            right = mid - 1
        }
    }
    return -1
}





