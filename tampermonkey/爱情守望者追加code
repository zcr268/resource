// ==UserScript==
// @name         爱情守望者追加code
// @namespace    http://tampermonkey.net/
// @version      0.1
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
