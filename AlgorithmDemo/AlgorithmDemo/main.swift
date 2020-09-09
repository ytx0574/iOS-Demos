//
//  main.swift
//  AlgorithmDemo
//
//  Created by Johnson on 2020/9/9.
//  Copyright © 2020 Johnson. All rights reserved.
//

import Foundation

print("Hello, World!")

let ay = [11, 2, 33, 1, 43]
permuted(nums: ay)
solveNQueues(n: 8)

var need_sort_ay = [11, 2, 33, 1, 43, 23, 2, 4, 8, 9, 10, 5, 11, 66, 19]
need_sort_ay = [3, 2, 1]
need_sort_ay = [11, 2, 33, 1, 43, 23, 2]
need_sort_ay = [-11, 2, -2, 33, 1, -43, 23]



select_sort(arr: need_sort_ay)
insert_sort(arr: need_sort_ay)
shell_sort(arr: need_sort_ay)
merge_sort(arr: need_sort_ay)
solveNQueues(n: 1)
//        CPP_solveNQueues(10)
printHellowAlgorithmCPP()
printHellowCPP()
performSolveNQueues(10)
quick_sort(arr: need_sort_ay)
quick_sort2(arr: need_sort_ay)
heap_sort(arr: need_sort_ay)
//        count_sort(arr: need_sort_ay)
//        count_sort2(arr: need_sort_ay)
count_sort3(arr: need_sort_ay)
bucket_sort(arr: need_sort_ay)
bucket_sort2(arr: need_sort_ay)
radix_sort(arr: need_sort_ay)
