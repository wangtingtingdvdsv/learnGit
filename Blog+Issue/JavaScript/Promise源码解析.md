---
link: null
title: Promise实现原理（附源码）
description: 本篇文章主要在于探究 Promise 的实现原理，带领大家一步一步实现一个 Promise , 不对其用法做说明，如果读者还对Promise的用法不了解，可以查看阮一峰老师的ES6 Promise教程。 接下来，带你一步一步实现一个 Promise 1. P
keywords: JavaScript,前端,Promise
author: null
date: 2018-08-27T09:59:20.566Z
publisher: 掘金
stats: paragraph=192 sentences=149, words=2184
---
> 本篇文章主要在于探究 `Promise` 的实现原理，带领大家一步一步实现一个 `Promise` , 不对其用法做说明，如果读者还对Promise的用法不了解，可以查看阮一峰老师的[ES6 Promise教程](https://link.juejin.im?target=http%3A%2F%2Fes6.ruanyifeng.com%2F%23docs%2Fpromise)。

接下来，带你一步一步实现一个 `Promise`

## 1. `Promise` 基本结构

```
<span class="hljs-keyword">new</span> <span class="hljs-built_in">Promise</span>(<span class="hljs-function">(<span class="hljs-params">resolve, reject</span>) =></span> {
  setTimeout(<span class="hljs-function"><span class="hljs-params">()</span> =></span> {
    resolve(<span class="hljs-string">'FULFILLED'</span>)
  }, <span class="hljs-number">1000</span>)
})
<span class="copy-code-btn">&#x590D;&#x5236;&#x4EE3;&#x7801;</span>
```

> 构造函数 `Promise`必须接受一个函数作为参数，我们称该函数为 `handle`， `handle`又包含 `resolve`和 `reject`两个参数，它们是两个函数。

定义一个判断一个变量是否为函数的方法，后面会用到

```

<span class="hljs-keyword">const</span> isFunction = <span class="hljs-function"><span class="hljs-params">variable</span> =></span> <span class="hljs-keyword">typeof</span> variable === <span class="hljs-string">'function'</span>
<span class="copy-code-btn">&#x590D;&#x5236;&#x4EE3;&#x7801;</span>
```

首先，我们定义一个名为 `MyPromise` 的 `Class`，它接受一个函数 `handle` 作为参数

```
<span class="hljs-class"><span class="hljs-keyword">class</span> <span class="hljs-title">MyPromise</span> </span>{
  <span class="hljs-keyword">constructor</span> (handle) {
    <span class="hljs-keyword">if</span> (!isFunction(handle)) {
      <span class="hljs-keyword">throw</span> <span class="hljs-keyword">new</span> <span class="hljs-built_in">Error</span>(<span class="hljs-string">'MyPromise must accept a function as a parameter'</span>)
    }
  }
}
<span class="copy-code-btn">&#x590D;&#x5236;&#x4EE3;&#x7801;</span>
```

再往下看

## 2. `Promise` 状态和值

`Promise` 对象存在以下三种状态：

* `Pending(&#x8FDB;&#x884C;&#x4E2D;)`
* `Fulfilled(&#x5DF2;&#x6210;&#x529F;)`
* `Rejected(&#x5DF2;&#x5931;&#x8D25;)`

> 状态只能由 `Pending` 变为 `Fulfilled` 或由 `Pending` 变为 `Rejected` ，且状态改变之后不会在发生变化，会一直保持这个状态。

`Promise`的值是指状态改变时传递给回调函数的值

> 上文中 `handle`函数包含 `resolve` 和 `reject` 两个参数，它们是两个函数，可以用于改变 `Promise` 的状态和传入 `Promise` 的值

```
<span class="hljs-keyword">new</span> <span class="hljs-built_in">Promise</span>(<span class="hljs-function">(<span class="hljs-params">resolve, reject</span>) =></span> {
  setTimeout(<span class="hljs-function"><span class="hljs-params">()</span> =></span> {
    resolve(<span class="hljs-string">'FULFILLED'</span>)
  }, <span class="hljs-number">1000</span>)
})
<span class="copy-code-btn">&#x590D;&#x5236;&#x4EE3;&#x7801;</span>
```

这里 `resolve` 传入的 `"FULFILLED"` 就是 `Promise` 的值

`resolve` 和 `reject`

* `resolve` : 将Promise对象的状态从 `Pending(&#x8FDB;&#x884C;&#x4E2D;)` 变为 `Fulfilled(&#x5DF2;&#x6210;&#x529F;)`
* `reject` : 将Promise对象的状态从 `Pending(&#x8FDB;&#x884C;&#x4E2D;)` 变为 `Rejected(&#x5DF2;&#x5931;&#x8D25;)`
* `resolve` 和 `reject` 都可以传入任意类型的值作为实参，表示 `Promise` 对象成功 `&#xFF08;Fulfilled&#xFF09;`和失败 `&#xFF08;Rejected&#xFF09;`的值

了解了 `Promise` 的状态和值，接下来，我们为 `MyPromise` 添加状态属性和值

> 首先定义三个常量，用于标记Promise对象的三种状态

```

<span class="hljs-keyword">const</span> PENDING = <span class="hljs-string">'PENDING'</span>
<span class="hljs-keyword">const</span> FULFILLED = <span class="hljs-string">'FULFILLED'</span>
<span class="hljs-keyword">const</span> REJECTED = <span class="hljs-string">'REJECTED'</span>
<span class="copy-code-btn">&#x590D;&#x5236;&#x4EE3;&#x7801;</span>
```

> 再为 `MyPromise` 添加状态和值，并添加状态改变的执行逻辑

```
<span class="hljs-class"><span class="hljs-keyword">class</span> <span class="hljs-title">MyPromise</span> </span>{
  <span class="hljs-keyword">constructor</span> (handle) {
    <span class="hljs-keyword">if</span> (!isFunction(handle)) {
      <span class="hljs-keyword">throw</span> <span class="hljs-keyword">new</span> <span class="hljs-built_in">Error</span>(<span class="hljs-string">'MyPromise must accept a function as a parameter'</span>)
    }

    <span class="hljs-keyword">this</span>._status = PENDING

    <span class="hljs-keyword">this</span>._value = <span class="hljs-literal">undefined</span>

    <span class="hljs-keyword">try</span> {
      handle(<span class="hljs-keyword">this</span>._resolve.bind(<span class="hljs-keyword">this</span>), <span class="hljs-keyword">this</span>._reject.bind(<span class="hljs-keyword">this</span>))
    } <span class="hljs-keyword">catch</span> (err) {
      <span class="hljs-keyword">this</span>._reject(err)
    }
  }

  _resolve (val) {
    <span class="hljs-keyword">if</span> (<span class="hljs-keyword">this</span>._status !== PENDING) <span class="hljs-keyword">return</span>
    <span class="hljs-keyword">this</span>._status = FULFILLED
    <span class="hljs-keyword">this</span>._value = val
  }

  _reject (err) {
    <span class="hljs-keyword">if</span> (<span class="hljs-keyword">this</span>._status !== PENDING) <span class="hljs-keyword">return</span>
    <span class="hljs-keyword">this</span>._status = REJECTED
    <span class="hljs-keyword">this</span>._value = err
  }
}
<span class="copy-code-btn">&#x590D;&#x5236;&#x4EE3;&#x7801;</span>
```

这样就实现了 `Promise` 状态和值的改变。下面说一说 `Promise` 的核心: `then` 方法

## 3. `Promise` 的 `then` 方法

`Promise` 对象的 `then` 方法接受两个参数：

```
promise.then(onFulfilled, onRejected)
<span class="copy-code-btn">&#x590D;&#x5236;&#x4EE3;&#x7801;</span>
```

**参数可选**

`onFulfilled` 和 `onRejected` 都是可选参数。

* 如果 `onFulfilled` 或 `onRejected` 不是函数，其必须被忽略

**`onFulfilled` 特性**

如果 `onFulfilled` 是函数：

* 当 `promise` 状态变为成功时必须被调用，其第一个参数为 `promise` 成功状态传入的值（ `resolve` 执行时传入的值）
* 在 `promise` 状态改变前其不可被调用
* 其调用次数不可超过一次

**`onRejected` 特性**

如果 `onRejected` 是函数：

* 当 `promise` 状态变为失败时必须被调用，其第一个参数为 `promise` 失败状态传入的值（ `reject` 执行时传入的值）
* 在 `promise` 状态改变前其不可被调用
* 其调用次数不可超过一次

**多次调用**

`then` 方法可以被同一个 `promise` 对象调用多次

* 当 `promise` 成功状态时，所有 `onFulfilled` 需按照其注册顺序依次回调
* 当 `promise` 失败状态时，所有 `onRejected` 需按照其注册顺序依次回调

`then` 方法必须返回一个新的 `promise` 对象

```
promise2 = promise1.then(onFulfilled, onRejected);
<span class="copy-code-btn">&#x590D;&#x5236;&#x4EE3;&#x7801;</span>
```

因此 `promise` 支持链式调用

```
promise1.then(onFulfilled1, onRejected1).then(onFulfilled2, onRejected2);
<span class="copy-code-btn">&#x590D;&#x5236;&#x4EE3;&#x7801;</span>
```

这里涉及到 `Promise` 的执行规则，包括"值的传递"和"错误捕获"机制：

1、如果 `onFulfilled` 或者 `onRejected` 返回一个值 `x` ，则运行下面的 `Promise` 解决过程： `[[Resolve]](promise2, x)`

* 若 `x` 不为 `Promise` ，则使 `x` 直接作为新返回的 `Promise` 对象的值， 即新的 `onFulfilled` 或者 `onRejected` 函数的参数.

* 若 `x` 为 `Promise` ，这时后一个回调函数，就会等待该 `Promise` 对象(即 `x` )的状态发生变化，才会被调用，并且新的 `Promise` 状态和 `x` 的状态相同。

下面的例子用于帮助理解：

```
<span class="hljs-keyword">let</span> promise1 = <span class="hljs-keyword">new</span> <span class="hljs-built_in">Promise</span>(<span class="hljs-function">(<span class="hljs-params">resolve, reject</span>) =></span> {
  setTimeout(<span class="hljs-function"><span class="hljs-params">()</span> =></span> {
    resolve()
  }, <span class="hljs-number">1000</span>)
})
promise2 = promise1.then(<span class="hljs-function"><span class="hljs-params">res</span> =></span> {

  <span class="hljs-keyword">return</span> <span class="hljs-string">'&#x8FD9;&#x91CC;&#x8FD4;&#x56DE;&#x4E00;&#x4E2A;&#x666E;&#x901A;&#x503C;'</span>
})
promise2.then(<span class="hljs-function"><span class="hljs-params">res</span> =></span> {
  <span class="hljs-built_in">console</span>.log(res)
})
<span class="copy-code-btn">&#x590D;&#x5236;&#x4EE3;&#x7801;</span>
```

```
<span class="hljs-keyword">let</span> promise1 = <span class="hljs-keyword">new</span> <span class="hljs-built_in">Promise</span>(<span class="hljs-function">(<span class="hljs-params">resolve, reject</span>) =></span> {
  setTimeout(<span class="hljs-function"><span class="hljs-params">()</span> =></span> {
    resolve()
  }, <span class="hljs-number">1000</span>)
})
promise2 = promise1.then(<span class="hljs-function"><span class="hljs-params">res</span> =></span> {

  <span class="hljs-keyword">return</span> <span class="hljs-keyword">new</span> <span class="hljs-built_in">Promise</span>(<span class="hljs-function">(<span class="hljs-params">resolve, reject</span>) =></span> {
    setTimeout(<span class="hljs-function"><span class="hljs-params">()</span> =></span> {
     resolve(<span class="hljs-string">'&#x8FD9;&#x91CC;&#x8FD4;&#x56DE;&#x4E00;&#x4E2A;Promise'</span>)
    }, <span class="hljs-number">2000</span>)
  })
})
promise2.then(<span class="hljs-function"><span class="hljs-params">res</span> =></span> {
  <span class="hljs-built_in">console</span>.log(res)
})
<span class="copy-code-btn">&#x590D;&#x5236;&#x4EE3;&#x7801;</span>
```

2、如果 `onFulfilled` 或者 `onRejected` 抛出一个异常 `e` ，则 `promise2` 必须变为失败 `&#xFF08;Rejected&#xFF09;`，并返回失败的值 `e`，例如：

```
<span class="hljs-keyword">let</span> promise1 = <span class="hljs-keyword">new</span> <span class="hljs-built_in">Promise</span>(<span class="hljs-function">(<span class="hljs-params">resolve, reject</span>) =></span> {
  setTimeout(<span class="hljs-function"><span class="hljs-params">()</span> =></span> {
    resolve(<span class="hljs-string">'success'</span>)
  }, <span class="hljs-number">1000</span>)
})
promise2 = promise1.then(<span class="hljs-function"><span class="hljs-params">res</span> =></span> {
  <span class="hljs-keyword">throw</span> <span class="hljs-keyword">new</span> <span class="hljs-built_in">Error</span>(<span class="hljs-string">'&#x8FD9;&#x91CC;&#x629B;&#x51FA;&#x4E00;&#x4E2A;&#x5F02;&#x5E38;e'</span>)
})
promise2.then(<span class="hljs-function"><span class="hljs-params">res</span> =></span> {
  <span class="hljs-built_in">console</span>.log(res)
}, err => {
  <span class="hljs-built_in">console</span>.log(err)
})
<span class="copy-code-btn">&#x590D;&#x5236;&#x4EE3;&#x7801;</span>
```

3、如果 `onFulfilled` 不是函数且 `promise1` 状态为成功 `&#xFF08;Fulfilled&#xFF09;`， `promise2` 必须变为成功 `&#xFF08;Fulfilled&#xFF09;`并返回 `promise1` 成功的值，例如：

```
<span class="hljs-keyword">let</span> promise1 = <span class="hljs-keyword">new</span> <span class="hljs-built_in">Promise</span>(<span class="hljs-function">(<span class="hljs-params">resolve, reject</span>) =></span> {
  setTimeout(<span class="hljs-function"><span class="hljs-params">()</span> =></span> {
    resolve(<span class="hljs-string">'success'</span>)
  }, <span class="hljs-number">1000</span>)
})
promise2 = promise1.then(<span class="hljs-string">'&#x8FD9;&#x91CC;&#x7684;onFulfilled&#x672C;&#x6765;&#x662F;&#x4E00;&#x4E2A;&#x51FD;&#x6570;&#xFF0C;&#x4F46;&#x73B0;&#x5728;&#x4E0D;&#x662F;'</span>)
promise2.then(<span class="hljs-function"><span class="hljs-params">res</span> =></span> {
  <span class="hljs-built_in">console</span>.log(res)
}, err => {
  <span class="hljs-built_in">console</span>.log(err)
})
<span class="copy-code-btn">&#x590D;&#x5236;&#x4EE3;&#x7801;</span>
```

4、如果 `onRejected` 不是函数且 `promise1` 状态为失败 `&#xFF08;Rejected&#xFF09;`， `promise2`必须变为失败 `&#xFF08;Rejected&#xFF09;` 并返回 `promise1` 失败的值，例如：

```
<span class="hljs-keyword">let</span> promise1 = <span class="hljs-keyword">new</span> <span class="hljs-built_in">Promise</span>(<span class="hljs-function">(<span class="hljs-params">resolve, reject</span>) =></span> {
  setTimeout(<span class="hljs-function"><span class="hljs-params">()</span> =></span> {
    reject(<span class="hljs-string">'fail'</span>)
  }, <span class="hljs-number">1000</span>)
})
promise2 = promise1.then(<span class="hljs-function"><span class="hljs-params">res</span> =></span> res, <span class="hljs-string">'&#x8FD9;&#x91CC;&#x7684;onRejected&#x672C;&#x6765;&#x662F;&#x4E00;&#x4E2A;&#x51FD;&#x6570;&#xFF0C;&#x4F46;&#x73B0;&#x5728;&#x4E0D;&#x662F;'</span>)
promise2.then(<span class="hljs-function"><span class="hljs-params">res</span> =></span> {
  <span class="hljs-built_in">console</span>.log(res)
}, err => {
  <span class="hljs-built_in">console</span>.log(err)
})
<span class="copy-code-btn">&#x590D;&#x5236;&#x4EE3;&#x7801;</span>
```

根据上面的规则，我们来为 完善 `MyPromise`

修改 `constructor` : 增加执行队列

由于 `then` 方法支持多次调用，我们可以维护两个数组，将每次 `then` 方法注册时的回调函数添加到数组中，等待执行

```
<span class="hljs-keyword">constructor</span> (handle) {
  <span class="hljs-keyword">if</span> (!isFunction(handle)) {
    <span class="hljs-keyword">throw</span> <span class="hljs-keyword">new</span> <span class="hljs-built_in">Error</span>(<span class="hljs-string">'MyPromise must accept a function as a parameter'</span>)
  }

  <span class="hljs-keyword">this</span>._status = PENDING

  <span class="hljs-keyword">this</span>._value = <span class="hljs-literal">undefined</span>

  <span class="hljs-keyword">this</span>._fulfilledQueues = []

  <span class="hljs-keyword">this</span>._rejectedQueues = []

  <span class="hljs-keyword">try</span> {
    handle(<span class="hljs-keyword">this</span>._resolve.bind(<span class="hljs-keyword">this</span>), <span class="hljs-keyword">this</span>._reject.bind(<span class="hljs-keyword">this</span>))
  } <span class="hljs-keyword">catch</span> (err) {
    <span class="hljs-keyword">this</span>._reject(err)
  }
}
<span class="copy-code-btn">&#x590D;&#x5236;&#x4EE3;&#x7801;</span>
```

添加then方法

首先， `then` 返回一个新的 `Promise` 对象，并且需要将回调函数加入到执行队列中

```

then (onFulfilled, onRejected) {
  <span class="hljs-keyword">const</span> { _value, _status } = <span class="hljs-keyword">this</span>
  <span class="hljs-keyword">switch</span> (_status) {

    <span class="hljs-keyword">case</span> PENDING:
      <span class="hljs-keyword">this</span>._fulfilledQueues.push(onFulfilled)
      <span class="hljs-keyword">this</span>._rejectedQueues.push(onRejected)
      <span class="hljs-keyword">break</span>

    <span class="hljs-keyword">case</span> FULFILLED:
      onFulfilled(_value)
      <span class="hljs-keyword">break</span>
    <span class="hljs-keyword">case</span> REJECTED:
      onRejected(_value)
      <span class="hljs-keyword">break</span>
  }

  <span class="hljs-keyword">return</span> <span class="hljs-keyword">new</span> MyPromise(<span class="hljs-function">(<span class="hljs-params">onFulfilledNext, onRejectedNext</span>) =></span> {
  })
}
<span class="copy-code-btn">&#x590D;&#x5236;&#x4EE3;&#x7801;</span>
```

那返回的新的 `Promise` 对象什么时候改变状态？改变为哪种状态呢？

根据上文中 `then` 方法的规则，我们知道返回的新的 `Promise` 对象的状态依赖于当前 `then` 方法回调函数执行的情况以及返回值，例如 `then` 的参数是否为一个函数、回调函数执行是否出错、返回值是否为 `Promise` 对象。

我们来进一步完善 `then` 方法:

```

then (onFulfilled, onRejected) {
  <span class="hljs-keyword">const</span> { _value, _status } = <span class="hljs-keyword">this</span>

  <span class="hljs-keyword">return</span> <span class="hljs-keyword">new</span> MyPromise(<span class="hljs-function">(<span class="hljs-params">onFulfilledNext, onRejectedNext</span>) =></span> {

    <span class="hljs-keyword">let</span> fulfilled = <span class="hljs-function"><span class="hljs-params">value</span> =></span> {
      <span class="hljs-keyword">try</span> {
        <span class="hljs-keyword">if</span> (!isFunction(onFulfilled)) {
          onFulfilledNext(value)
        } <span class="hljs-keyword">else</span> {
          <span class="hljs-keyword">let</span> res =  onFulfilled(value);
          <span class="hljs-keyword">if</span> (res <span class="hljs-keyword">instanceof</span> MyPromise) {

            res.then(onFulfilledNext, onRejectedNext)
          } <span class="hljs-keyword">else</span> {

            onFulfilledNext(res)
          }
        }
      } <span class="hljs-keyword">catch</span> (err) {

        onRejectedNext(err)
      }
    }

    <span class="hljs-keyword">let</span> rejected = <span class="hljs-function"><span class="hljs-params">error</span> =></span> {
      <span class="hljs-keyword">try</span> {
        <span class="hljs-keyword">if</span> (!isFunction(onRejected)) {
          onRejectedNext(error)
        } <span class="hljs-keyword">else</span> {
            <span class="hljs-keyword">let</span> res = onRejected(error);
            <span class="hljs-keyword">if</span> (res <span class="hljs-keyword">instanceof</span> MyPromise) {

              res.then(onFulfilledNext, onRejectedNext)
            } <span class="hljs-keyword">else</span> {

              onFulfilledNext(res)
            }
        }
      } <span class="hljs-keyword">catch</span> (err) {

        onRejectedNext(err)
      }
    }
    <span class="hljs-keyword">switch</span> (_status) {

      <span class="hljs-keyword">case</span> PENDING:
        <span class="hljs-keyword">this</span>._fulfilledQueues.push(fulfilled)
        <span class="hljs-keyword">this</span>._rejectedQueues.push(rejected)
        <span class="hljs-keyword">break</span>

      <span class="hljs-keyword">case</span> FULFILLED:
        fulfilled(_value)
        <span class="hljs-keyword">break</span>
      <span class="hljs-keyword">case</span> REJECTED:
        rejected(_value)
        <span class="hljs-keyword">break</span>
    }
  })
}
<span class="copy-code-btn">&#x590D;&#x5236;&#x4EE3;&#x7801;</span>
```

> 这一部分可能不太好理解，读者需要结合上文中 `then` 方法的规则来细细的分析。

接着修改 `_resolve` 和 `_reject` ：依次执行队列中的函数

当 `resolve` 或 `reject` 方法执行时，我们依次提取成功或失败任务队列当中的函数开始执行，并清空队列，从而实现 `then` 方法的多次调用，实现的代码如下：

```

_resolve (val) {
  <span class="hljs-keyword">if</span> (<span class="hljs-keyword">this</span>._status !== PENDING) <span class="hljs-keyword">return</span>

  <span class="hljs-keyword">const</span> run = <span class="hljs-function"><span class="hljs-params">()</span> =></span> {
    <span class="hljs-keyword">this</span>._status = FULFILLED
    <span class="hljs-keyword">this</span>._value = val
    <span class="hljs-keyword">let</span> cb;
    <span class="hljs-keyword">while</span> (cb = <span class="hljs-keyword">this</span>._fulfilledQueues.shift()) {
      cb(val)
    }
  }

  setTimeout(<span class="hljs-function"><span class="hljs-params">()</span> =></span> run(), <span class="hljs-number">0</span>)
}

_reject (err) {
  <span class="hljs-keyword">if</span> (<span class="hljs-keyword">this</span>._status !== PENDING) <span class="hljs-keyword">return</span>

  <span class="hljs-keyword">const</span> run = <span class="hljs-function"><span class="hljs-params">()</span> =></span> {
    <span class="hljs-keyword">this</span>._status = REJECTED
    <span class="hljs-keyword">this</span>._value = err
    <span class="hljs-keyword">let</span> cb;
    <span class="hljs-keyword">while</span> (cb = <span class="hljs-keyword">this</span>._rejectedQueues.shift()) {
      cb(err)
    }
  }

  setTimeout(run, <span class="hljs-number">0</span>)
}
<span class="copy-code-btn">&#x590D;&#x5236;&#x4EE3;&#x7801;</span>
```

这里还有一种特殊的情况，就是当 `resolve` 方法传入的参数为一个 `Promise` 对象时，则该 `Promise` 对象状态决定当前 `Promise` 对象的状态。

```
<span class="hljs-keyword">const</span> p1 = <span class="hljs-keyword">new</span> <span class="hljs-built_in">Promise</span>(<span class="hljs-function"><span class="hljs-keyword">function</span> (<span class="hljs-params">resolve, reject</span>) </span>{

});

<span class="hljs-keyword">const</span> p2 = <span class="hljs-keyword">new</span> <span class="hljs-built_in">Promise</span>(<span class="hljs-function"><span class="hljs-keyword">function</span> (<span class="hljs-params">resolve, reject</span>) </span>{

  resolve(p1);
})
<span class="copy-code-btn">&#x590D;&#x5236;&#x4EE3;&#x7801;</span>
```

上面代码中， `p1` 和 `p2` 都是 `Promise` 的实例，但是 `p2` 的 `resolve`方法将 `p1` 作为参数，即一个异步操作的结果是返回另一个异步操作。

注意，这时 `p1` 的状态就会传递给 `p2`，也就是说， `p1` 的状态决定了 `p2` 的状态。如果 `p1` 的状态是 `Pending`，那么 `p2` 的回调函数就会等待 `p1` 的状态改变；如果 `p1` 的状态已经是 `Fulfilled` 或者 `Rejected`，那么 `p2` 的回调函数将会立刻执行。

我们来修改 `_resolve`来支持这样的特性

```

  _resolve (val) {
    <span class="hljs-keyword">const</span> run = <span class="hljs-function"><span class="hljs-params">()</span> =></span> {
      <span class="hljs-keyword">if</span> (<span class="hljs-keyword">this</span>._status !== PENDING) <span class="hljs-keyword">return</span>

      <span class="hljs-keyword">const</span> runFulfilled = <span class="hljs-function">(<span class="hljs-params">value</span>) =></span> {
        <span class="hljs-keyword">let</span> cb;
        <span class="hljs-keyword">while</span> (cb = <span class="hljs-keyword">this</span>._fulfilledQueues.shift()) {
          cb(value)
        }
      }

      <span class="hljs-keyword">const</span> runRejected = <span class="hljs-function">(<span class="hljs-params">error</span>) =></span> {
        <span class="hljs-keyword">let</span> cb;
        <span class="hljs-keyword">while</span> (cb = <span class="hljs-keyword">this</span>._rejectedQueues.shift()) {
          cb(error)
        }
      }

      <span class="hljs-keyword">if</span> (val <span class="hljs-keyword">instanceof</span> MyPromise) {
        val.then(<span class="hljs-function"><span class="hljs-params">value</span> =></span> {
          <span class="hljs-keyword">this</span>._value = value
          <span class="hljs-keyword">this</span>._status = FULFILLED
          runFulfilled(value)
        }, err => {
          <span class="hljs-keyword">this</span>._value = err
          <span class="hljs-keyword">this</span>._status = REJECTED
          runRejected(err)
        })
      } <span class="hljs-keyword">else</span> {
        <span class="hljs-keyword">this</span>._value = val
        <span class="hljs-keyword">this</span>._status = FULFILLED
        runFulfilled(val)
      }
    }

    setTimeout(run, <span class="hljs-number">0</span>)
  }
<span class="copy-code-btn">&#x590D;&#x5236;&#x4EE3;&#x7801;</span>
```

这样一个Promise就基本实现了，现在我们来加一些其它的方法

`catch` 方法

> 相当于调用 `then` 方法, 但只传入 `Rejected` 状态的回调函数

```

<span class="hljs-keyword">catch</span> (onRejected) {
  <span class="hljs-keyword">return</span> <span class="hljs-keyword">this</span>.then(<span class="hljs-literal">undefined</span>, onRejected)
}
<span class="copy-code-btn">&#x590D;&#x5236;&#x4EE3;&#x7801;</span>
```

静态 `resolve` 方法

```

<span class="hljs-keyword">static</span> resolve (value) {

  <span class="hljs-keyword">if</span> (value <span class="hljs-keyword">instanceof</span> MyPromise) <span class="hljs-keyword">return</span> value
  <span class="hljs-keyword">return</span> <span class="hljs-keyword">new</span> MyPromise(<span class="hljs-function"><span class="hljs-params">resolve</span> =></span> resolve(value))
}
<span class="copy-code-btn">&#x590D;&#x5236;&#x4EE3;&#x7801;</span>
```

静态 `reject` 方法

```

<span class="hljs-keyword">static</span> reject (value) {
  <span class="hljs-keyword">return</span> <span class="hljs-keyword">new</span> MyPromise(<span class="hljs-function">(<span class="hljs-params">resolve ,reject</span>) =></span> reject(value))
}
<span class="copy-code-btn">&#x590D;&#x5236;&#x4EE3;&#x7801;</span>
```

静态 `all` 方法

```

<span class="hljs-keyword">static</span> all (list) {
  <span class="hljs-keyword">return</span> <span class="hljs-keyword">new</span> MyPromise(<span class="hljs-function">(<span class="hljs-params">resolve, reject</span>) =></span> {

    <span class="hljs-keyword">let</span> values = []
    <span class="hljs-keyword">let</span> count = <span class="hljs-number">0</span>
    <span class="hljs-keyword">for</span> (<span class="hljs-keyword">let</span> [i, p] <span class="hljs-keyword">of</span> list.entries()) {

      <span class="hljs-keyword">this</span>.resolve(p).then(<span class="hljs-function"><span class="hljs-params">res</span> =></span> {
        values[i] = res
        count++

        <span class="hljs-keyword">if</span> (count === list.length) resolve(values)
      }, err => {

        reject(err)
      })
    }
  })
}
<span class="copy-code-btn">&#x590D;&#x5236;&#x4EE3;&#x7801;</span>
```

静态 `race` 方法

```

<span class="hljs-keyword">static</span> race (list) {
  <span class="hljs-keyword">return</span> <span class="hljs-keyword">new</span> MyPromise(<span class="hljs-function">(<span class="hljs-params">resolve, reject</span>) =></span> {
    <span class="hljs-keyword">for</span> (<span class="hljs-keyword">let</span> p <span class="hljs-keyword">of</span> list) {

      <span class="hljs-keyword">this</span>.resolve(p).then(<span class="hljs-function"><span class="hljs-params">res</span> =></span> {
        resolve(res)
      }, err => {
        reject(err)
      })
    }
  })
}
<span class="copy-code-btn">&#x590D;&#x5236;&#x4EE3;&#x7801;</span>
```

`finally` 方法

> `finally` 方法用于指定不管 `Promise` 对象最后状态如何，都会执行的操作

```
<span class="hljs-keyword">finally</span> (cb) {
  <span class="hljs-keyword">return</span> <span class="hljs-keyword">this</span>.then(
    <span class="hljs-function"><span class="hljs-params">value</span>  =></span> MyPromise.resolve(cb()).then(<span class="hljs-function"><span class="hljs-params">()</span> =></span> value),
    reason => MyPromise.resolve(cb()).then(<span class="hljs-function"><span class="hljs-params">()</span> =></span> { <span class="hljs-keyword">throw</span> reason })
  );
};
<span class="copy-code-btn">&#x590D;&#x5236;&#x4EE3;&#x7801;</span>
```

这样一个完整的 `Promsie` 就实现了，大家对 `Promise` 的原理也有了解，可以让我们在使用Promise的时候更加清晰明了。

完整代码如下

```

  <span class="hljs-keyword">const</span> isFunction = <span class="hljs-function"><span class="hljs-params">variable</span> =></span> <span class="hljs-keyword">typeof</span> variable === <span class="hljs-string">'function'</span>

  <span class="hljs-keyword">const</span> PENDING = <span class="hljs-string">'PENDING'</span>
  <span class="hljs-keyword">const</span> FULFILLED = <span class="hljs-string">'FULFILLED'</span>
  <span class="hljs-keyword">const</span> REJECTED = <span class="hljs-string">'REJECTED'</span>

  <span class="hljs-class"><span class="hljs-keyword">class</span> <span class="hljs-title">MyPromise</span> </span>{
    <span class="hljs-keyword">constructor</span> (handle) {
      <span class="hljs-keyword">if</span> (!isFunction(handle)) {
        <span class="hljs-keyword">throw</span> <span class="hljs-keyword">new</span> <span class="hljs-built_in">Error</span>(<span class="hljs-string">'MyPromise must accept a function as a parameter'</span>)
      }

      <span class="hljs-keyword">this</span>._status = PENDING

      <span class="hljs-keyword">this</span>._value = <span class="hljs-literal">undefined</span>

      <span class="hljs-keyword">this</span>._fulfilledQueues = []

      <span class="hljs-keyword">this</span>._rejectedQueues = []

      <span class="hljs-keyword">try</span> {
        handle(<span class="hljs-keyword">this</span>._resolve.bind(<span class="hljs-keyword">this</span>), <span class="hljs-keyword">this</span>._reject.bind(<span class="hljs-keyword">this</span>))
      } <span class="hljs-keyword">catch</span> (err) {
        <span class="hljs-keyword">this</span>._reject(err)
      }
    }

    _resolve (val) {
      <span class="hljs-keyword">const</span> run = <span class="hljs-function"><span class="hljs-params">()</span> =></span> {
        <span class="hljs-keyword">if</span> (<span class="hljs-keyword">this</span>._status !== PENDING) <span class="hljs-keyword">return</span>

        <span class="hljs-keyword">const</span> runFulfilled = <span class="hljs-function">(<span class="hljs-params">value</span>) =></span> {
          <span class="hljs-keyword">let</span> cb;
          <span class="hljs-keyword">while</span> (cb = <span class="hljs-keyword">this</span>._fulfilledQueues.shift()) {
            cb(value)
          }
        }

        <span class="hljs-keyword">const</span> runRejected = <span class="hljs-function">(<span class="hljs-params">error</span>) =></span> {
          <span class="hljs-keyword">let</span> cb;
          <span class="hljs-keyword">while</span> (cb = <span class="hljs-keyword">this</span>._rejectedQueues.shift()) {
            cb(error)
          }
        }

        <span class="hljs-keyword">if</span> (val <span class="hljs-keyword">instanceof</span> MyPromise) {
          val.then(<span class="hljs-function"><span class="hljs-params">value</span> =></span> {
            <span class="hljs-keyword">this</span>._value = value
            <span class="hljs-keyword">this</span>._status = FULFILLED
            runFulfilled(value)
          }, err => {
            <span class="hljs-keyword">this</span>._value = err
            <span class="hljs-keyword">this</span>._status = REJECTED
            runRejected(err)
          })
        } <span class="hljs-keyword">else</span> {
          <span class="hljs-keyword">this</span>._value = val
          <span class="hljs-keyword">this</span>._status = FULFILLED
          runFulfilled(val)
        }
      }

      setTimeout(run, <span class="hljs-number">0</span>)
    }

    _reject (err) {
      <span class="hljs-keyword">if</span> (<span class="hljs-keyword">this</span>._status !== PENDING) <span class="hljs-keyword">return</span>

      <span class="hljs-keyword">const</span> run = <span class="hljs-function"><span class="hljs-params">()</span> =></span> {
        <span class="hljs-keyword">this</span>._status = REJECTED
        <span class="hljs-keyword">this</span>._value = err
        <span class="hljs-keyword">let</span> cb;
        <span class="hljs-keyword">while</span> (cb = <span class="hljs-keyword">this</span>._rejectedQueues.shift()) {
          cb(err)
        }
      }

      setTimeout(run, <span class="hljs-number">0</span>)
    }

    then (onFulfilled, onRejected) {
      <span class="hljs-keyword">const</span> { _value, _status } = <span class="hljs-keyword">this</span>

      <span class="hljs-keyword">return</span> <span class="hljs-keyword">new</span> MyPromise(<span class="hljs-function">(<span class="hljs-params">onFulfilledNext, onRejectedNext</span>) =></span> {

        <span class="hljs-keyword">let</span> fulfilled = <span class="hljs-function"><span class="hljs-params">value</span> =></span> {
          <span class="hljs-keyword">try</span> {
            <span class="hljs-keyword">if</span> (!isFunction(onFulfilled)) {
              onFulfilledNext(value)
            } <span class="hljs-keyword">else</span> {
              <span class="hljs-keyword">let</span> res =  onFulfilled(value);
              <span class="hljs-keyword">if</span> (res <span class="hljs-keyword">instanceof</span> MyPromise) {

                res.then(onFulfilledNext, onRejectedNext)
              } <span class="hljs-keyword">else</span> {

                onFulfilledNext(res)
              }
            }
          } <span class="hljs-keyword">catch</span> (err) {

            onRejectedNext(err)
          }
        }

        <span class="hljs-keyword">let</span> rejected = <span class="hljs-function"><span class="hljs-params">error</span> =></span> {
          <span class="hljs-keyword">try</span> {
            <span class="hljs-keyword">if</span> (!isFunction(onRejected)) {
              onRejectedNext(error)
            } <span class="hljs-keyword">else</span> {
                <span class="hljs-keyword">let</span> res = onRejected(error);
                <span class="hljs-keyword">if</span> (res <span class="hljs-keyword">instanceof</span> MyPromise) {

                  res.then(onFulfilledNext, onRejectedNext)
                } <span class="hljs-keyword">else</span> {

                  onFulfilledNext(res)
                }
            }
          } <span class="hljs-keyword">catch</span> (err) {

            onRejectedNext(err)
          }
        }
        <span class="hljs-keyword">switch</span> (_status) {

          <span class="hljs-keyword">case</span> PENDING:
            <span class="hljs-keyword">this</span>._fulfilledQueues.push(fulfilled)
            <span class="hljs-keyword">this</span>._rejectedQueues.push(rejected)
            <span class="hljs-keyword">break</span>

          <span class="hljs-keyword">case</span> FULFILLED:
            fulfilled(_value)
            <span class="hljs-keyword">break</span>
          <span class="hljs-keyword">case</span> REJECTED:
            rejected(_value)
            <span class="hljs-keyword">break</span>
        }
      })
    }

    <span class="hljs-keyword">catch</span> (onRejected) {
      <span class="hljs-keyword">return</span> <span class="hljs-keyword">this</span>.then(<span class="hljs-literal">undefined</span>, onRejected)
    }

    <span class="hljs-keyword">static</span> resolve (value) {

      <span class="hljs-keyword">if</span> (value <span class="hljs-keyword">instanceof</span> MyPromise) <span class="hljs-keyword">return</span> value
      <span class="hljs-keyword">return</span> <span class="hljs-keyword">new</span> MyPromise(<span class="hljs-function"><span class="hljs-params">resolve</span> =></span> resolve(value))
    }

    <span class="hljs-keyword">static</span> reject (value) {
      <span class="hljs-keyword">return</span> <span class="hljs-keyword">new</span> MyPromise(<span class="hljs-function">(<span class="hljs-params">resolve ,reject</span>) =></span> reject(value))
    }

    <span class="hljs-keyword">static</span> all (list) {
      <span class="hljs-keyword">return</span> <span class="hljs-keyword">new</span> MyPromise(<span class="hljs-function">(<span class="hljs-params">resolve, reject</span>) =></span> {

        <span class="hljs-keyword">let</span> values = []
        <span class="hljs-keyword">let</span> count = <span class="hljs-number">0</span>
        <span class="hljs-keyword">for</span> (<span class="hljs-keyword">let</span> [i, p] <span class="hljs-keyword">of</span> list.entries()) {

          <span class="hljs-keyword">this</span>.resolve(p).then(<span class="hljs-function"><span class="hljs-params">res</span> =></span> {
            values[i] = res
            count++

            <span class="hljs-keyword">if</span> (count === list.length) resolve(values)
          }, err => {

            reject(err)
          })
        }
      })
    }

    <span class="hljs-keyword">static</span> race (list) {
      <span class="hljs-keyword">return</span> <span class="hljs-keyword">new</span> MyPromise(<span class="hljs-function">(<span class="hljs-params">resolve, reject</span>) =></span> {
        <span class="hljs-keyword">for</span> (<span class="hljs-keyword">let</span> p <span class="hljs-keyword">of</span> list) {

          <span class="hljs-keyword">this</span>.resolve(p).then(<span class="hljs-function"><span class="hljs-params">res</span> =></span> {
            resolve(res)
          }, err => {
            reject(err)
          })
        }
      })
    }
    <span class="hljs-keyword">finally</span> (cb) {
      <span class="hljs-keyword">return</span> <span class="hljs-keyword">this</span>.then(
        <span class="hljs-function"><span class="hljs-params">value</span>  =></span> MyPromise.resolve(cb()).then(<span class="hljs-function"><span class="hljs-params">()</span> =></span> value),
        reason => MyPromise.resolve(cb()).then(<span class="hljs-function"><span class="hljs-params">()</span> =></span> { <span class="hljs-keyword">throw</span> reason })
      );
    }
  }
<span class="copy-code-btn">&#x590D;&#x5236;&#x4EE3;&#x7801;</span>
```

如果觉得还行的话，点个赞、收藏一下再走吧。
