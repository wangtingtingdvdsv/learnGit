/*
Mock.mock('http://data.com', function (params) {
	if (params.account === '123456789') {
		if (params.password === '111111') {
			return { code: 200, message: 'success' };
		} else {
			return { code: 401, message: '密码错误' };
		}
	} else {
		return { code: 400, message: '用户名错误' };
	}
});*/
Mock.mock('https://data.com', {
	code:200
})