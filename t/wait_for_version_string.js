
function waitFor(testFx, onReady, onTimeout, timeOutMillis) {
    var maxtimeOutMillis = timeOutMillis ? timeOutMillis : 60000, //< Default Max Timout is 30s
        start = new Date().getTime(),
        condition = false,
        interval = setInterval(function() {
            if ( (new Date().getTime() - start < maxtimeOutMillis) && !condition ) {
                // If not time-out yet and condition not yet fulfilled
                condition = (typeof(testFx) === "string" ? eval(testFx) : testFx()); //< defensive code
            } else {
                if(!condition) {
                    // If condition still not fulfilled (timeout but condition is 'false')
                    console.log("'waitFor()' timeout");
                    onTimeout();
                } else {
                    // Condition fulfilled (timeout and/or condition is 'true')
//                    console.log("'waitFor()' finished in " + (new Date().getTime() - start) + "ms.");
                    typeof(onReady) === "string" ? eval(onReady) : onReady(); //< Do what it's supposed to do once the condition is fulfilled
                    clearInterval(interval); //< Stop this interval
                }
            }
        }, 250); //< repeat check every 250ms
};


var system = require('system');
if (system.args.length === 1) {
    console.log('This script requires the hostname:port of the Zonemaster server as parameter');
	phantom.exit(1);
}
else {
	var page = require('webpage').create();
	var url = 'http://'+system.args[1]+'/';

	page.onError = function (msg, trace) {
		console.log(msg);
		trace.forEach(function(item) {
			console.log('  ', item.file, ':', item.line);
		});
	};
	
	page.onConsoleMessage = function(msg) {
		system.stdout.writeLine('page.evaluate console: ' + msg);
	};

	page.open(url, function (status) {
		// Check for page load success
		if (status !== "success") {
			console.log("Unable to access network");
		} else {
			console.log("page ["+url+"] loaded");
			console.log('Stripped down page text:\n' + page.plainText);
			
			// Wait for FAQ to appear
			waitFor(function() {
				return page.evaluate(function() {
					var getElementByXpath = function (path) {
						return document.evaluate(path, document, null, 9, null).singleNodeValue;
					};
					
					return (getElementByXpath("//a[contains(., 'FAQ')]") ? true : false);
				});
			}, function() { //onReady
				console.log("Webpage loaded");
			}, function() { //onTimeout
				console.log("waitFor 1:TIMEOUT");
			});

			//click the FAQ link
			page.evaluate(function() {
				console.log('page.evaluate:start');
				var getElementByXpath = function (path) {
					return document.evaluate(path, document, null, 9, null).singleNodeValue;
				};
								

				var clickNode = function click(el){
					var ev = document.createEvent("MouseEvent");
					ev.initMouseEvent(
						"click",
						true /* bubble */, true /* cancelable */,
						window, null,
						0, 0, 0, 0, /* coordinates */
						false, false, false, false, /* modifier keys */
						0 /*left*/, null
					);
					el.dispatchEvent(ev);
				};

				var element = getElementByXpath("//a[contains(., 'FAQ')]");
				console.log("getElementByXpath:done");
				clickNode(element);
				console.log('Clicked on FAQ');
			});

			waitFor(function() {
console.log('\n------------------------------------\nStripped down page text:\n' + page.plainText);
				return page.evaluate(function() {
					var getElementByXpath = function (path) {
						return document.evaluate(path, document, null, 9, null).singleNodeValue;
					};
					
					return (getElementByXpath("//div[@version and contains(., 'TRAVIS')]") ? true : false);
//					return (getElementByXpath("//body") ? true : false);
				});
			}, function() { //onReady

				var result = page.evaluate(function() {
					return "RESULT:OK";
				});

				console.log(result);
				
				phantom.exit(0);
			}, function() { //onTimeout
				console.log("TIMEOUT");
			});
			
		}
	});
}

