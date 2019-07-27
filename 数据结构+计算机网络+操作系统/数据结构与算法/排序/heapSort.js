function buildMaxHeap(arr) {   // 建立大顶堆
    for (let index = (arr.length-1)/2; index >=0 ; index--) {
        heapify(arr, index, arr.length)
    }
}
 
function heapify(arr, i, len) {     // 堆调整
  var left = 2 * i + 1;
  var right = 2 * i + 2;
  var largest = i;
  if(left + 1 <= len && arr[left] > arr[largest]) largest = left   //left < len :这一条件是防止递归时过界
  if(right + 1<= len && arr[right] > arr[largest]) largest = right
  if(largest != i) {
      swap(arr, i, largest)
      heapify(arr,largest, len)
  }
}
 
function swap(arr, i, j) {
    var temp = arr[i];
    arr[i] = arr[j];
    arr[j] = temp;
}
 
function heapSort(arr) {
    var len = arr.length;
    buildMaxHeap(arr);
    for(let i = arr.length-1; i >= 0; i--) {
        swap(arr, 0, i);
        len--
        heapify(arr, 0, len)
    }
}

var arr = [12, 4,23,23,12,1,4,5,6]
heapSort(arr)
console.log(arr) 