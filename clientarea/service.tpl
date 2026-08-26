<link href="/themes/clientarea/codex_framework/assets_custom/service.css?v={$Ver}-1.0.2" rel="stylesheet" type="text/css">

<section class="cf-service-page" aria-labelledby="cf-service-overview-title">
  <header class="cf-service-overview">
    <div class="cf-service-overview-copy">
      <span class="cf-service-eyebrow"><i aria-hidden="true"></i> {$Lang.product}</span>
      <h2 id="cf-service-overview-title">{$Title}</h2>
      <p>{$Lang.state} · IP · {$Lang.due_date} · {$Lang.cost} · {$Lang.system}</p>
    </div>
    <div class="cf-service-overview-meta" aria-label="{$Lang.product}">
      <span>{$Lang.product}</span>
      <strong>{$Total}</strong>
      <small>{$Lang.strips}</small>
    </div>
    <div class="cf-service-signal" aria-hidden="true">
      <span></span><span></span><span></span><span></span>
    </div>
  </header>

  <div class="cf-service-shell">
    {include file="themes/clientarea/default/service.tpl"}
  </div>
</section>

<script>
  $(function () {
    var serviceSearchLabel = {:json_encode($Lang.search_by_keyword)};
    var serviceProductLabel = {:json_encode($Lang.product)};
    var serviceRemarksLabel = {:json_encode($Lang.remarks)};
    $('#searchInp').attr('aria-label', serviceSearchLabel);
    $('#searchIcon').attr({
      'role': 'button',
      'tabindex': '0',
      'aria-label': serviceSearchLabel
    });
    $('#customCheck').attr('aria-label', serviceProductLabel);
    $('.row-checkbox').each(function () {
      var productName = $(this).closest('tr').find('td:nth-child(3) strong').text().trim();
      $(this).attr('aria-label', productName || serviceProductLabel);
    });
    $('.bx-edit-alt[onclick^="editNotesHandleClick"]').attr({
      'role': 'button',
      'tabindex': '0',
      'aria-label': serviceRemarksLabel
    });
    $('#searchIcon, .bx-edit-alt[onclick^="editNotesHandleClick"]').on('keydown', function (event) {
      if (event.key === 'Enter' || event.key === ' ') {
        event.preventDefault();
        $(this).trigger('click');
      }
    });
  });
</script>
