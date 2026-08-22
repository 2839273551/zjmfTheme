  {if $TplName != 'login' && $TplName != 'register' && $TplName != 'pwreset' && $TplName != 'bind' && $TplName != 'loginaccesstoken'}
      </div>
    </div>
  </div>

  <footer class="footer cf-app-footer">
    <div class="container-fluid">
      <span>&copy; {:date('Y')} {$Setting.company_name}</span>
      <nav aria-label="页脚入口">
        <a href="{$Setting.system_url}/cart">产品中心</a>
        <a href="{$Setting.system_url}/knowledgebase">帮助文档</a>
        <a href="{$Setting.system_url}/supporttickets">服务支持</a>
      </nav>
    </div>
  </footer>
  {/if}

  <script src="/themes/clientarea/default/assets/js/app.js?v={$Ver}"></script>
  <script src="/themes/clientarea/codex_framework/assets_custom/js/clientarea.js?v={$Ver}-1.0.1"></script>
  {php}$hooks=hook('client_area_footer_output');{/php}
  {if $hooks}
    {foreach $hooks as $item}{$item}{/foreach}
  {/if}
</body>
</html>
