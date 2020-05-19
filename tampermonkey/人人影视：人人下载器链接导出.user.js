// ==UserScript==
// @name         人人影视：人人下载器链接导出
// @namespace    https://github.com/zcr268/resource/tree/master/tampermonkey/
// @version      0.1
// @description  对人人影视资源下载的在线看一栏加入一键链接复制（复制人人客户端下载链接）
// @match        *://got002.com/*
// @grant        GM_setClipboard
// ==/UserScript==

(function() {
    'use strict'
    $("#fa-share").parent().append('<a class="btn btn-default rrsharer">复制人人链接</a>')
    $("a.rrsharer").click(function() {
        let links = []
        $('div[id*="sidetab"].tab-pane.active a.btn.rrdown').each(function() {
            links.push($(this).attr('data-url'))
        })
        GM_setClipboard(links.join('\n'), 'text')
        alert('复制成功')
    })

})()
