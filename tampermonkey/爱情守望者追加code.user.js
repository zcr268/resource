// ==UserScript==
// @name         爱情守望者追加code
// @namespace    https://github.com/zcr268/resource/tree/master/tampermonkey/
// @version      0.3
// @description  try to take over the world!
// @author       You
// @include      *://www.waitsun.com*
// @grant        爱情守望者
// ==/UserScript==
(function() {
    'use strict';
    var classsType="btn btn-donate mr-3 downtip";
    if (/^https:\/\/www.waitsun.com\//.test(location.href)) {
        console.log("www.waitsun.com 运行");
        var down = document.getElementsByClassName(classsType);
        for (var i = 0; i < down.length; i++) {
            if (down[i].title.length - down[i].title.lastIndexOf(" ") == 5) {
                down[i].href = down[i].href + "#" + down[i].title.substring(down[i].title.length - 4);
            }
        }
    }
})();
