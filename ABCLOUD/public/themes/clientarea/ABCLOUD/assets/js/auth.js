(function (window, document) {
  'use strict';
  window.readAuthPassword = function (type) {
    var container = document.getElementById(type);
    var input = container && container.querySelector('[data-submit-name="password"], input[name="password"]:not([data-encrypted-for])');
    return input ? input.value : '';
  };
  window.encryptPass = function (inputId, outputId) {
    var input = document.getElementById(inputId);
    if (!input || !input.form) return false;
    var field = input.form.querySelector('[data-encrypted-for="' + inputId + '"]');
    var name = input.getAttribute('data-submit-name') || input.name;
    if (!field) {
      field = document.createElement('input');
      field.type = 'hidden';
      field.id = outputId || inputId + 'Encrypted';
      field.name = name;
      field.setAttribute('data-encrypted-for', inputId);
      input.form.appendChild(field);
      input.setAttribute('data-submit-name', name);
      input.removeAttribute('name');
    }
    field.disabled = input.disabled;
    if (input.disabled) {
      field.value = '';
      return true;
    }
    if (!window.CryptoJS || typeof window.encrypt !== 'function') {
      field.value = '';
      window.alert('密码安全组件未加载，请刷新后重试。');
      return false;
    }
    field.value = window.encrypt(input.value);
    return true;
  };
})(window, document);
