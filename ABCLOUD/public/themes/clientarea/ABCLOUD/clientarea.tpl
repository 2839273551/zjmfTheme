<!-- ABCLOUD Client Area Dashboard (Faithful Port of APE User Center) -->
<div class="row">
	<!-- Left Column: User Profile, Metrics, and Resources -->
	<div class="col-xl-8 col-lg-12">
		<!-- 1. User Profile & VIP Status -->
		<div class="abcloud-card abcloud-user-info-card">
			<div class="abcloud-user-info-header">
				<div class="abcloud-user-avatar">
					{if preg_match("/^[0-9]*[A-Za-z]+$/is", substr($Userinfo.user.username,0,1))}
						{$Userinfo.user.username|substr=0,1|upper|htmlentities}
					{elseif preg_match("/^[\x7f-\xff]*$/", substr($Userinfo.user.username,0,3))}
						{$Userinfo.user.username|substr=0,3|htmlentities}
					{else}
						{$Userinfo.user.username|substr=0,1|upper|htmlentities}
					{/if}
				</div>

				<div class="abcloud-user-details">
					<div class="abcloud-user-name-row">
						<span class="abcloud-user-name">{$Userinfo.user.username|htmlentities}</span>
						<span class="abcloud-user-id-badge">ID: {$Userinfo.user.id|intval}</span>
						{if $Userinfo.user.certifi.status == 1}
							<span class="abcloud-cert-tag ok"><i class="bx bx-check-shield"></i> 已实名认证</span>
						{else}
							<a href="/verified" class="abcloud-cert-tag uncert"><i class="bx bx-shield-quarter"></i> 未实名认证，去认证</a>
						{/if}
					</div>

					<div class="abcloud-user-contacts">
						<span><i class="bx bx-mobile text-primary"></i> 手机：{if $Userinfo.user.phonenumber}{$Userinfo.user.phonenumber|substr=0,3|htmlentities}****{$Userinfo.user.phonenumber|substr=-4|htmlentities}{else}--{/if}</span>
						<span><i class="bx bx-envelope text-primary"></i> 邮箱：{if $Userinfo.user.email}{$Userinfo.user.email|htmlentities}{else}--{/if}</span>
					</div>
				</div>
			</div>

			<!-- 4 Status Badges -->
			<div class="abcloud-status-icons">
				<span class="abcloud-status-badge {if $Userinfo.user.email}active{/if}">
					<i class="bx bx-envelope"></i> 邮箱{if $Userinfo.user.email}已绑定{else}未绑定{/if}
				</span>
				<span class="abcloud-status-badge {if $Userinfo.user.phonenumber}active{/if}">
					<i class="bx bx-mobile"></i> 手机{if $Userinfo.user.phonenumber}已验证{else}未验证{/if}
				</span>
				<span class="abcloud-status-badge {if $Userinfo.user.certifi.status == 1}active{/if}">
					<i class="bx bx-id-card"></i> 实名{if $Userinfo.user.certifi.status == 1}已通过{else}未认证{/if}
				</span>
					<a href="/affiliates" class="abcloud-status-badge"><i class="bx bx-gift"></i> 推介计划</a>
			</div>

			<!-- APE VIP Level Card -->
			<div class="abcloud-vip-banner">
				<img class="abcloud-vip-img" id="abcloudVipImg" src="/themes/clientarea/ABCLOUD/assets/img/vip/why.png" alt="会员等级" />
				<div class="abcloud-vip-info">
					<div class="abcloud-vip-title-row">
							<span class="abcloud-vip-title" id="abcloudVipTitle">{$Userinfo.client_group.group_name|default='默认分组'|htmlentities}</span>
							<span class="abcloud-vip-tag" id="abcloudVipTag">当前用户分组</span>
					</div>
					<p class="abcloud-vip-text" id="abcloudVipDesc">
							本月消费金额：{$ClientArea.index.intotal|htmlentities}
					</p>
				</div>
			</div>

			<!-- Quick Actions -->
			<div class="abcloud-quick-actions">
				<a href="/details" class="abcloud-quick-btn">
					<i class="bx bx-user text-primary"></i> 账户设置
				</a>
				<a href="/security" class="abcloud-quick-btn">
					<i class="bx bx-shield-quarter text-success"></i> 安全中心
				</a>
				<a href="/verified" class="abcloud-quick-btn">
					<i class="bx bx-id-card text-info"></i> 实名认证
				</a>
				<a href="/billing" class="abcloud-quick-btn">
					<i class="bx bx-receipt text-warning"></i> 账单记录
				</a>
				<a href="/supporttickets" class="abcloud-quick-btn">
					<i class="bx bx-support text-danger"></i> 工单列表
				</a>
			</div>
		</div>

		<!-- 2. 4 Metric Counters (Harmonious in Left Column) -->
		<div class="abcloud-stats-grid">
			<a href="/supporttickets" class="abcloud-stat-card">
				<div class="abcloud-stat-info">
					<span class="abcloud-stat-label">待处理工单</span>
					<span class="abcloud-stat-num text-warning">{$ClientArea.index.ticket_count}</span>
				</div>
				<div class="abcloud-stat-icon-wrap orange">
					<i class="bx bx-support"></i>
				</div>
			</a>

			<a href="/billing" class="abcloud-stat-card">
				<div class="abcloud-stat-info">
					<span class="abcloud-stat-label">待支付订单</span>
					<span class="abcloud-stat-num text-danger">{$ClientArea.index.order_count}</span>
				</div>
				<div class="abcloud-stat-icon-wrap blue">
					<i class="bx bx-credit-card"></i>
				</div>
			</a>

			<a href="/service" class="abcloud-stat-card">
				<div class="abcloud-stat-info">
					<span class="abcloud-stat-label">已开通产品总数</span>
					<span class="abcloud-stat-num text-success">{$ClientArea.index.host}</span>
				</div>
				<div class="abcloud-stat-icon-wrap green">
					<i class="bx bx-server"></i>
				</div>
			</a>

			<a href="/security" class="abcloud-stat-card">
				<div class="abcloud-stat-info">
						<span class="abcloud-stat-label">安全手机</span>
						<span class="abcloud-stat-num text-primary">{if $Userinfo.user.phonenumber}已绑定{else}未绑定{/if}</span>
				</div>
				<div class="abcloud-stat-icon-wrap purple">
					<i class="bx bx-shield-check"></i>
				</div>
			</a>
		</div>

		<!-- 3. Product Categories (If active) -->
		{if $ClientArea.index.host_nav}
			<div class="abcloud-card">
				<div class="abcloud-card-title">
					<span>已开通业务分类</span>
					<a href="/service" class="font-size-12 text-primary font-weight-normal">全部业务 <i class="bx bx-chevron-right"></i></a>
				</div>
				<div class="abcloud-groups-grid">
					{foreach $ClientArea.index.host_nav as $list}
							<a href="/service?groupid={$list.id|intval}" class="abcloud-group-item">
								<span><i class="bx bx-cube mr-1 text-primary"></i>{$list.groupname|htmlentities}</span>
							<span class="abcloud-group-count">({$list.count})</span>
						</a>
					{/foreach}
				</div>
			</div>
		{/if}

		<!-- 4. Resource List (Live Host AJAX) -->
		<div class="abcloud-card">
			<div class="abcloud-card-title">
				<span>我的资源列表</span>
				<div class="d-flex gap-2">
					<a href="/cart" class="btn btn-sm btn-primary py-1 px-3">
						<i class="bx bx-plus font-size-12 mr-1"></i>新建实例
					</a>
				</div>
			</div>

			<div id="sourceListBox">
				<div class="py-4 text-center text-muted">
					<i class="bx bx-loader bx-spin font-size-18 mr-2"></i>正在加载资源列表...
				</div>
			</div>
		</div>
	</div>

	<!-- Right Column: Financial Assets, Announcements, and Security Tips -->
	<div class="col-xl-4 col-lg-12">
		<!-- 1. Financial Assets (Compact, Natural Height) -->
		<div class="abcloud-card abcloud-finance-box">
			<div class="abcloud-card-title">
				<span>费用与资产信息</span>
				<a href="/billing" class="font-size-12 text-primary font-weight-normal">全部账单 <i class="bx bx-chevron-right"></i></a>
			</div>

			<div class="abcloud-balance-row">
				<div>
					<div class="abcloud-balance-label">当前可用余额</div>
					<div class="abcloud-balance-amount">{$ClientArea.index.client.credit}</div>
				</div>
				{if $ClientArea.index.allow_recharge == '1'}
					<a href="/addfunds" class="abcloud-recharge-btn">
						<i class="bx bx-wallet"></i> 在线充值
					</a>
				{/if}
			</div>

			<div class="abcloud-finance-tiles">
				<a href="/billing" class="abcloud-finance-tile">
					<div class="abcloud-finance-tile-title">未支付金额</div>
					<div class="abcloud-finance-tile-value text-danger">{$ClientArea.index.invoice_unpaid}</div>
				</a>
				<a href="/billing" class="abcloud-finance-tile">
					<div class="abcloud-finance-tile-title">本月累计消费</div>
					<div class="abcloud-finance-tile-value text-primary">{$ClientArea.index.intotal}</div>
				</a>
			</div>

			<div class="abcloud-finance-footer-link">
				<div class="d-flex justify-content-between align-items-center font-size-13 text-muted">
					<span>资金流水明细</span>
					<a href="/transaction" class="text-primary font-weight-500">查看明细 <i class="bx bx-right-arrow-alt"></i></a>
				</div>
			</div>
		</div>

		<!-- 2. Latest Announcements -->
		<div class="abcloud-card">
			<div class="abcloud-card-title">
				<span>官方新闻与公告</span>
				<a href="/news" class="font-size-12 text-primary font-weight-normal">更多公告 <i class="bx bx-chevron-right"></i></a>
			</div>

			<ul class="abcloud-news-list">
				{if $ClientArea.index.news}
					{foreach $ClientArea.index.news as $idx => $list}
						<li class="abcloud-news-item">
							<span class="abcloud-news-rank {if $idx == 0}top-1{elseif $idx == 1}top-2{elseif $idx == 2}top-3{/if}">
								{$idx + 1}
							</span>
								<a href="/newsview?id={$list.id|intval}" class="abcloud-news-title" title="{$list.title|htmlentities}">
									{$list.title|htmlentities}
							</a>
							<span class="abcloud-news-time">
								{$list.push_time|date="m-d"}
							</span>
						</li>
					{/foreach}
				{else}
					<li class="py-3 text-center text-muted font-size-13">暂无最新公告</li>
				{/if}
			</ul>
		</div>

		<!-- 3. Safety Tips Card -->
		<div class="abcloud-card">
			<div class="abcloud-card-title">
				<span>安全提醒与帮助</span>
				<a href="/security" class="font-size-12 text-primary font-weight-normal">安全中心 <i class="bx bx-chevron-right"></i></a>
			</div>

			<div class="font-size-13 text-muted">
				<div class="mb-3 d-flex align-items-start gap-2">
					<i class="bx bx-check-shield text-success font-size-16 mt-1"></i>
					<span>请妥善保管账号密码，切勿将验证码泄露给他人。</span>
				</div>
				<div class="mb-3 d-flex align-items-start gap-2">
					<i class="bx bx-key text-primary font-size-16 mt-1"></i>
					<span>建议定期修改密码并绑定安全手机，提升账号防护等级。</span>
				</div>
				<div class="d-flex align-items-start gap-2">
					<i class="bx bx-help-circle text-info font-size-16 mt-1"></i>
					<span>如遇机器或网络异常，可随时前往工单中心提交问题。</span>
				</div>
			</div>

			<div class="mt-4 pt-3 border-top d-flex gap-2">
				<a href="/submitticket" class="btn btn-outline-primary btn-sm flex-1">
					<i class="bx bx-edit font-size-12 mr-1"></i>提交工单
				</a>
				<a href="/knowledgebase" class="btn btn-outline-secondary btn-sm flex-1">
					<i class="bx bx-book-open font-size-12 mr-1"></i>帮助文档
				</a>
			</div>
		</div>
	</div>
</div>

<!-- Full-Width Bottom Promo Banner (Spans 12 Columns, Seamlessly Aligned) -->
<div class="row">
	<div class="col-12">
		<div class="abcloud-promo-full-banner">
			<div class="d-flex align-items-center justify-content-between flex-wrap" style="gap: 16px;">
				<div style="flex: 1; min-width: 280px;">
					<div class="d-flex align-items-center" style="gap: 10px;">
						<div style="width: 40px; height: 40px; border-radius: 8px; background: #ffffff; display: flex; align-items: center; justify-content: center; box-shadow: 0 2px 6px rgba(0, 110, 255, 0.15); flex-shrink: 0;">
							<i class="bx bx-gift text-primary" style="font-size: 22px;"></i>
						</div>
						<h4 style="font-size: 16px; font-weight: 700; color: #1e3a8a; margin: 0;">
								推介计划
						</h4>
					</div>
					<p style="font-size: 13px; color: #3b82f6; margin: 8px 0 0 50px;">
							查看本站推介计划、参与条件与返佣规则。
					</p>
				</div>
				<a href="/affiliates" class="btn btn-primary px-4 py-2 font-weight-600" style="border-radius: 6px; box-shadow: 0 4px 12px rgba(0, 110, 255, 0.25); white-space: nowrap;">
					立即推广 <i class="bx bx-right-arrow-alt font-size-16 align-middle ml-1"></i>
				</a>
			</div>
		</div>
	</div>
</div>

<script>
	$(function () {
		// Asynchronous load resource list
		getSourceList();

	});

	function getSourceList() {
		$.ajax({
			type: "get",
				url: '/clientarea',
				dataType: 'html',
				timeout: 20000,
			data: { action: 'list' },
			success: function (data) {
					if (typeof data === 'string' && data.trim() && !/<(?:html|body)\b/i.test(data)) {
					$('#sourceListBox').html(data);
				} else {
						showResourceError();
				}
			},
			error: function () {
					showResourceError();
			}
		});
	}

		function showResourceError() {
		$('#sourceListBox').html(
			'<div class="abcloud-empty-state">' +
					'<p>资源列表加载失败，请刷新页面或前往产品列表。</p>' +
					'<a href="/service" class="btn btn-sm btn-primary px-3">' +
					'<i class="bx bx-server font-size-12 mr-1"></i>查看我的产品' +
				'</a>' +
			'</div>'
		);
	}

</script>
