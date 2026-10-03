<style>
/* 强自包含样式：确保订单汇总无论在任何父容器、独立页面、AJAX注入下均保持完美横向双栏排版 */
.nq-ordersummary-bar,
.configoption_total {
	display: flex !important;
	flex-direction: row !important;
	align-items: center !important;
	justify-content: space-between !important;
	width: 100% !important;
	max-width: 100% !important;
	box-sizing: border-box !important;
	padding: 12px 24px !important;
	gap: 16px !important;
	background: #ffffff !important;
	position: relative !important;
}

.nq-productconfig-footer-left {
	display: flex !important;
	flex-direction: column !important;
	justify-content: center !important;
	flex: 1 1 auto !important;
	min-width: 280px !important;
	max-width: none !important;
	width: auto !important;
	box-sizing: border-box !important;
	text-align: left !important;
}

.nq-productconfig-footer-price {
	display: flex !important;
	flex-direction: row !important;
	align-items: baseline !important;
	gap: 8px !important;
	flex-wrap: wrap !important;
	white-space: nowrap !important;
}

.nq-productconfig-footer-label {
	font-size: 14px !important;
	font-weight: 500 !important;
	color: #64748b !important;
	display: inline-block !important;
	white-space: nowrap !important;
}

.nq-productconfig-footer-amount {
	font-size: 26px !important;
	font-weight: 800 !important;
	color: #ef4444 !important;
	line-height: 1 !important;
	display: inline-block !important;
	white-space: nowrap !important;
}

.nq-productconfig-footer-amount small {
	font-size: 13px !important;
	font-weight: 400 !important;
	color: #94a3b8 !important;
	margin-left: 2px !important;
}

.nq-productconfig-footer-discount {
	font-size: 12px !important;
	color: #1677ff !important;
	font-weight: 600 !important;
	display: inline-block !important;
	white-space: nowrap !important;
}
.nq-productconfig-footer-nodiscount {
	color: #94a3b8 !important;
	font-weight: 400 !important;
	border-bottom: 1px dashed #cbd5e1 !important;
}

.nq-productconfig-footer-note {
	font-size: 11px !important;
	color: #94a3b8 !important;
	margin-top: 4px !important;
	line-height: 1.4 !important;
	display: block !important;
	white-space: normal !important;
	word-break: break-all !important;
}

.nq-productconfig-footer-right {
	display: flex !important;
	flex-direction: row !important;
	align-items: center !important;
	justify-content: flex-end !important;
	gap: 16px !important;
	flex-shrink: 0 !important;
	margin-left: auto !important;
	box-sizing: border-box !important;
	white-space: nowrap !important;
}

.nq-productconfig-footer-detail {
	position: relative !important;
	display: inline-flex !important;
	align-items: center !important;
}

.nq-productconfig-footer-detail-trigger {
	display: inline-flex !important;
	align-items: center !important;
	font-size: 13px !important;
	color: #d97706 !important;
	cursor: pointer !important;
	white-space: nowrap !important;
	user-select: none !important;
	border-bottom: 1px dashed #f59e0b !important;
	transition: all 0.2s ease !important;
	padding: 2px 0 !important;
}
.nq-productconfig-footer-detail-trigger:hover {
	color: #b45309 !important;
}
.nq-productconfig-footer-detail-arrow {
	transition: transform 0.25s ease !important;
}
.nq-productconfig-footer-detail.open .nq-productconfig-footer-detail-arrow {
	transform: rotate(180deg) !important;
}

#addToCartBtn {
	display: inline-flex !important;
	align-items: center !important;
	justify-content: center !important;
	height: 40px !important;
	line-height: 40px !important;
	padding: 0 24px !important;
	min-width: 140px !important;
	width: auto !important;
	max-width: 220px !important;
	font-size: 14px !important;
	font-weight: 600 !important;
	border-radius: 4px !important;
	background: #1677ff !important;
	color: #ffffff !important;
	border: none !important;
	box-shadow: 0 2px 8px rgba(22, 119, 255, 0.25) !important;
	cursor: pointer !important;
	white-space: nowrap !important;
	box-sizing: border-box !important;
	transition: all 0.2s ease !important;
}
#addToCartBtn:hover {
	background: #0958d9 !important;
}

/* 按钮加载态：默认隐藏正在提交，仅激活时切换 */
#addToCartBtn .btn-text {
	display: inline-flex !important;
	align-items: center !important;
	justify-content: center !important;
}
#addToCartBtn .btn-loading {
	display: none !important;
}
#addToCartBtn.is-loading .btn-text {
	display: none !important;
}
#addToCartBtn.is-loading .btn-loading {
	display: inline-flex !important;
	align-items: center !important;
	justify-content: center !important;
	gap: 6px !important;
}
.nq-spinner {
	display: inline-block !important;
	width: 14px !important;
	height: 14px !important;
	border: 2px solid rgba(255, 255, 255, 0.35) !important;
	border-top-color: #ffffff !important;
	border-radius: 50% !important;
	animation: nqSpin 0.7s linear infinite !important;
	flex-shrink: 0 !important;
}
@keyframes nqSpin {
	to { transform: rotate(360deg); }
}

/* 费用明细抽屉面板 */
.nq-productconfig-footer-breakdown {
	position: absolute !important;
	bottom: calc(100% + 12px) !important;
	right: 0 !important;
	min-width: 480px !important;
	max-width: 90vw !important;
	background: #ffffff !important;
	border: 1px solid #e2e8f0 !important;
	border-radius: 8px !important;
	box-shadow: 0 12px 30px rgba(15, 23, 42, 0.15) !important;
	z-index: 1000 !important;
	overflow: hidden !important;
}
.nq-productconfig-footer-breakdown-title {
	padding: 12px 16px !important;
	font-size: 14px !important;
	font-weight: 600 !important;
	color: #1e293b !important;
	border-bottom: 1px solid #f1f5f9 !important;
	display: flex !important;
	justify-content: space-between !important;
	align-items: center !important;
	background: #f8fafc !important;
}
.nq-productconfig-footer-breakdown-total em {
	font-style: normal !important;
	font-weight: 700 !important;
	color: #ef4444 !important;
}
.nq-breakdown-close {
	background: transparent !important;
	border: none !important;
	font-size: 16px !important;
	color: #94a3b8 !important;
	cursor: pointer !important;
	padding: 0 4px !important;
	line-height: 1 !important;
}
.nq-productconfig-footer-breakdown-body {
	max-height: 320px !important;
	overflow-y: auto !important;
}
.nq-productconfig-footer-breakdown table {
	width: 100% !important;
	border-collapse: collapse !important;
}
.nq-productconfig-footer-breakdown th {
	padding: 8px 16px !important;
	font-size: 12px !important;
	color: #475569 !important;
	font-weight: 600 !important;
	background: #f1f5f9 !important;
	text-align: left !important;
	border: none !important;
}
.nq-productconfig-footer-breakdown td {
	padding: 9px 16px !important;
	font-size: 13px !important;
	color: #334155 !important;
	border-bottom: 1px solid #f8fafc !important;
	border-top: none !important;
}
.nq-productconfig-footer-breakdown td:last-child {
	text-align: right !important;
	font-weight: 600 !important;
	color: #0f172a !important;
}

@media (max-width: 768px) {
	.nq-ordersummary-bar,
	.configoption_total {
		flex-direction: column !important;
		align-items: stretch !important;
		padding: 10px 14px !important;
		gap: 10px !important;
	}
	.nq-productconfig-footer-left {
		min-width: 0 !important;
	}
	.nq-productconfig-footer-right {
		justify-content: space-between !important;
		width: 100% !important;
	}
	#addToCartBtn {
		flex: 1 1 auto !important;
		max-width: none !important;
	}
	.nq-productconfig-footer-breakdown {
		min-width: 90vw !important;
	}
}
</style>

<div class="nq-ordersummary-bar configoption_total">
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
