
    $.ajax({
        url: 'http://localhost:3333/info',
        type: 'get', 
        success: function (data) {
            console.log("get结果", data);         
        },
        error: function (error) {
            console.log('Error: ' + error);
        }
    });

