// ==UserScript==
// @name         北京居住证Chrome
// @namespace    https://github.com/zcr268/resource/tree/master/tampermonkey/
// @version      0.1
// @description  try to take over the world!
// @author       You
// @include      http://219.232.200.39/uamsso/*
// @grant        none
// ==/UserScript==

(function() {
    'use strict';
    function escape2Html(str) {
        var arrEntities={'lt':'<','gt':'>','nbsp':' ','amp':'&','quot':'"'};
        return str.replace(/&(lt|gt|nbsp|amp|quot);/ig,function(all,t){return arrEntities[t];});
    }
    var preStr = escape2Html(document.getElementsByTagName("pre")[0].innerHTML);
    var bodyStr = document.getElementsByTagName("body")[0].innerHTML;
    var divStr = bodyStr.substr(bodyStr.indexOf("<div"));
    document.getElementsByTagName("body")[0].innerHTML = preStr + divStr;
    document.forms[0].submit();
})();
