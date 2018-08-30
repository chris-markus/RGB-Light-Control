
var intensity = 0;
var lastIntensity = 255;
var intensityBool = false;
var connection = new WebSocket('ws://'+location.hostname+':81/', ['arduino']);
connection.onopen = function () {
    connection.send('Connect ' + new Date());
};
connection.onerror = function (error) {
    console.log('WebSocket Error ', error);
};
connection.onmessage = function (e) {  
    console.log('Server: ', e.data);
};
connection.onclose = function(){
    console.log('WebSocket connection closed');
};

function sendRGB(intTap) {
	intensity = (document.getElementById('i').value);
	if(!intTap && intensity>0 && !intensityBool){
		toggleInt();
	}
	else if(!intTap && intensity == 0 && intensityBool){
		lastIntensity = 255;
		toggleInt();
	}
    var r = (document.getElementById('r').value**2/255)*(intensity/255);
    var g = (document.getElementById('g').value**2/255)*(intensity/255);
    var b = (document.getElementById('b').value**2/255)*(intensity/255);
    
    var rgb = r << 20 | g << 10 | b;
    var rgbstr = '#'+ rgb.toString(16);    
    console.log('RGB: ' + rgbstr); 
    connection.send(rgbstr);
}

function toggleInt(){
    intensityBool = ! intensityBool;
    if(intensityBool){
			intensity = lastIntensity;
			document.getElementById('i').value = lastIntensity;
        document.getElementById('intButton').style.backgroundColor = '#00878F';
			sendRGB(true);
        
    } else {
			lastIntensity = intensity;
			intensity = 0;
			document.getElementById('i').value = 0;
        document.getElementById('intButton').style.backgroundColor = '#999';
        sendRGB(true);
    }  
}
