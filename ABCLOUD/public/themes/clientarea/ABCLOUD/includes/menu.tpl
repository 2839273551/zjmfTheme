<!-- ========== Left Sidebar Start (ABCLOUD APE Style) ========== -->
{if $Userinfo}
<div class="vertical-menu">
	<div data-simplebar class="h-100">
		<div id="sidebar-menu" class="menu-js">
			<ul class="metismenu list-unstyled" id="side-menu">
				{foreach $Nav as $nv}
				<li>
					<a href="{if $nv.child}javascript:;{else}{$nv.url}{/if}" class="{if $nv.child}has-arrow{/if} waves-effect">
						{if $nv.fa_icon}<i class="{$nv.fa_icon}"></i>{else}<i class="bx bx-cube"></i>{/if}
						{if (isset($nv.tag))}
							{$nv.tag}
						{/if}
						<span>{$nv.name}</span>
					</a>
					{if $nv.child}
					<ul class="sub-menu mm-collapse" aria-expanded="false">
						{foreach $nv.child as $subnav}
						<li>
							<a href="{if $subnav.child}javascript:;{else}{$subnav.url}{/if}"
								class="{if $subnav.child}has-arrow{/if} waves-effect">
								{if $subnav.fa_icon}<i class="{$subnav.fa_icon}"></i>{/if}
								{if (isset($subnav.tag))}
									{$subnav.tag}
								{/if}
								<span>{$subnav.name}</span>
							</a>
							{if $subnav.child}
							<ul class="sub-menu" aria-expanded="false">
								{foreach $subnav.child as $submenu}
								<li>
									<a href="{if $submenu.child}javascript:;{else}{$submenu.url}{/if}"
										class="{if $submenu.child}has-arrow{/if} waves-effect">
										{if $submenu.fa_icon}<i class="{$submenu.fa_icon}"></i>{/if}
										{if (isset($submenu.tag))}
											{$submenu.tag}
										{/if}
										<span>{$submenu.name}</span>
									</a>
								</li>
								{/foreach}
							</ul>
							{/if}
						</li>
						{/foreach}
					</ul>
					{/if}
				</li>
				{/foreach}
			</ul>
		</div>
	</div>
</div>
{else/}
<div class="vertical-menu menu-js">
	<div data-simplebar class="h-100">
		<div id="sidebar-menu" class="menu-js">
			<ul class="metismenu list-unstyled" id="side-menu">
				<li>
					<a href="/clientarea" class="waves-effect">
						<i class="bx bx-home-circle"></i>
						<span>控制台首页</span>
					</a>
				</li>
				<li>
					<a href="/login" class="waves-effect">
						<i class="bx bx-log-in-circle"></i>
						<span>立即登录</span>
					</a>
				</li>
				<li>
					<a href="/register" class="waves-effect">
						<i class="bx bx-user-plus"></i>
						<span>免费注册</span>
					</a>
				</li>
				<li>
					<a href="/cart" class="waves-effect">
						<i class="bx bx-cart-alt"></i>
						<span>订购产品</span>
					</a>
				</li>
				<li>
					<a href="/news" class="waves-effect">
						<i class="bx bx-news"></i>
						<span>新闻公告</span>
					</a>
				</li>
				<li>
					<a href="/knowledgebase" class="waves-effect">
						<i class="bx bx-help-circle"></i>
						<span>帮助中心</span>
					</a>
				</li>
				<li>
					<a href="/downloads" class="waves-effect">
						<i class="bx bx-download"></i>
						<span>资源下载</span>
					</a>
				</li>
			</ul>
		</div>
	</div>
</div>
{/if}
