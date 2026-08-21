(function (window, document, $) {
    'use strict';

    var plugin = {
        config: null,
        gates: [],
        securityGate: null,
        booted: false
    };

    var pagePolicies = {
        login: {
            formSelector: 'form[action*="/login"]'
        },
        register: {
            formSelector: 'form[action*="/register"]'
        },
        password_reset: {
            formSelector: 'form[action*="/pwreset"]'
        },
        password_change: {
            formSelector: '#modifyPwdForm',
            triggerSelector: '#modifyPwdSubmit',
            ajaxPath: '/modify_password'
        }
    };

    function notify(message) {
        if (window.toastr && typeof window.toastr.error === 'function') {
            window.toastr.error(message);
            return;
        }
        window.alert(message);
    }

    function closestForm(element) {
        while (element && element !== document) {
            if (element.tagName && element.tagName.toLowerCase() === 'form') {
                return element;
            }
            element = element.parentNode;
        }
        return null;
    }

    function hasTarget(element, selector) {
        while (element && element !== document) {
            if (element.matches && element.matches(selector)) {
                return element;
            }
            element = element.parentNode;
        }
        return null;
    }

    function setHiddenField(form, name, value) {
        var field = form.querySelector('input[data-geetest-field="' + name + '"]');
        if (!field) {
            field = document.createElement('input');
            field.type = 'hidden';
            field.name = name;
            field.setAttribute('data-geetest-field', name);
            form.appendChild(field);
        }
        field.value = value || '';
    }

    function tokenParams(token) {
        return {
            lot_number: token.lot_number || '',
            captcha_output: token.captcha_output || '',
            pass_token: token.pass_token || '',
            gen_time: token.gen_time || ''
        };
    }

    function Gate(form, index) {
        this.form = form;
        this.index = index;
        this.instance = null;
        this.ready = false;
        this.token = null;
        this.pending = null;
        this.allowSubmit = false;
        this.slot = null;
        this.status = null;
        this.captchaBox = null;
    }

    Gate.prototype.render = function () {
        var slot = document.createElement('div');
        slot.className = 'form-group geetest-captcha-slot';
        slot.setAttribute('data-geetest-gate', String(this.index));
        slot.innerHTML = '<label>安全验证</label>'
            + '<div class="geetest-captcha-surface">'
            + '<div class="geetest-captcha-status" role="status" aria-live="polite">正在加载安全验证...</div>'
            + '<div class="geetest-captcha-box"></div>'
            + '</div>';

        var submit = this.form.querySelector('button[type="submit"], input[type="submit"]');
        if (submit) {
            this.form.insertBefore(slot, submit);
        } else {
            this.form.appendChild(slot);
        }

        this.slot = slot;
        this.status = slot.querySelector('.geetest-captcha-status');
        this.captchaBox = slot.querySelector('.geetest-captcha-box');
    };

    Gate.prototype.setStatus = function (message, state) {
        if (!this.status) {
            return;
        }
        this.status.className = 'geetest-captcha-status is-' + state;
        this.status.textContent = message;
    };

    Gate.prototype.init = function () {
        var gate = this;
        gate.render();

        if (!plugin.config.configured) {
            gate.setStatus('安全验证尚未配置', 'error');
            return;
        }
        if (typeof window.initGeetest4 !== 'function') {
            gate.setStatus('安全验证加载失败', 'error');
            return;
        }

        var options = {
            captchaId: plugin.config.captchaId,
            product: plugin.config.product,
            language: plugin.config.language || 'zho',
            timeout: plugin.config.timeout || 10000,
            protocol: 'https://'
        };
        if (plugin.config.riskType) {
            options.riskType = plugin.config.riskType;
        }

        window.initGeetest4(options, function (captcha) {
            gate.instance = captcha;
            if (plugin.config.product !== 'bind') {
                captcha.appendTo(gate.captchaBox);
            }
            captcha
                .onReady(function () {
                    gate.ready = true;
                    gate.setStatus(
                        plugin.config.product === 'bind' ? '安全验证已就绪' : '安全验证待完成',
                        'ready'
                    );
                })
                .onSuccess(function () {
                    var result = captcha.getValidate();
                    if (!result) {
                        gate.setStatus('未取得验证结果', 'error');
                        return;
                    }
                    gate.token = tokenParams(result);
                    gate.setStatus('安全验证已通过', 'success');
                    if (gate.pending) {
                        var callback = gate.pending;
                        gate.pending = null;
                        callback();
                    }
                })
                .onFail(function () {
                    gate.token = null;
                    gate.setStatus('安全验证未通过', 'error');
                })
                .onError(function () {
                    gate.token = null;
                    gate.setStatus('安全验证加载异常', 'error');
                })
                .onClose(function () {
                    if (!gate.token) {
                        gate.setStatus('安全验证待完成', 'ready');
                    }
                });
        });
    };

    Gate.prototype.attachToken = function () {
        if (!this.token) {
            return;
        }
        var params = tokenParams(this.token);
        for (var name in params) {
            if (Object.prototype.hasOwnProperty.call(params, name)) {
                setHiddenField(this.form, name, params[name]);
            }
        }
    };

    Gate.prototype.ensure = function (callback) {
        if (!plugin.config.configured) {
            notify('极验验证码尚未完成配置，请联系管理员。');
            return;
        }
        if (this.token) {
            callback();
            return;
        }
        if (!this.instance || !this.ready) {
            notify('安全验证正在加载，请稍后重试。');
            return;
        }

        this.pending = callback;
        if (plugin.config.product === 'bind') {
            this.instance.showCaptcha();
            return;
        }

        this.slot.scrollIntoView({ behavior: 'smooth', block: 'center' });
        notify('请先完成安全验证。');
    };

    Gate.prototype.reset = function () {
        this.token = null;
        this.pending = null;
        if (this.instance && typeof this.instance.reset === 'function') {
            this.instance.reset();
        }
        this.setStatus('安全验证待完成', 'ready');
    };

    function gateForForm(form) {
        for (var i = 0; i < plugin.gates.length; i++) {
            if (plugin.gates[i].form === form) {
                return plugin.gates[i];
            }
        }
        return null;
    }

    function submitForm(form, gate) {
        gate.attachToken();
        gate.allowSubmit = true;
        if (typeof form.requestSubmit === 'function') {
            form.requestSubmit();
        } else {
            window.HTMLFormElement.prototype.submit.call(form);
        }
    }

    function installFormGuard() {
        document.addEventListener('submit', function (event) {
            var form = closestForm(event.target);
            var gate = gateForForm(form);
            if (!gate) {
                return;
            }
            if (gate.allowSubmit) {
                gate.allowSubmit = false;
                gate.attachToken();
                return;
            }
            if (event.defaultPrevented) {
                return;
            }

            event.preventDefault();
            gate.ensure(function () {
                submitForm(form, gate);
            });
        }, false);
    }

    function installPasswordChangeGuard(policy) {
        if (!policy.triggerSelector || !plugin.securityGate) {
            return;
        }

        document.addEventListener('click', function (event) {
            var trigger = hasTarget(event.target, policy.triggerSelector);
            if (!trigger) {
                return;
            }

            event.preventDefault();
            event.stopImmediatePropagation();
            plugin.securityGate.ensure(function () {
                plugin.securityGate.attachToken();
                if (typeof window.modifyPwdCheckForm === 'function') {
                    window.modifyPwdCheckForm();
                }
            });
        }, true);

        if (!$ || typeof $.ajaxPrefilter !== 'function') {
            return;
        }

        $.ajaxPrefilter(function (options) {
            var url = String(options.url || '');
            var method = String(options.type || options.method || 'GET').toUpperCase();
            if (method !== 'POST' || url.indexOf(policy.ajaxPath) === -1 || !plugin.securityGate.token) {
                return;
            }

            var encoded = $.param(tokenParams(plugin.securityGate.token));
            if (options.data && typeof options.data === 'object') {
                options.data = $.extend({}, options.data, tokenParams(plugin.securityGate.token));
            } else {
                options.data = options.data ? options.data + '&' + encoded : encoded;
            }
        });

        $(document).ajaxComplete(function (event, xhr, options) {
            if (String(options.url || '').indexOf(policy.ajaxPath) !== -1 && plugin.securityGate) {
                plugin.securityGate.reset();
            }
        });
    }

    function addStyles() {
        var style = document.createElement('style');
        style.textContent = '.geetest-captcha-slot{margin-top:16px;margin-bottom:16px}'
            + '.geetest-captcha-surface{min-height:44px}'
            + '.geetest-captcha-status{display:flex;align-items:center;min-height:42px;padding:10px 12px;border:1px solid #d6dce5;border-radius:4px;background:#f8fafc;color:#566176;font-size:14px}'
            + '.geetest-captcha-status.is-success{border-color:#8fd5ad;background:#f0fbf5;color:#1f7a46}'
            + '.geetest-captcha-status.is-error{border-color:#efb2b2;background:#fff5f5;color:#b42318}'
            + '.geetest-captcha-box:not(:empty){margin-top:8px}'
            + '.geetest-captcha-box>div{max-width:100%}';
        document.head.appendChild(style);
    }

    plugin.boot = function (config) {
        if (plugin.booted) {
            return;
        }
        plugin.booted = true;
        plugin.config = config || {};

        var policy = pagePolicies[plugin.config.page];
        if (!policy) {
            return;
        }

        addStyles();
        var forms = document.querySelectorAll(policy.formSelector);
        for (var i = 0; i < forms.length; i++) {
            var gate = new Gate(forms[i], i);
            plugin.gates.push(gate);
            gate.init();
        }

        if (plugin.config.page === 'password_change') {
            plugin.securityGate = plugin.gates.length ? plugin.gates[0] : null;
            installPasswordChangeGuard(policy);
        } else {
            installFormGuard();
        }
    };

    window.GeetestCaptchaPlugin = plugin;
})(window, document, window.jQuery);
