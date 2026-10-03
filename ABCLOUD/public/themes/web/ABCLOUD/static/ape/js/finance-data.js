(function () {
    'use strict';
    var requests = {};
    function json(path) {
        if (!requests[path]) {
            var controller = new AbortController();
            var timer = setTimeout(function () { controller.abort(); }, 15000);
            requests[path] = fetch(path, { credentials: 'same-origin', signal: controller.signal })
                .then(function (response) {
                    if (!response.ok) throw new Error('HTTP ' + response.status);
                    return response.json();
                }).then(function (body) {
                    if (Number(body.status) !== 200 || !body.data) throw new Error('Invalid financial system response');
                    return body.data;
                }).catch(function (error) {
                    delete requests[path];
                    throw error;
                }).finally(function () { clearTimeout(timer); });
        }
        return requests[path];
    }
    function text(html) {
        var doc = new DOMParser().parseFromString(String(html || ''), 'text/html');
        doc.querySelectorAll('br').forEach(function (br) { br.replaceWith('\n'); });
        doc.querySelectorAll('script,style').forEach(function (node) { node.remove(); });
        return doc.body.textContent.trim();
    }
    function esc(value) {
        return String(value == null ? '' : value).replace(/[&<>"']/g, function (c) {
            return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c];
        });
    }
    function id(value) { return /^\d+$/.test(String(value)) ? String(value) : ''; }
    function products(group, limit) {
        var list = [], seen = {};
        (group.group || []).forEach(function (second) {
            (second.products || []).forEach(function (product) {
                if (id(product.id) && !seen[product.id]) {
                    seen[product.id] = true;
                    list.push(product);
                }
            });
        });
        return list.slice(0, limit || list.length);
    }
    function groupUrl(group) {
        var second = (group.group || [])[0];
        return '/cart?fid=' + id(group.id) + (second ? '&gid=' + id(second.id) : '');
    }
    function secondGroupUrl(group, second) {
        var fid = typeof group === 'object' && group ? id(group.id) : id(group);
        var gid = typeof second === 'object' && second ? id(second.id) : id(second);
        return '/cart?fid=' + fid + (gid ? '&gid=' + gid : '');
    }
    window.apeFinance = {
        json: json, text: text, esc: esc, id: id, products: products, groupUrl: groupUrl, secondGroupUrl: secondGroupUrl,
        productUrl: function (product) { return '/cart?action=configureproduct&pid=' + id(product.id); },
        soldOut: function (product) { return Number(product.stock_control) === 1 && Number(product.qty) < 1; },
        catalog: function () {
            return json('/cart/prolist').then(function (data) {
                if (!Array.isArray(data.fgs)) throw new Error('Missing financial product groups');
                return data.fgs.filter(function (group) { return id(group.id); });
            });
        },
        updates: function (type) {
            // Financial 3.7.6: news category root 1, announcement category root 2.
            var path = '/news/list?parent_id=' + (type === 'announce' ? '2' : '1') + '&page=1&limit=6';
            return json(path).then(function (data) {
                if (!Array.isArray(data.list)) throw new Error('Missing financial news list');
                return data.list.filter(function (item) { return id(item.id) && String(item.hidden || '0') === '0'; });
            });
        }
    };
})();
