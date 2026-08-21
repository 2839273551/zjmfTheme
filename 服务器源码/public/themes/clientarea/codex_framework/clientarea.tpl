<div class="cf-dashboard">
  <header class="cf-workspace-heading">
    <div>
      <span>控制台总览</span>
      <h1>你好，{$Userinfo.user.username}</h1>
      <p>客户 ID {$Userinfo.user.id} · {$Userinfo.client_group.group_name|default='默认分组'}</p>
    </div>
    <div class="cf-workspace-actions">
      <a class="btn cf-button cf-button-primary" href="{$Setting.system_url}/cart"><i class="bx bx-plus"></i>订购产品</a>
      <a class="btn cf-button" href="{$Setting.system_url}/supporttickets"><i class="bx bx-support"></i>提交工单</a>
    </div>
  </header>

  <div class="cf-dashboard-layout">
    <main class="cf-dashboard-main">
      <section class="cf-panel cf-quick-panel" aria-labelledby="quick-title">
        <header class="cf-panel-heading"><div><span>常用操作</span><h2 id="quick-title">快捷导航</h2></div></header>
        <nav class="cf-quick-grid" aria-label="快捷导航">
          <a href="{$Setting.system_url}/cart"><i class="bx bx-cart-alt"></i><span><strong>订购产品</strong></span><i class="bx bx-chevron-right"></i></a>
          <a href="{$Setting.system_url}/service"><i class="bx bx-server"></i><span><strong>管理服务</strong></span><i class="bx bx-chevron-right"></i></a>
          <a href="{$Setting.system_url}/billing"><i class="bx bx-receipt"></i><span><strong>账单中心</strong></span><i class="bx bx-chevron-right"></i></a>
          <a href="{$Setting.system_url}/supporttickets"><i class="bx bx-message-square-dots"></i><span><strong>技术支持</strong></span><i class="bx bx-chevron-right"></i></a>
        </nav>
      </section>

      <section class="cf-metric-grid" aria-label="业务状态">
        <a class="cf-metric" href="{$Setting.system_url}/supporttickets"><span class="is-blue"><i class="bx bx-headphone"></i></span><div><small>待处理工单</small><strong>{$ClientArea.index.ticket_count}</strong><em>查看工单</em></div></a>
        <a class="cf-metric" href="{$Setting.system_url}/billing"><span class="is-amber"><i class="bx bx-file"></i></span><div><small>待付订单</small><strong>{$ClientArea.index.order_count}</strong><em>查看账单</em></div></a>
        <a class="cf-metric" href="{$Setting.system_url}/service"><span class="is-green"><i class="bx bx-server"></i></span><div><small>正在运行</small><strong>{$ClientArea.index.host}</strong><em>管理实例</em></div></a>
        <a class="cf-metric" href="{$Setting.system_url}/billing?status=Unpaid"><span class="is-red"><i class="bx bx-wallet"></i></span><div><small>未支付金额</small><strong>{$ClientArea.index.invoice_unpaid}</strong><em>费用明细</em></div></a>
      </section>

      <section class="cf-panel cf-services-panel" aria-labelledby="services-title">
        <header class="cf-panel-heading">
          <div><span>云资源</span><h2 id="services-title">已开通产品</h2></div>
          <a href="{$Setting.system_url}/service">全部服务<i class="bx bx-chevron-right"></i></a>
        </header>
        {if $ClientArea.index.host_nav}
        <div class="cf-service-group-grid">
          {foreach $ClientArea.index.host_nav as $list}
          <a href="{$Setting.system_url}/service?groupid={$list.id}"><span><i class="bx bx-cloud"></i><strong>{$list.groupname}</strong></span><em>{$list.count}</em></a>
          {/foreach}
        </div>
        {else/}
        <div class="cf-empty-state"><i class="bx bx-package"></i><strong>暂无已开通产品</strong><p>订购后可在这里快速进入服务管理。</p><a class="btn cf-button cf-button-primary" href="{$Setting.system_url}/cart">立即购买</a></div>
        {/if}
      </section>

      <section class="cf-panel cf-resource-panel" aria-labelledby="resources-title">
        <header class="cf-panel-heading">
          <div><span>实例明细</span><h2 id="resources-title">资源列表</h2></div>
          <button class="cf-icon-command" type="button" data-source-retry aria-label="刷新资源列表" title="刷新资源列表"><i class="bx bx-reset"></i></button>
        </header>
        <div id="sourceListBox" class="cf-resource-list" aria-live="polite" data-loading="{$Lang.data_loading|default='数据加载中'}" data-error="资源列表加载失败，请稍后重试">
          <div class="cf-loading-state"><span></span>正在加载资源...</div>
        </div>
      </section>
    </main>

    <aside class="cf-dashboard-aside">
      <section class="cf-panel cf-account-card" aria-labelledby="account-title">
        <header class="cf-account-summary">
          <span class="cf-profile-avatar"><i class="bx bx-user" aria-hidden="true"></i></span>
          <div><h2 id="account-title">{$Userinfo.user.username}</h2><p>ID {$Userinfo.user.id} · {$Userinfo.client_group.group_name|default='默认分组'}</p></div>
          <a href="{$Setting.system_url}/details" aria-label="进入账户资料"><i class="bx bx-chevron-right"></i></a>
        </header>
        <div class="cf-account-status">
          <a href="{$Setting.system_url}/verified" class="{if $Userinfo.user.certifi.status==1}is-ready{/if}"><i class="bx bx-id-card"></i><span>{if $Userinfo.user.certifi.status==1}已认证{else/}未认证{/if}</span></a>
          <a href="{$Setting.system_url}/security" class="{if $Userinfo.user.phonenumber}is-ready{/if}"><i class="bx bx-mobile-alt"></i><span>{if $Userinfo.user.phonenumber}已绑定{else/}未绑定{/if}</span></a>
          <a href="{$Setting.system_url}/security" class="{if $Userinfo.user.email}is-ready{/if}"><i class="bx bx-envelope"></i><span>{if $Userinfo.user.email}已绑定{else/}未绑定{/if}</span></a>
        </div>
        <dl class="cf-account-details">
          <div><dt>客户组</dt><dd>{$Userinfo.client_group.group_name|default='默认分组'}</dd></div>
          <div><dt>邮箱</dt><dd>{$Userinfo.user.email|default='未绑定'}</dd></div>
          <div><dt>手机</dt><dd>{$Userinfo.user.phonenumber|default='未绑定'}</dd></div>
        </dl>
      </section>

      <section class="cf-panel cf-finance-card" aria-labelledby="finance-title">
        <header class="cf-panel-heading"><div><span>账户资金</span><h2 id="finance-title">费用信息</h2></div><a href="{$Setting.system_url}/billing">账单列表<i class="bx bx-chevron-right"></i></a></header>
        <div class="cf-balance-row"><div><small>账户余额</small><strong>{$Userinfo.user.credit}<em>元</em></strong></div>{if $ClientArea.index.allow_recharge=='1'}<a class="btn cf-button cf-button-primary" href="{$Setting.system_url}/addfunds">充值</a>{/if}</div>
        <div class="cf-finance-grid"><a href="{$Setting.system_url}/billing?status=Unpaid"><span>未支付金额</span><strong>{$ClientArea.index.invoice_unpaid}</strong></a><a href="{$Setting.system_url}/billing"><span>本月消费</span><strong>{$ClientArea.index.intotal}</strong></a></div>
      </section>

      <section class="cf-panel cf-news-panel" aria-labelledby="news-title">
        <header class="cf-panel-heading"><div><span>平台动态</span><h2 id="news-title">公告通知</h2></div><a href="{$Setting.system_url}/news">查看更多<i class="bx bx-chevron-right"></i></a></header>
        {if $ClientArea.index.news}
        <ol class="cf-news-list">
          {foreach $ClientArea.index.news as $list}
          <li><time>{$list.push_time|date='Y-m-d'}</time><a href="{$Setting.system_url}/newsview?id={$list.id}">{$list.title}</a></li>
          {/foreach}
        </ol>
        {else/}
        <div class="cf-mini-empty">暂无公告</div>
        {/if}
      </section>

      <section class="cf-support-strip">
        <i class="bx bx-support"></i><div><strong>技术支持</strong></div><a href="{$Setting.system_url}/supporttickets">提交工单</a>
      </section>
    </aside>
  </div>
</div>

<script src="/themes/clientarea/codex_framework/assets_custom/js/dashboard.js?v=1.0.0"></script>
