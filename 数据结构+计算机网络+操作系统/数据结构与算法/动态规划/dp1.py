#在一个数组arr中，找出一组不相邻的数字，使得最后的和最大
import numpy as np
arr = [1, 100, 8,10, 20,90]
def rec_opt(arr, i):    #递归方法
    if i == 0:
        return arr[0]
    elif i == 1:
        return max(arr[0], arr[1])
    else:
        A = rec_opt(arr, i - 2) + arr[i]
        B = rec_opt(arr, i - 1)
        return max(A, B)

def dp_opt(arr):        #动态规划方法
    opt = np.zeros(len(arr))
    opt[0] = arr[0]
    opt[1] = max(arr[0], arr[1])
    for i in range(2, len(arr)):
        A = opt[i-2] + arr[i]
        B = opt[i-1]
        opt[i] = max(A, B)
    return opt[len(arr) - 1]



print(rec_opt(arr, 5))
print(dp_opt(arr))