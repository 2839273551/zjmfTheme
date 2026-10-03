<style>
.ordersummary td { border:none!important; padding: 5px!important; }
</style>

<!-- 左侧：合计价格与说明 -->
<div class="nq-productconfig-footer-left">
	<div class="nq-productconfig-footer-price">
		<span class="nq-productconfig-footer-label">费用合计：</span>
		<span class="nq-productconfig-footer-amount">
			{$ConfigureTotal.currency.prefix}
			{if !$ConfigureTotal.type}
				{:bcadd($ConfigureTotal.signal_price, $ConfigureTotal.signal_setupfee)}
			{else/}
				{:bcadd($ConfigureTotal.sale_signal_price, $ConfigureTotal.sale_setupfee_total)}
			{/if}
			<small>/{$ConfigureTotal.billingcycle_zh|default='月'}</small>
		</span>
		{if $ConfigureTotal.type}
			<span class="nq-productconfig-footer-discount">
				{if $ConfigureTotal.type.type == '1'}
					[优惠折扣 <em>{$ConfigureTotal.type.bates}%</em>]
				{elseif $ConfigureTotal.type.type == '2'/}
					[立减 <em>{$ConfigureTotal.currency.prefix}{$ConfigureTotal.type.bates}</em>]
				{/if}
			</span>
		{else/}
			<span class="nq-productconfig-footer-discount nq-productconfig-footer-nodiscount">[无折扣]</span>
		{/if}
	</div>
	<div class="nq-productconfig-footer-note">注：以上是参考价格，具体扣费请以实际下单结果为准，具体资源及是否可订购以实际库存情况为准。</div>
</div>

<!-- 右侧：当前配置明细抽屉 + 购买按钮 -->
<div class="nq-productconfig-footer-right">
	<div class="nq-productconfig-footer-detail">
		<span class="nq-productconfig-footer-detail-trigger" id="detailTriggerBtn">
			<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="nq-productconfig-footer-detail-arrow" style="margin-right:4px;"><polyline points="18 15 12 9 6 15"></polyline></svg>
			当前配置[<span id="childItemCount">{:count($ConfigureTotal.child)}</span>项]
		</span>
		<div class="nq-productconfig-footer-breakdown" id="detailBreakdownPanel" style="display:none;">
			<div class="nq-productconfig-footer-breakdown-title">
				<span style="flex:1">费用明细：共{:count($ConfigureTotal.child)}项</span>
				<span class="nq-productconfig-footer-breakdown-total">
					总价：<em>{$ConfigureTotal.currency.prefix}{if !$ConfigureTotal.type}{:bcadd($ConfigureTotal.signal_price, $ConfigureTotal.signal_setupfee)}{else/}{:bcadd($ConfigureTotal.sale_signal_price, $ConfigureTotal.sale_setupfee_total)}{/if}</em>
				</span>
				<button type="button" class="nq-breakdown-close" id="closeBreakdownBtn">✕</button>
			</div>
			<div class="nq-productconfig-footer-breakdown-body">
				<table>
					<thead>
						<tr>
							<th>配置名称</th>
							<th>配置详情</th>
							<th>价格</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>产品基价</td>
							<td>{$ConfigureTotal.product_name}</td>
							<td>{$ConfigureTotal.currency.prefix}{$ConfigureTotal.product_price}</td>
						</tr>
						{foreach $ConfigureTotal.child as $configure}
						<tr>
							<td>{$configure.option_name}</td>
							<td>{if $configure.qty}{$configure.qty}{else/}{$configure.sub_name}{/if}</td>
							<td>{$ConfigureTotal.currency.prefix}{$configure.suboption_price}</td>
						</tr>
						{/foreach}
					</tbody>
				</table>
			</div>
		</div>
	</div>
	<button type="button" class="btn btn-primary" id="addToCartBtn">
		<span class="btn-text">
			<svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="margin-right:6px;vertical-align:-2px;"><circle cx="9" cy="21" r="1"></circle><circle cx="20" cy="21" r="1"></circle><path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"></path></svg>
			加入购物车
		</span>
		<span class="btn-loading"><span class="nq-spinner"></span> 正在提交...</span>
	</button>
</div>

<script>
$(function() {
	var detailTrigger = $('#detailTriggerBtn');
	var detailPanel = $('#detailBreakdownPanel');
	var closeBtn = $('#closeBreakdownBtn');

	if (detailTrigger.length && detailPanel.length) {
		detailTrigger.off('click').on('click', function(e) {
			e.stopPropagation();
			var isOpen = detailPanel.is(':visible');
			if (isOpen) {
				detailPanel.hide();
				detailTrigger.parent().removeClass('open');
			} else {
				detailPanel.show();
				detailTrigger.parent().addClass('open');
			}
		});

		closeBtn.off('click').on('click', function(e) {
			e.stopPropagation();
			detailPanel.hide();
			detailTrigger.parent().removeClass('open');
		});

		$(document).off('click.breakdown').on('click.breakdown', function(e) {
			if (!$(e.target).closest('.nq-productconfig-footer-detail').length) {
				detailPanel.hide();
				detailTrigger.parent().removeClass('open');
			}
		});
	}

	$('#addToCartBtn').off('click').on('click', function() {
		var btn = $(this);
		if (btn.hasClass('is-loading')) return false;

		var result = {flag: true};
		if (typeof passwordRules !== 'undefined' && passwordRules != null && typeof showPassword !== 'undefined' && showPassword == 1) {
			result = checkingPwd1($(".getPassword").val(), passwordRules.num, passwordRules.upper, passwordRules.lower, passwordRules.special);
		}
		if (result.flag) {
			btn.addClass('is-loading');
			$('#addCartForm').submit();
		} else {
			if (typeof toastr !== 'undefined') {
				toastr.error($('.is-invalid').parents('.form-group').find('.error-tip').html() || '密码不符合安全规则');
			}
		}
	});
});
</script>
