// ==UserScript==
// @name         苹果软件园追加code
// @namespace    https://github.com/zcr268/resource/tree/master/tampermonkey/
// @version      0.4
// @description  try to take over the world!
// @author       LIONST
// @include      *://www.maczapp.com/*
// @run-at       document-end
// @grant        LIONST
// ==/UserScript==

(function() {
    'use strict';
    $('dl.file_list tr').each(function() {
        if ($(this).find('span.rounded.staus_green')[0] && $(this).find('span.rounded.staus_green')[0].innerHTML.indexOf("访问密码:") != -1) {
            var code = $(this).find('span.rounded.staus_green')[0].innerHTML.split(":")[1];
            $(this).find('a').each(function() {
                this.href = this.href + "#" + code;
            });
        }
    });
    // Your code here...
})();
