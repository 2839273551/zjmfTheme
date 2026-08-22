<div class="cf-resource-table table-responsive">
  <table class="table mb-0">
    <colgroup><col width="19%"><col width="31%"><col width="20%"><col width="18%"><col width="12%"></colgroup>
    <thead>
      <tr>
        <th>{$Lang.machine_status}</th>
        <th>{$Lang.host_name}</th>
        <th class="pointer" data-source-order="nextduedate">{$Lang.due_date}<span class="cf-sort-icons"><i class="bx bx-caret-up"></i><i class="bx bx-caret-down"></i></span></th>
        <th>{$Lang.cost}</th>
        <th>IP</th>
      </tr>
    </thead>
    <tbody>
      {if $ClientArea.hostlist}
      {foreach $ClientArea.hostlist as $list}
      <tr>
        <td>
          <span class="cf-status-dot {if $list.domainstatus=='Active' || $list.domainstatus=='Completed'}is-success{elseif $list.domainstatus=='Pending' || $list.domainstatus=='Suspended'}is-warning{elseif $list.domainstatus=='Terminated' || $list.domainstatus=='Cancelled' || $list.domainstatus=='Fraud'}is-danger{else/}is-muted{/if}"></span>{$list.domainstatus_desc}
        </td>
        <td><a href="{$Setting.system_url}/servicedetail?id={$list.id}">{$list.productname} ({$list.domain})</a></td>
        <td>{if $list.billingcycle!='free' && $list.cycle_desc!='一次性'}{$list.nextduedate|date='Y-m-d H:i'}{else/}-{/if}</td>
        <td>{if $list.billingcycle!='free'}{$list.price_desc}/{$list.cycle_desc}{else/}{$list.cycle_desc}{/if}</td>
        <td>{$list.dedicatedip}</td>
      </tr>
      {/foreach}
      {else/}
      <tr><td colspan="5"><div class="cf-table-empty"><i class="bx bx-server"></i><span>{$Lang.nothing_content}</span></div></td></tr>
      {/if}
    </tbody>
  </table>
</div>

<footer class="cf-resource-footer">
  <span>{$Lang.common} {$ClientArea.Total} {$Lang.strips}</span>
  <label>{$Lang.each_page}<select id="sourcelimitSel" aria-label="每页条数"><option value="5" {if $ClientArea.Limit==5}selected{/if}>5</option><option value="10" {if $ClientArea.Limit==10}selected{/if}>10</option><option value="15" {if $ClientArea.Limit==15}selected{/if}>15</option><option value="20" {if $ClientArea.Limit==20}selected{/if}>20</option><option value="50" {if $ClientArea.Limit==50}selected{/if}>50</option><option value="100" {if $ClientArea.Limit==100}selected{/if}>100</option></select>{$Lang.strips}</label>
  <ul class="pagination pagination-sm">{$ClientArea.Pages}</ul>
</footer>

<script>
  (function ($) {
    "use strict";

    function renderSourceError() {
      var message = $('#sourceListBox').data('error') || '资源列表加载失败，请稍后重试';
      var safeMessage = $('<div>').text(message).html();
      $('#sourceListBox').html('<div class="cf-error-state" role="alert"><span>' + safeMessage + '</span><button type="button" class="btn btn-sm btn-outline-primary" data-source-retry>重试</button></div>');
    }

    function loadSource(url, params) {
      var sourceList = $('#sourceListBox');
      sourceList.attr('aria-busy', 'true');
      $.get(url, params)
        .done(function (html) {
          sourceList.html(html);
        })
        .fail(renderSourceError)
        .always(function () {
          sourceList.attr('aria-busy', 'false');
        });
    }

    function sourceRequest(params) {
      loadSource(setting_web_url + '/clientarea', params);
    }

    function normalizePageUrl(rawUrl) {
      if (!rawUrl) return null;
      var pageUrl = new URL(rawUrl, window.location.href);
      if (pageUrl.origin !== window.location.origin) return null;
      pageUrl.searchParams.set('action', 'list');
      return pageUrl.href;
    }

    $('[data-source-order]').on('click', function () {
      var sort = localStorage.getItem('sourceSort') === 'asc' ? 'desc' : 'asc';
      localStorage.setItem('sourceSort', sort);
      sourceRequest({ action: 'list', sort: sort, orderby: $(this).data('source-order') });
    });

    $('#sourcelimitSel').on('change', function () {
      sourceRequest({ action: 'list', limit: $(this).val(), page: 1 });
    });

    $('#sourceListBox .page-link').on('click', function (event) {
      event.preventDefault();
      var pageUrl = normalizePageUrl($(this).attr('href'));
      if (pageUrl) loadSource(pageUrl);
    });
  })(window.jQuery);
</script>
