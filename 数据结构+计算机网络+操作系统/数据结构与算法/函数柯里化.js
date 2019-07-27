function curry(fn, args) {
    var length = fn.length;  //3
    args = args || [];

    return function() {
        args.push(...arguments)
        if (args.length < length) {
            return curry(fn, args);
        } else {
            return fn(...args);
        }
    };
}
function add(a, b, c) {
    return a+b+c
}
console.log(curry(add)(2,4)(4))
