// ==UserScript==
// @name         爱情守望者追加code
// @namespace    https://github.com/zcr268/resource/tree/master/tampermonkey/
// @version      0.2
// @description  try to take over the world!
// @author       You
// @include      *://www.waitsun.com*
// @grant        爱情守望者
// ==/UserScript==

(function() {
    'use strict';
    if (/^https:\/\/www.waitsun.com\//.test(location.href) && document.getElementsByClassName("down")[1]){
        console.log("www.waitsun.com 运行");
        document.getElementsByClassName("down")[1].href=document.getElementsByClassName("down")[1].href+"#"+document.getElementsByClassName("down")[1].title.substring(document.getElementsByClassName("down")[1].title.length-4);
    }
    // Your code here...
})();
